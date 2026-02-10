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

        public static function guardarTxt($params) {
            try {
                $archivo_txt = (object)$params;
                $archivo = $archivo_txt->nombre;
                $contenido = $archivo_txt->contenido;
                if (file_put_contents($archivo, $contenido) !== false) {
                    return true;
                } else {
                    return false;
                }
            } catch (Exception $e) {
                return false;
            }
        }

        public static function leerTxt($params) {
            try {
                if (file_exists($params)) {
                    $contenido = file_get_contents($params);
                    return $contenido;
                } else {
                    return "error";
                }
            } catch (Exception $e) {
                return "error";
            }
        }

        public static function crearArchivo($nombre_archivo, $contenido) {
            try {
                $archivo = fopen($nombre_archivo, "w");
                if ($archivo) {
                    fwrite($archivo, $contenido);
                    fclose($archivo);
                }
            } finally { }
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

        public static function esFecha($fecha) {
            $d = DateTime::createFromFormat('Y-m-d', $fecha);
            return $d && $d->format('Y-m-d') === $fecha;
        }

        public static function log($e) {
            $mysql = new Mysql();
            $error = new stdClass();
            $error->mensaje = $e->getMessage();
            $error->archivo = $e->getFile();
            $error->linea = $e->getLine();
            $error->pila = $e->getTraceAsString();
            $alta_log = $mysql->executeNonQuery(
                "CALL STP_ALTA_ERROR_LOG(?,?,?,?)",
                $error
            );
        }
    }
?>