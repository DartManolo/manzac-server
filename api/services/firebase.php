<?php
    Class Firebase {
        public static function enviarNotificacion($params) {
            Auth::verify();
            $notif_form = (object)$params;
            if(!isset($notif_form->titulo) 
                || !isset($notif_form->cuerpo)
                || !isset($notif_form->ids)
                || !isset($notif_form->data)) {
                http_response_code(406);
                die("Parámetros de notificación incorrectos");
            }
            $send = self::fcmSend($notif_form);
            return json_encode($send);
        }

        public static function enviarNotificacionExternal($params) {
            $notif_form = (object)$params;
            $send = self::fcmSend($notif_form);
            return json_encode($send);
        }

        static function fcmSend($notif_form) {
            $notification = self::crearNotificacionMsg(
                $notif_form->titulo,
                $notif_form->cuerpo,
                $notif_form->ids,
                $notif_form->data
            );
            $fcm_token = self::crearTokenFCM();
            $project_id = $fcm_token->projectId;
            $access_token = $fcm_token->token;
            $fcm_url = "https://fcm.googleapis.com/v1/projects/{$project_id}/messages:send";
            $ch = curl_init($fcm_url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "Authorization: Bearer {$access_token}",
                "Content-Type: application/json"
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($notification));
            $result = curl_exec($ch);
            curl_close($ch);
            $fcm_result = json_decode($result);
            return isset($fcm_result->name);
        }

        static function crearTokenFCM() {
            if(!$google_file = file_get_contents('../api/24da93be-673f-49f5-b71c-b756724e8e8d/service-account.json')) {
                $google_file = file_get_contents(realpath(__DIR__ . '/../../api/24da93be-673f-49f5-b71c-b756724e8e8d/service-account.json'));
            }
            $credentials = json_decode($google_file, true);
            $now = time();
            $jwt_header = ['alg' => 'RS256', 'typ' => 'JWT'];
            $jwt_claims = [
                'iss' => $credentials['client_email'],
                'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
                'aud' => 'https://oauth2.googleapis.com/token',
                'iat' => $now,
                'exp' => $now + 3600
            ];
            $jwt_header_encoded = self::base64UrlEncode(json_encode($jwt_header));
            $jwt_claims_encoded = self::base64UrlEncode(json_encode($jwt_claims));
            $jwt_unsigned = $jwt_header_encoded . '.' . $jwt_claims_encoded;
            openssl_sign($jwt_unsigned, $signature, $credentials['private_key'], 'sha256');
            $jwt_signed = $jwt_unsigned . '.' . self::base64UrlEncode($signature);
            $ch = curl_init('https://oauth2.googleapis.com/token');
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt_signed
            ]));
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Content-Type: application/x-www-form-urlencoded'
            ]);
            $response = curl_exec($ch);
            curl_close($ch);
            $token_data = json_decode($response, true);
            $access_token = $token_data['access_token'];
            if (!$access_token) {
                return null;
            }
            $result = new stdClass();
            $result->token = $access_token;
            $result->projectId = $credentials['project_id'];
            return $result;
        }

        static function crearNotificacionMsg($titulo, $cuerpo, $ids, $data) {
            $id_notificacion = Util::guid();
            $data['idnotificacion'] = $id_notificacion;
            $notification = new stdClass();
            $notification->title = $titulo;
            $notification->body = $cuerpo;
            $android = new stdClass();
            $android->priority = "HIGH";
            $message = new stdClass();
            $message->token = $ids[0];
            $message->notification = $notification;
            $message->data = $data;
            $message->android = $android;
            $fcm_message = new stdClass();
            $fcm_message->message = $message;
            return $fcm_message;
        }

        static function base64UrlEncode($data) {
            return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
        }
    }
?>