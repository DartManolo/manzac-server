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

        public static function obtenerConfiguracionUsuario($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de configuración incorrectos");
            }
            $id_usuario = $params[0];
            $mysql = new Mysql();
            $resultado_configuracion = $mysql->executeReader(
                "CALL STP_OBTENER_CONFIGURACION_USUARIO('{$id_usuario}')",
                true
            );
            return json_encode($resultado_configuracion);
        }

        public static function altaFirma($params) {
            Auth::verify();
            $firma_data = (object)$params;
            if(!isset($firma_data->nombre) 
                || !isset($firma_data->contenido)) {
                http_response_code(406);
                die("Parámetros de firma incorrectos");
            }
            $alta_firma = Util::guardarTxt($firma_data);
            return json_encode($alta_firma);
        }
    }
?>