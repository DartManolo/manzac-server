<?php
    Class Login {
        public static function iniciarSesion($params) {
            $login_form = (object)$params;
            if(!isset($login_form->usuario) 
                || !isset($login_form->password)) {
                http_response_code(406);
                die("Parámetros de inicio de sesión incorrectos");
            }
            $mysql = new Mysql();
            $resultado_login = $mysql->executeReader(
                "CALL STP_INICIAR_SESION('{$login_form->usuario}', '{$login_form->password}')",
                true
            );
            try {
                $data_param = new stdClass();
                $data_param->usuario = $login_form->usuario;
                $data_param->log = 'INICIO DE SESION';
                $resultado_actualizar = $mysql->executeNonQuery(
                    "CALL STP_USUARIO_LOG_INSERT(?,?)",
                    $data_param
                );
            } finally { }
            return json_encode($resultado_login);
        }

        public static function recuperarPassword($params) {
            $password_form = (object)$params;
            if(!isset($password_form->usuario)) {
                http_response_code(406);
                die("Parámetros de contraseña incorrectos");
            }
            $usuario = $password_form->usuario;
            $mysql = new Mysql();
            $verificar_usuario = $mysql->executeReader(
                "CALL STP_VERIFICAR_USUARIO('$usuario')",
                true
            );
            if($verificar_usuario->EXISTE <= 0) {
                return "NO-USUARIO";
            }
            $nueva_pass = rand(100000, 199999);
            $data_param = new stdClass();
            $data_param->usuario = $usuario;
            $data_param->password = $nueva_pass;
            $data_param->status = 'PASSTEMPORAL';
            $actualizar_password = $mysql->executeNonQuery(
                "CALL STP_RECUPERACION_USUARIO_PASSWORD(?,?,?)",
                $data_param
            );
            $email = new Email();
            if($email->nuevoPassword($usuario, $nueva_pass)) {
                return "PASSWORD-ENVIADO";
            }
            return "ERROR";
        }

        public static function actualizarPassword($params) {
            Auth::verify();
            $password_form = (object)$params;
            if(!isset($password_form->usuario)
                || !isset($password_form->password)) {
                http_response_code(406);
                die("Parámetros de contraseña incorrectos");
            }
            $data_param = new stdClass();
            $data_param->usuario = $password_form->usuario;
            $data_param->password = $password_form->password;
            $data_param->status = 'ACTIVO';
            $mysql = new Mysql();
            $actualizar_password = $mysql->executeNonQuery(
                "CALL STP_RECUPERACION_USUARIO_PASSWORD(?,?,?)",
                $data_param
            );
            return json_encode($actualizar_password == 1);
        }
    }
?>