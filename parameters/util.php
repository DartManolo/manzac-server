<?php
    Class Util {
        function __construct() { }

        public static function guardarImagen($params) {
            try {
                $imagen_logo = (object)$params;
                $ruta = $imagen_logo->ruta;
                $nombre = $imagen_logo->nombre;
                $extension = $imagen_logo->extension;
                $imagen_base64 = base64_decode($imagen_logo->imagenBase64);
                file_put_contents("$ruta/$nombre.$extension", $imagen_base64);
                return true;
            } catch (Exception $e) {
                return false;
            }
        }

        public static function leerImagen($params) {
            try {
                $imagen_data = (object)$params;
                $imagen_nombre = $imagen_data->nombre;
                $ruta = $imagen_data->ruta;
                $imagen = "$ruta/$imagen_nombre";
                if(file_exists($imagen)) {
                    $contenido = file_get_contents($imagen);
                    $base64 = base64_encode($contenido);
                    return $base64;
                } else {
                    throw new Exception();
                }
            } catch (Exception $e) {
                return "error";
            }
        }
    
        public static function guid() {
            $guid_cadena = sprintf(
                '%04X%04X-%04X-%04X-%04X-%04X%04X%04X',
                mt_rand(0, 65535),
                mt_rand(0, 65535),
                mt_rand(0, 65535),
                mt_rand(16384, 20479),
                mt_rand(32768, 49151),
                mt_rand(0, 65535),
                mt_rand(0, 65535),
                mt_rand(0, 65535)
            );
            return strtolower($guid_cadena);   
        }
    }
?>