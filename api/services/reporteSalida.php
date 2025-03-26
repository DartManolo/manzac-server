<?php
    Class ReporteSalida {
        public static function alta($params) {
            Auth::verify();
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
    }
?>