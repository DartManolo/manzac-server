<?php
    Class Reportes {
        public static function alta($params) {
            try {
                Auth::verify();
                $mysql = new Mysql();
                foreach($params as $param) {
                    $reporte = (object)$param;
                    $id_tarja = "";
                    $imagenes = array();
                    $img_folder = "";
                    $tipo = "";
                    if($reporte->reporteEntrada != null) {
                        $entrada = (object)$reporte->reporteEntrada;
                        $id_tarja = $entrada->idTarja;
                        $imagenes = $entrada->imagenes;
                        $tipo = $entrada->tipo;
                        $img_folder = "../media/entradas";
                        $alta_entrada = $mysql->executeNonQuery(
                            "CALL STP_ALTA_REPORTE_ENTRADA(
                                '$entrada->idTarja', '$entrada->tipo', '$entrada->fecha', 
                                '$entrada->referenciaLm', '$entrada->imo', '$entrada->horaInicio', 
                                '$entrada->horaFin', '$entrada->cliente', '$entrada->mercancia', 
                                '$entrada->agenteAduanal', '$entrada->ejecutivo', '$entrada->contenedor', 
                                '$entrada->pedimento', '$entrada->sello', '$entrada->buque', 
                                '$entrada->refCliente', '$entrada->bultos', '$entrada->peso', 
                                '$entrada->terminal', '$entrada->fechaDespacho', '$entrada->diasLibres', 
                                '$entrada->fechaVencimiento', '$entrada->movimiento', '$entrada->observaciones', 
                                '$entrada->usuario' 
                            )"
                        );
                    } else if($reporte->reporteSalida != null) {
                        $salida = (object)$reporte->reporteSalida;
                        $id_tarja = $salida->idTarja;
                        $imagenes = $salida->imagenes;
                        $tipo = $salida->tipo;
                        $img_folder = "../media/salidas";
                        $alta_salida = $mysql->executeNonQuery(
                            "CALL STP_ALTA_REPORTE_SALIDA(
                                '$salida->idTarja', '$salida->tipo', '$salida->fecha', 
                                '$salida->referenciaLm', '$salida->imo', '$salida->horaInicio', 
                                '$salida->horaFin', '$salida->cliente', '$salida->mercancia', 
                                '$salida->agenteAduanal', '$salida->ejecutivo', '$salida->contenedor', 
                                '$salida->pedimento', '$salida->sello', '$salida->buque', 
                                '$salida->refCliente', '$salida->bultos', '$salida->peso', 
                                '$salida->terminal', '$salida->transporte', '$salida->operador', 
                                '$salida->placas', '$salida->licencia', '$salida->observaciones', 
                                '$salida->usuario' 
                            )"
                        );
                    } else if($reporte->reporteDanio != null) {
                        $danio = (object)$reporte->reporteDanio;
                        $id_tarja = $danio->idTarja;
                        $imagenes = $danio->imagenes;
                        $img_folder = "../media/danios";
                        $tipo = $danio->tipo;
                        $alta_danios = $mysql->executeNonQuery(
                            "CALL STP_ALTA_REPORTE_DANIOS(
                                '$danio->idTarja', '$danio->tipo', '$danio->fecha', '$danio->fechaCreado', 
                                '$danio->version', '$danio->clave', '$danio->fechaReporte', '$danio->lineaNaviera', 
                                '$danio->cliente', '$danio->numContenedor', '$danio->vacio', '$danio->lleno', 
                                '$danio->d20', '$danio->d40', '$danio->hc', '$danio->otro', '$danio->estandar', 
                                '$danio->opentop', '$danio->flatRack', '$danio->reefer', '$danio->reforzado', 
                                '$danio->numSello', '$danio->intPuertasIzq', '$danio->intPuertasDer', '$danio->intPiso', 
                                '$danio->intTecho', '$danio->intPanelLateralIzq', '$danio->intPanelLateralDer', 
                                '$danio->intPanelFondo', '$danio->extPuertasIzq', '$danio->extPuertasDer', 
                                '$danio->extPoste', '$danio->extPalanca', '$danio->extGanchoCierre', 
                                '$danio->extPanelIzq', '$danio->extPanelDer', '$danio->extPanelFondo', 
                                '$danio->extCantonera', '$danio->extFrisa', '$danio->observaciones', 
                                '$danio->usuario' 
                            )"
                        );
                    }
                    if(count($imagenes) > 0) {
                        $restablecer_imgs = $mysql->executeNonQuery(
                            "CALL STP_RESTABLECER_REPORTE_IMAGENES('$id_tarja')"
                        );
                        foreach($imagenes as $imagen_list) {
                            $imagen = (object)$imagen_list;
                            $img_folder_alta = $img_folder;
                            if($imagen->base64 != "") {
                                $nueva_imagen = new stdClass();
                                $nueva_imagen->ruta = $img_folder;
                                $nueva_imagen->nombre = $imagen->idImagen;
                                $nueva_imagen->extension = $imagen->formato;
                                $nueva_imagen->imagenBase64 = $imagen->base64;
                                $alta_archivo_img = Util::guardarImagen($nueva_imagen);
                            } else {
                                $img_folder_alta = "SIN_IMAGEN";
                            }
                            $alta_imagen_reporte = $mysql->executeNonQuery(
                                "CALL STP_ALTA_REPORTE_IMAGENES(
                                    '$imagen->idTarja', '$imagen->idImagen', '$imagen->formato', 
                                    $imagen->fila, $imagen->posicion, '$tipo',
                                    '$img_folder_alta', '$imagen->usuario' 
                                )"
                            );
                        }
                    }
                }
                return json_encode(true);
            } catch(Exception $e) {
                return json_encode(false);
            }
            //Auth::verify();
            //$reportes = new ArrayObject($params);
            //print_r($params);
            //die("Hola");
            //return json_encode($params);
            /*die(json_encode($params));
            foreach($params as $par) {
                $data_json = (object)$par;
                die(json_encode($data_json));
            }
            die(is_array($params));*/
            /*$leer_imagen = new stdClass();
            $leer_imagen->ruta = "../media/imgs";
            $leer_imagen->nombre = "dibujo2.jpg";
            $imagen_base64 = Util::leerImagen($leer_imagen);
            die($imagen_base64);*/
            /*foreach($params as $par) {
                $data_json = (object)$par;
                $nueva_imagen = new stdClass();
                $nueva_imagen->ruta = "../media/imgs";
                $nueva_imagen->nombre = Util::guid();
                $nueva_imagen->extension = "jpg";
                $nueva_imagen->imagenBase64 = $data_json->imagenb64;
                $alta_imagen = Util::guardarImagen($nueva_imagen);
                echo $alta_imagen;
            }*/
        }

        public static function consulta($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de consulta incorrectos");
            }
            $condicion = $params[0];
            $reportes = array();
            $entradas = array();
            $salidas = array();
            $danios = array();
            $mysql = new Mysql();
            if(Util::esFecha($condicion)) {
                $entradas = $mysql->executeReader(
                    "CALL STP_OBTENER_REPORTE_ENTRADA_FECHA(
                        '$condicion 00:00:00', 
                        '$condicion 23:59:59'
                    )"
                );
                $salidas = $mysql->executeReader(
                    "CALL STP_OBTENER_REPORTE_SALIDA_FECHA(
                        '$condicion 00:00:00', 
                        '$condicion 23:59:59'
                    )"
                );
                $danios = $mysql->executeReader(
                    "CALL STP_OBTENER_REPORTE_DANIOS_FECHA(
                        '$condicion 00:00:00', 
                        '$condicion 23:59:59'
                    )"
                );
            } else {
                $entradas = $mysql->executeReader(
                    "CALL STP_OBTENER_REPORTE_ENTRADA_IDTARJA('$condicion')"
                );
                $salidas = $mysql->executeReader(
                    "CALL STP_OBTENER_REPORTE_SALIDA_IDTARJA('$condicion')"
                );
                $danios = $mysql->executeReader(
                    "CALL STP_OBTENER_REPORTE_DANIOS_IDTARJA('$condicion')"
                );
            }
            foreach($entradas as $entrada) {
                $reporte = new stdClass();
                $reporte->tabla = "reporte_alta_local";
                $reporte->tipo = "Entrada";
                $reporte->imagenes = array();
                $reporte->reporteEntrada = (object)$entrada;
                $reporte->reporteSalida = null;
                $reporte->reporteDanio = null;
                array_push($reportes, $reporte);
            }
            foreach($salidas as $salida) {
                $reporte = new stdClass();
                $reporte->tabla = "reporte_alta_local";
                $reporte->tipo = "Salida";
                $reporte->imagenes = array();
                $reporte->reporteSalida = (object)$salida;
                $reporte->reporteEntrada = null;
                $reporte->reporteDanio = null;
                array_push($reportes, $reporte);
            }
            foreach($danios as $danio) {
                $reporte = new stdClass();
                $reporte->tabla = "reporte_alta_local";
                $reporte->tipo = "Daños";
                $reporte->imagenes = array();
                $reporte->reporteDanio = (object)$danio;
                $reporte->reporteEntrada = null;
                $reporte->reporteSalida = null;
                array_push($reportes, $reporte);
            }
            return json_encode($reportes);
        }

        public static function imagenes($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de consulta incorrectos");
            }
            $id_tarja = $params[0];
            $imagenes = array();
            $mysql = new Mysql();
            $imagenes_bd = $mysql->executeReader(
                "CALL STP_OBTENER_REPORTE_IMAGENES_IDTARJA('$id_tarja')"
            );
            foreach($imagenes_bd as $imagen_bd) {
                $imagen = new stdClass();
                $imagen->idTarja = $imagen_bd->id_tarja;
                $imagen->idImagen = $imagen_bd->id_imagen;
                $imagen->formato = $imagen_bd->formato;
                $imagen->fila = $imagen_bd->fila;
                $imagen->posicion = $imagen_bd->posicion;
                $base64 = "";
                if($imagen_bd->folder != "SIN_IMAGEN") {
                    $leer_imagen = new stdClass();
                    $leer_imagen->ruta = $imagen_bd->folder;
                    $leer_imagen->nombre = "$imagen_bd->id_imagen.$imagen_bd->formato";
                    $base64 = Util::leerImagen($leer_imagen);
                }
                $imagen->base64 = $base64;
                $imagen->tipo = $imagen_bd->tipo;
                $imagen->usuario = $imagen_bd->usuario;
                array_push($imagenes, $imagen);
            }
            return json_encode($imagenes);
        }
    }
?>