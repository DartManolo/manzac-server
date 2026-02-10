<?php
    Class Reportes {
        public static function alta($params) {
            try {
                Auth::verify();
                $fecha = date('Y-m-d H:i:s');
                $mysql = new Mysql();
                foreach($params as $param) {
                    $reporte = (object)$param;
                    $id_tarja = "";
                    $imagenes = array();
                    $img_folder = "";
                    $tipo = "";
                    $data_params = new stdClass();
                    if($reporte->reporteEntrada != null) {
                        $entrada = (object)$reporte->reporteEntrada;
                        $id_tarja = $entrada->idTarja;
                        $imagenes = $entrada->imagenes;
                        $tipo = $entrada->tipo;
                        $img_folder = "../media/entradas";
                        $data_params->idTarja = $entrada->idTarja;
                        $data_params->tipo = $entrada->tipo;
                        $data_params->fecha = $entrada->fecha;
                        $data_params->referenciaLm = $entrada->referenciaLm;
                        $data_params->imo = $entrada->imo;
                        $data_params->horaInicio = $entrada->horaInicio;
                        $data_params->horaFin = $entrada->horaFin;
                        $data_params->cliente = $entrada->cliente;
                        $data_params->mercancia = $entrada->mercancia;
                        $data_params->agenteAduanal = $entrada->agenteAduanal;
                        $data_params->ejecutivo = $entrada->ejecutivo;
                        $data_params->contenedor = $entrada->contenedor;
                        $data_params->pedimento = $entrada->pedimento;
                        $data_params->sello = $entrada->sello;
                        $data_params->buque = $entrada->buque;
                        $data_params->refCliente = $entrada->refCliente;
                        $data_params->bultos = $entrada->bultos;
                        $data_params->peso = $entrada->peso;
                        $data_params->terminal = $entrada->terminal;
                        $data_params->fechaDespacho = $entrada->fechaDespacho;
                        $data_params->diasLibres = $entrada->diasLibres;
                        $data_params->fechaVencimiento = $entrada->fechaVencimiento;
                        $data_params->movimiento = $entrada->movimiento;
                        $data_params->observaciones = $entrada->observaciones;
                        $data_params->usuario = $entrada->usuario;
                        $alta_entrada = $mysql->executeNonQuery(
                            "CALL STP_ALTA_REPORTE_ENTRADA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'$fecha')",
                            $data_params
                        );
                    } else if($reporte->reporteSalida != null) {
                        $salida = (object)$reporte->reporteSalida;
                        $id_tarja = $salida->idTarja;
                        $imagenes = $salida->imagenes;
                        $tipo = $salida->tipo;
                        $img_folder = "../media/salidas";
                        $data_params->idTarja = $salida->idTarja;
                        $data_params->tipo = $salida->tipo;
                        $data_params->fecha = $salida->fecha;
                        $data_params->referenciaLm = $salida->referenciaLm;
                        $data_params->imo = $salida->imo;
                        $data_params->horaInicio = $salida->horaInicio;
                        $data_params->horaFin = $salida->horaFin;
                        $data_params->cliente = $salida->cliente;
                        $data_params->mercancia = $salida->mercancia;
                        $data_params->agenteAduanal = $salida->agenteAduanal;
                        $data_params->ejecutivo = $salida->ejecutivo;
                        $data_params->contenedor = $salida->contenedor;
                        $data_params->pedimento = $salida->pedimento;
                        $data_params->sello = $salida->sello;
                        $data_params->buque = $salida->buque;
                        $data_params->refCliente = $salida->refCliente;
                        $data_params->bultos = $salida->bultos;
                        $data_params->peso = $salida->peso;
                        $data_params->terminal = $salida->terminal;
                        $data_params->transporte = $salida->transporte;
                        $data_params->operador = $salida->operador;
                        $data_params->placas = $salida->placas;
                        $data_params->licencia = $salida->licencia;
                        $data_params->observaciones = $salida->observaciones;
                        $data_params->usuario = $salida->usuario;
                        $alta_salida = $mysql->executeNonQuery(
                            "CALL STP_ALTA_REPORTE_SALIDA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'$fecha')",
                            $data_params
                        );
                    } else if($reporte->reporteDanio != null) {
                        $danio = (object)$reporte->reporteDanio;
                        $id_tarja = $danio->idTarja;
                        $imagenes = $danio->imagenes;
                        $img_folder = "../media/danios";
                        $tipo = $danio->tipo;
                        $data_params->idTarja = $danio->idTarja;
                        $data_params->tipo = $danio->tipo;
                        $data_params->fecha = $danio->fecha;
                        $data_params->fechaCreado = $danio->fechaCreado;
                        $data_params->version = $danio->version;
                        $data_params->clave = $danio->clave;
                        $data_params->fechaReporte = $danio->fechaReporte;
                        $data_params->lineaNaviera = $danio->lineaNaviera;
                        $data_params->cliente = $danio->cliente;
                        $data_params->numContenedor = $danio->numContenedor;
                        $data_params->vacio = $danio->vacio;
                        $data_params->lleno = $danio->lleno;
                        $data_params->d20 = $danio->d20;
                        $data_params->d40 = $danio->d40;
                        $data_params->hc = $danio->hc;
                        $data_params->otro = $danio->otro;
                        $data_params->estandar = $danio->estandar;
                        $data_params->opentop = $danio->opentop;
                        $data_params->flatRack = $danio->flatRack;
                        $data_params->reefer = $danio->reefer;
                        $data_params->reforzado = $danio->reforzado;
                        $data_params->numSello = $danio->numSello;
                        $data_params->intPuertasIzq = $danio->intPuertasIzq;
                        $data_params->intPuertasDer = $danio->intPuertasDer;
                        $data_params->intPiso = $danio->intPiso;
                        $data_params->intTecho = $danio->intTecho;
                        $data_params->intPanelLateralIzq = $danio->intPanelLateralIzq;
                        $data_params->intPanelLateralDer = $danio->intPanelLateralDer;
                        $data_params->intPanelFondo = $danio->intPanelFondo;
                        $data_params->extPuertasIzq = $danio->extPuertasIzq;
                        $data_params->extPuertasDer = $danio->extPuertasDer;
                        $data_params->extPoste = $danio->extPoste;
                        $data_params->extPalanca = $danio->extPalanca;
                        $data_params->extGanchoCierre = $danio->extGanchoCierre;
                        $data_params->extPanelIzq = $danio->extPanelIzq;
                        $data_params->extPanelDer = $danio->extPanelDer;
                        $data_params->extPanelFondo = $danio->extPanelFondo;
                        $data_params->extCantonera = $danio->extCantonera;
                        $data_params->extFrisa = $danio->extFrisa;
                        $data_params->observaciones = $danio->observaciones;
                        $data_params->usuario = $danio->usuario;
                        $alta_danios = $mysql->executeNonQuery(
                            "CALL STP_ALTA_REPORTE_DANIOS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'$fecha')",
                            $data_params
                        );
                    }
                    if(count($imagenes) > 0) {
                        $data_params = new stdClass();
                        $data_params->idTarja = $id_tarja;
                        $restablecer_imgs = $mysql->executeNonQuery(
                            "CALL STP_RESTABLECER_REPORTE_IMAGENES(?)",
                            $data_params
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
                            $data_params = new stdClass();
                            $data_params->idTarja = $imagen->idTarja;
                            $data_params->idImagen = $imagen->idImagen;
                            $data_params->formato = $imagen->formato;
                            $data_params->fila = $imagen->fila;
                            $data_params->posicion = $imagen->posicion;
                            $data_params->tipo = $tipo;
                            $data_params->imgFolderAlta = $img_folder_alta;
                            $data_params->usuario = $imagen->usuario;
                            $alta_imagen_reporte = $mysql->executeNonQuery(
                                "CALL STP_ALTA_REPORTE_IMAGENES(?,?,?,?,?,?,?,?,'$fecha')",
                                $data_params
                            );
                        }
                    }
                }
                return json_encode(true);
            } catch(Exception $e) {
                Util::log($e);
                return json_encode(false);
            } catch(Error $e) {
                Util::log($e);
                return json_encode(false);
            } finally {
                $nombre_archivo = Util::guid();
                Util::crearArchivo("../logserror/$nombre_archivo.txt", json_encode($params));
            }
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

        public static function imagenesEmpty($params) {
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
                    $base64 = "URL";
                }
                $imagen->base64 = $base64;
                $imagen->tipo = $imagen_bd->tipo;
                $imagen->usuario = $imagen_bd->usuario;
                array_push($imagenes, $imagen);
            }
            return json_encode($imagenes);
        }

        public static function imagenesPaginado($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1])
                || !isset($params[2]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de consulta incorrectos");
            }
            $id_tarja = $params[0];
            $ini_pag = intval($params[1]);
            $fin_pag = intval($params[2]);
            $imagenes = array();
            $mysql = new Mysql();
            $imagenes_bd = $mysql->executeReader(
                "CALL STP_OBTENER_REPORTE_IMAGENES_IDTARJA('$id_tarja')"
            );
            $cont = 0;
            foreach($imagenes_bd as $imagen_bd) {
                $cont++;
                if($cont < $ini_pag || $cont > $fin_pag) {
                    continue;
                }
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

        public static function imagenesContador($params) {
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
            $cont = 0;
            foreach($imagenes_bd as $imagen_bd) {
                $cont++;
            }
            return $cont;
        }
    }
?>