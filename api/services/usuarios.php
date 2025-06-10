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
            $data_params = new stdClass();
            $data_params->token = Util::guid();
            $data_params->idSistema = Util::guid();
            $data_params->usuario = $usuario->usuario;
            $data_params->usuarioToken = $usuario->token;
            $data_params->status = $usuario->status;
            $data_params->nombres = $usuario->nombres;
            $data_params->apellidos = $usuario->apellidos;
            $data_params->perfil = $usuario->perfil;
            $alta_usuario = $mysql->executeNonQuery(
                "CALL STP_ALTA_USUARIO(?,?,?,?,?,?,?,?)",
                $data_params
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
            $mysql = new Mysql();
            $data_params = new stdClass();
            $data_params->usuario = $params[0];
            $data_params->estatus = $params[1];
            $actualizar = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_ESTATUS_USUARIO(?, ?)",
                $data_params
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

        public static function notificarAdminsForbidenLogout($params) {
            Auth::verify();
            $notificacion = (object)$params;
            if(!isset($notificacion->titulo) 
                || !isset($notificacion->cuerpo)
                || !isset($notificacion->idSistema)) {
                http_response_code(406);
                die("Parámetros de notificación incorrectos");
            }
            $mysql = new Mysql();
            $lista_usuarios = $mysql->executeReader(
                "CALL STP_OBTENER_USUARIOS()"
            );
            foreach($lista_usuarios as $lista_usuario) {
                $usuario = (object)$lista_usuario;
                if($usuario->perfil !== "ADMINISTRADOR"
                    || $usuario->idSistema === $notificacion->idSistema) {
                    continue;
                }
                $data = new stdClass();
                $data->accion = "USER-FORBIDEN-LOGOUT";
                $data->contenido = $notificacion->cuerpo;
                $msg = new stdClass();
                $msg->titulo = $notificacion->titulo;
                $msg->cuerpo = $notificacion->cuerpo;
                $msg->ids = array($usuario->idFirebase);
                $msg->data = $data;
                Firebase::enviarNotificacionExternal(json_decode(json_encode($msg), true));
            }
        }
    }
?>