CREATE DATABASE IF NOT EXISTS manzac;

USE manzac;

CREATE TABLE IF NOT EXISTS autorization(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    token VARCHAR(80) NOT NULL DEFAULT '-' COMMENT 'Token de acceso y seguridad',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS usuarios(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario/identificador',
    password VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Password de acceso',
    status VARCHAR(15) NOT NULL DEFAULT '-' COMMENT 'Estatus del usuario',
    id_autorization INT NOT NULL COMMENT 'Id Autorizacion',
    nombres VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Nombre(s) del usuario',
    apellidos VARCHAR(250) NULL DEFAULT '-' COMMENT 'Apellido(s) del usuario',
    perfil VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Perfil de usuario',
    id_firebase VARCHAR(350) NOT NULL DEFAULT '-' COMMENT 'Id del sistema de Notificaciones Firebase',
    sesion VARCHAR(30) NOT NULL DEFAULT 'NONE' COMMENT 'Indica si hay una sesion activa',
    acepta BIT NOT NULL DEFAULT 0 COMMENT 'Confirma si el usuario acepta Terminos y Condiciones',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS usuarios_logs(
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario/identificador',
    accion VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Accion realizada por usuario',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS configuracion(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    porcentaje_bonificacion FLOAT NOT NULL DEFAULT 0 COMMENT 'Valor del porcentaje de bonificacion',
    porcentaje_moratorio FLOAT NOT NULL DEFAULT 0 COMMENT 'Valor del porcentaje del interes moratorio'
);

CREATE TABLE IF NOT EXISTS reportes_salidas(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_tarja VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de tarja',
    tipo VARCHAR(120) NOT NULL DEFAULT 'SALIDA' COMMENT 'Tipo de servicio',
    fecha VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Fecha del documento',
    referencialm VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Referencia LM',
    imo VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'IMO',
    hora_inicio VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Hora Inicio',
    hora_fin VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Hora Fin',
    cliente VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Nombre cliente',
    mercancia VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Mercancia',
    agente_aduanal VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Agentee aduanal',
    ejecutivo VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Ejecutivo',
    contenedor_bl VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Contenedor y/o BL',
    pedimento_booking VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Pedimento / Booking',
    sello VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Sello',
    buque VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Buque',
    referencia_cliente VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Referencia cliente',
    bultos VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Bultos',
    peso FLOAT NOT NULL DEFAULT 0 COMMENT 'Peso',
    terminal VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Terminal',
    transporte VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Transporte',
    operador VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Operador',
    placas VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Placas',
    licencia VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Licencia',
    observaciones VARCHAR(1000) NOT NULL DEFAULT '-' COMMENT 'Observaciones',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS reportes_entradas(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_tarja VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de tarja',
    tipo VARCHAR(120) NOT NULL DEFAULT 'ENTRADA' COMMENT 'Tipo de servicio',
    fecha VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Fecha del documento',
    referencialm VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Referencia LM',
    imo VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'IMO',
    hora_inicio VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Hora Inicio',
    hora_fin VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Hora Fin',
    cliente VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Nombre cliente',
    mercancia VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Mercancia',
    agente_aduanal VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Agentee aduanal',
    ejecutivo VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Ejecutivo',
    contenedor_bl VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Contenedor y/o BL',
    pedimento_booking VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Pedimento / Booking',
    sello VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Sello',
    buque VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Buque',
    referencia_cliente VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Referencia cliente',
    bultos VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Bultos',
    peso FLOAT NOT NULL DEFAULT 0 COMMENT 'Peso',
    terminal VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Terminal',
    fecha_despacho VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Fecha despacho',
    dias_libres FLOAT NOT NULL DEFAULT 0 COMMENT 'Dias libres',
    fecha_vencimiento VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Fecha vencimiento',
    movimiento VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Movimiento',
    observaciones VARCHAR(1000) NOT NULL DEFAULT '-' COMMENT 'Observaciones',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS reportes_imagenes(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_tarja VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de tarja',
    id_imagen VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de imagen',
    tipo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Tipo de servicio',
    extension VARCHAR(15) NOT NULL DEFAULT '-' COMMENT 'Extension de la imagen',
    folder VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Folde ruta de almacenamiento',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */

CREATE TABLE IF NOT EXISTS app_usuarios_acciones(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario/identificador',
    accion VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Descripcion de accion usuario'
);

CREATE TABLE IF NOT EXISTS app_log_backups(
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_backup VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de ultima actualización',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fecha_creacion VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS app_cobranzas(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_cobranza VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de cobranza',
    tipo_cobranza VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Tipo de cobranza Debo Me deben',
    zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Zona de registro de cobranza',
    nombre TEXT NOT NULL DEFAULT '-' COMMENT 'Nombre de cliente',
    cantidad FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto de la nota de cobranza',
    descripcion VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Descripcion de cobranza',
    telefono TEXT NOT NULL DEFAULT '-' COMMENT 'Telefono de cliente',
    direccion TEXT NOT NULL DEFAULT '-' COMMENT 'Direccion de cliente',
    correo TEXT NOT NULL DEFAULT '-' COMMENT 'Correo de cliente',
    fecha_registro VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de registro de cobranza',
    fecha_vencimiento VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de vencimiento de cobranza',
    saldo FLOAT NOT NULL DEFAULT 0 COMMENT 'Saldo restante de cobranza',
    latitud TEXT NOT NULL DEFAULT '-' COMMENT 'Longitud coordenada hubicacion',
    longitud TEXT NOT NULL DEFAULT '-' COMMENT 'Latitud coordenada hubicacion',
    ultimo_cargo FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto ultimo cargo',
    fecha_ultimo_cargo VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha ultimo cargo',
    usuario_ultimo_cargo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario genera ultimo cargo',
    ultimo_abono FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto ultimo abono',
    fecha_ultimo_abono VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha ultimo abono',
    usuario_ultimo_abono VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario ultimo abono',
    estatus VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Estatus de nota de cobranza',
    bloqueado VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Estatus bloqueo de nota cobranza',
    id_cobrador VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de usuario cobrador',
    estatus_manual VARCHAR(60) NOT NULL DEFAULT '-' COMMENT 'Estatus manual'
);

CREATE TABLE IF NOT EXISTS app_cargos_abonos(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_cobranza VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de cobranza',
    id_movimiento VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id del movimiento',
    tipo VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Tipo de movimiento Cargo - Abono',
    monto FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto del movimiento',
    referencia VARCHAR(200) NOT NULL DEFAULT '-' COMMENT 'Referencia del movimiento',
    usuario_registro VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra el movimiento',
    fecha_registro VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    genera VARCHAR(15) NOT NULL DEFAULT '-' COMMENT 'Tipo genera registro manual automatico'
);

CREATE TABLE IF NOT EXISTS app_notas(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_nota VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de nota',
    id_cobranza VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro cobranza',
    nota VARCHAR(200) NOT NULL DEFAULT '-' COMMENT 'Descripcion de la nota',
    usuario_crea VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario que crea la nota',
    usuario_visto VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario que visualiza nota',
    fecha_crea VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha creacion de la nota'
);

CREATE TABLE IF NOT EXISTS app_zonas(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de zona',
    value_zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id mascara de valor zona',
    label_zona VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Etiqueta mascara de valor zona',
    fecha_creacion VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    activo BIT NOT NULL DEFAULT 0 COMMENT 'Estatus del registro'
);

CREATE TABLE IF NOT EXISTS app_zonas_usuarios(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de zona vinculada al usuario',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario al que se vincula la zona'
);

CREATE TABLE IF NOT EXISTS app_clientes(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_cliente VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de cliente',
    nombre TEXT NOT NULL DEFAULT '-' COMMENT 'Nombre del cliente',
    telefono TEXT NOT NULL DEFAULT '-' COMMENT 'Telefono del cliente',
    fecha_creacion VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    activo BIT NOT NULL DEFAULT 0 COMMENT 'Estatus del registro'
);

CREATE TABLE IF NOT EXISTS app_inventarios(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_articulo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de articulo',
    codigo_articulo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Codigo clave sku de articulo',
    descripcion VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Descripcion de articulo',
    marca VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Marca de articulo',
    talla VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Talla de articulo',
    precio_compra FLOAT NOT NULL DEFAULT 0 COMMENT 'Precio de compra',
    precio_venta FLOAT NOT NULL DEFAULT 0 COMMENT 'Precio de venta',
    existencia FLOAT NOT NULL DEFAULT 0 COMMENT 'Existencias del articulo',
    maximo FLOAT NOT NULL DEFAULT 0 COMMENT 'Cantidad maxima stock',
    minimo FLOAT NOT NULL DEFAULT 0 COMMENT 'Cantidad minima stock',
    fecha_cambio VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    usuario VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario genera registro'
);

CREATE TABLE IF NOT EXISTS app_aux(
    funcion VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Nombre funcion',
    value1 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 1',
    value2 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 2',
    value3 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 3',
    value4 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 4',
    value5 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 5',
    value6 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 6',
    value7 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 7',
    value8 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 8',
    value9 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 9',
    value10 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 10',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

/*
INSERT INTO autorization (
    token
) VALUES (
    MD5('$VALOR$')
);

INSERT INTO usuarios (
    id_sistema,
    usuario,
    password,
    status,
    id_autorization,
    nombres,
    apellidos,
    perfil
) VALUES (
    '2ddc9144-d3e9-46d1-beb8-b6128f241937',
    'victorg@gmail.com',
    MD5('12345'),
    'ACTIVO',
    1,
    'Victor',
    'Gonzalez',
    'ADMINISTRADOR'
);

INSERT INTO usuarios (
    id_sistema,
    usuario,
    password,
    status,
    id_autorization,
    nombres,
    apellidos,
    perfil
) VALUES (
    'd84e5482-3817-491b-b825-211b9db70d60',
    'manueltrujillogomez89@gmail.com',
    MD5('12345'),
    'ACTIVO',
    2,
    'Usuario',
    'Administrador',
    'ADMINISTRADOR'
);

827ccb0eea8a706c4c34a16891f84e7b
*/