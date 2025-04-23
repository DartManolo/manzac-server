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
                $resultado_actualizar = $mysql->executeNonQuery(
                    "CALL STP_USUARIO_LOG_INSERT(
                        '{$login_form->usuario}',
                        'INICIO DE SESION'
                    )"
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
            $actualizar_password = $mysql->executeNonQuery(
                "CALL STP_RECUPERACION_USUARIO_PASSWORD('$usuario', '$nueva_pass', 'PASSTEMPORAL')"
            );
            $email = new Email();
            if($email->nuevoPassword($usuario, $nueva_pass)) {
                return "PASSWORD-ENVIADO";
            }
            return "ERROR";
        }

        public static function reestablecerPassword($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $usuario = $params[0];
            $nueva_pass = rand(1000, 9999);
            $mysql = new Mysql();
            $actualizar_password = $mysql->executeNonQuery(
                "CALL STP_RECUPERACION_USUARIO_PASSWORD('$usuario', '$nueva_pass', 'PASSTEMPORAL')"
            );
            return json_encode($nueva_pass);
        }

        public static function actualizarPassword($params) {
            Auth::verify();
            $password_form = (object)$params;
            if(!isset($password_form->usuario)
                || !isset($password_form->password)) {
                http_response_code(406);
                die("Parámetros de contraseña incorrectos");
            }
            $usuario = $password_form->usuario;
            $nueva_pass = $password_form->password;
            $mysql = new Mysql();
            $actualizar_password = $mysql->executeNonQuery(
                "CALL STP_RECUPERACION_USUARIO_PASSWORD('$usuario', '$nueva_pass', 'ACTIVO')"
            );
            return json_encode($actualizar_password == 1);
        }
    }
?>