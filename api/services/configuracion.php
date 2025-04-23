<?php
    Class Configuracion {
        public static function obtener($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de configuración incorrectos");
            }
            if($params[0] == "firmas") {
                $firma_operador = Util::leerTxt('../media/firmas/firma_operador.txt');
                $firma_gerencia = Util::leerTxt('../media/firmas/firma_gerencia.txt');
                $firmas = new stdClass();
                $firmas->firmaOperador = $firma_operador;
                $firmas->firmaGerencia = $firma_gerencia;
                return json_encode($firmas);
            }
            return "no-data";
        }

        public static function altaFirma($params) {
            Auth::verify();
            $firma_data = (object)$params;
            if(!isset($firma_data->nombre) 
                || !isset($firma_data->contenido)) {
                http_response_code(406);
                die("Parámetros de notificación incorrectos");
            }
            $alta_firma = Util::guardarTxt($firma_data);
            return json_encode($alta_firma);
        }

        public static function test($params) {
            /*$leer_imagen = new stdClass();
            $leer_imagen->ruta = "../media/imgs";
            $leer_imagen->nombre = "dibujo2.jpg";
            $imagen_base64 = Util::leerImagen($leer_imagen);
            die($imagen_base64);*/
            foreach($params as $par) {
                $data_json = (object)$par;
                $nueva_imagen = new stdClass();
                $nueva_imagen->ruta = "../media/imgs";
                $nueva_imagen->nombre = Util::guid();
                $nueva_imagen->extension = "jpg";
                $nueva_imagen->imagenBase64 = $data_json->imagenb64;
                $alta_imagen = Util::guardarImagen($nueva_imagen);
                echo $alta_imagen;
            }
        }

        public static function desvincularDispositivo($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de dispositivo incorrectos");
            }
            $mysql = new Mysql();
            $resultado_desvincular = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_SESION(
                    '{$params[0]}',
                    '{$params[1]}',
                    'NONE', 'NONE'
                )"
            );
            return json_encode($resultado_desvincular == 1);
        }

        public static function obtenerConfiguracionUsuario($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $mysql = new Mysql();
            $resultado_configuracion = $mysql->executeReader(
                "CALL STP_OBTENER_CONFIGURACION_USUARIO('{$id_usuario}')",
                true
            );
            return json_encode($resultado_configuracion);
        }

        public static function guardarImagenLogo($params) {
            Auth::verify();
            $imagen_logo = (object)$params;
            if(!isset($imagen_logo->idUsuario) 
                || !isset($imagen_logo->imagenBase64)) {
                http_response_code(406);
                die("Parámetros de notificación incorrectos");
            }
            $imagen_base64 = base64_decode($imagen_logo->imagenBase64);
            file_put_contents("../media/usuarios/{$imagen_logo->idUsuario}.jpg", $imagen_base64);
            return json_encode(true);
        }
    }
?>