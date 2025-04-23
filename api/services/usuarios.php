<?php
    Class Usuarios {
        public static function altaUsuario($params) {
            Auth::verify();
            $usuario = (object)$params;
            if(!isset($usuario->usuario) 
                || !isset($usuario->token)
                || !isset($usuario->nombres)
                || !isset($usuario->apellidos)
                || !isset($usuario->status)
                || !isset($usuario->perfil)) {
                http_response_code(406);
                die("Parámetros de inicio de sesión incorrectos");
            }
            $mysql = new Mysql();
            $verificar = $mysql->executeReader(
                "CALL STP_USUARIO_EXISTE('{$usuario->usuario}')",
                true
            );
            if($verificar->ACTIVO > 0) {
                return "USR-EXISTE";
            }
            $token = Util::guid();
            $id_sistema = Util::guid();
            $alta_usuario = $mysql->executeNonQuery(
                "CALL STP_ALTA_USUARIO(
                    '$token', '$id_sistema', '{$usuario->usuario}', 
                    '{$usuario->token}', '{$usuario->status}',
                    '{$usuario->nombres}', '{$usuario->apellidos}', '{$usuario->perfil}'
                )"
            );
            return json_encode($alta_usuario == 1);
        }

        public static function obtenerUsuarios($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $usuario = $params[0];
            $mysql = new Mysql();
            if($usuario == "TODOS") {
                $lista_usuarios = $mysql->executeReader(
                    "CALL STP_OBTENER_USUARIOS()"
                );
                return json_encode($lista_usuarios);
            }
            $usuario_consulta = $mysql->executeReader(
                "CALL STP_OBTENER_USUARIO('$usuario')",
                true
            );
            return json_encode($usuario_consulta);
        }

        public static function verificarEstatus($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $usuario = $params[0];
            $mysql = new Mysql();
            $verificar = $mysql->executeReader(
                "CALL STP_VERIFICAR_STATUS_USUARIO('$usuario')",
                true
            );
            return json_encode($verificar->ACTIVO > 0);
        }

        public static function actualizarEstatus($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $usuario = $params[0];
            $estatus = $params[1];
            $mysql = new Mysql();
            $actualizar = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_ESTATUS_USUARIO('$usuario', '$estatus')"
            );
            return json_encode($actualizar == 1);
        }

        public static function validarUsuario($params) {
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $usuario = $params[0];
            $mysql = new Mysql();
            $usuario_consulta = $mysql->executeReader(
                "CALL STP_OBTENER_USUARIO('$usuario')",
                true
            );
            if(!isset($usuario_consulta->idSistema)) {
                return "NO-USR";
            }
            if($usuario_consulta->status == "INACTIVO") {
                return "USR-INACTIVE";
            }
            return "OK";
        }
    }
?>