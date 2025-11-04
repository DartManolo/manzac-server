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
    peso VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Peso',
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
    peso VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Peso',
    terminal VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Terminal',
    fecha_despacho VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Fecha despacho',
    dias_libres VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Dias libres',
    fecha_vencimiento VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Fecha vencimiento',
    movimiento VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Movimiento',
    observaciones VARCHAR(1000) NOT NULL DEFAULT '-' COMMENT 'Observaciones',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS reportes_danios(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_tarja VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de tarja',
    tipo VARCHAR(120) NOT NULL DEFAULT 'DAÑOS' COMMENT 'Tipo de servicio',
    fecha VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Fecha del documento',
    fechaCreado VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Fecha Creado',
    version VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Version',
    clave VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Clave',
    fecha_reporte VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Fecha reporte',
    linea_naviera VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Linea naviera',
    cliente VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Cliente',
    num_contenedor VARCHAR(255) NOT NULL DEFAULT '-' COMMENT 'Numero contendedor',
    vacio VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Vacio',
    lleno VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Lleno',
    d20 VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'D20',
    d40 VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'D40',
    hc VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'HC',
    otro VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Otro',
    estandar VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Estandar',
    opentop VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Open top',
    flatrack VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Flatrack',
    reefer VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Reefer',
    reforzado VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Reforzado',
    num_sello VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Numero Sello',
    int_puertas_izq VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Int puertas izq',
    int_puertas_der VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Int puertas der',
    int_piso VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Int piso',
    int_techo VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Int techo',
    int_panel_lateral_izq VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Int panel lateral izq',
    int_panel_lateral_der VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Int panel lateral der',
    int_panel_fondo VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Int panel fondo',
    ext_puertas_izq VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext puertas izq',
    ext_puertas_der VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext puertas der',
    ext_poste VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext poste',
    ext_palanca VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext palanca',
    ext_ganchoCierre VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext gancho cierre',
    ext_panel_izq VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext panel izq',
    ext_panel_der VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext panel deer',
    ext_panel_fondo VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext panel fondo',
    ext_cantonera VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext cantonera',
    ext_frisa VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Ext frisa',
    observaciones VARCHAR(1000) NOT NULL DEFAULT '-' COMMENT 'Observaciones',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS reportes_imagenes(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_tarja VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de tarja',
    id_imagen VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de imagen',
    formato VARCHAR(15) NOT NULL DEFAULT '-' COMMENT 'Formato de la imagen',
    fila INT NOT NULL DEFAULT 0 COMMENT 'Numero de fila',
    posicion INT NOT NULL DEFAULT 0 COMMENT 'Numero de posicion',
    tipo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Tipo de servicio',
    folder VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Folde ruta de almacenamiento',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE error_log (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mensaje TEXT NOT NULL,
    archivo VARCHAR(255) NULL,
    linea INT NULL,
    pila TEXT NULL,
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

SET SQL_SAFE_UPDATES = 0;

827ccb0eea8a706c4c34a16891f84e7b
*/