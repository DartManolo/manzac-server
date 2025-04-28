/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_AUTORIZATION;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_AUTORIZATION(
    IN _TOKEN VARCHAR(80)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.autorization WHERE 
            SHA2(token, 256) = SHA2(_TOKEN, 256)
    );
    SELECT _VERIFY AS TOKEN;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_INICIAR_SESION;
DELIMITER $$
CREATE PROCEDURE STP_INICIAR_SESION(
    IN _USUARIO VARCHAR(150), IN _PASSWORD VARCHAR(150)
)
BEGIN
    DECLARE _ID INT DEFAULT 0;
    SET _ID = (
        SELECT
            US1.id 
        FROM manzac.usuarios AS US1
        WHERE US1.usuario = _USUARIO 
            AND US1.password = MD5(_PASSWORD)
    );
    SELECT
        US1.id,
        US1.id_sistema,
        US1.usuario,
        US1.status,
        US1.id_autorization,
        US1.nombres,
        US1.apellidos,
        US1.id_firebase,
        US1.perfil,
        US1.sesion,
        US1.acepta,
        AU1.token 
    FROM manzac.usuarios AS US1
        LEFT OUTER JOIN manzac.autorization AU1 ON AU1.id = US1.id_autorization
    WHERE US1.id = _ID;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_RECUPERACION_USUARIO_PASSWORD;
DELIMITER $$
CREATE PROCEDURE STP_RECUPERACION_USUARIO_PASSWORD(
    IN _USUARIO VARCHAR(150), IN _PASSWORD VARCHAR(150), IN _STATUS VARCHAR(15)
)
BEGIN
    UPDATE manzac.usuarios SET
        password = MD5(_PASSWORD),
        status = _STATUS
    WHERE 
        usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_USUARIO_LOG_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_USUARIO_LOG_INSERT(
    IN _USUARIO VARCHAR(150), IN _ACCION VARCHAR(150)
)
BEGIN
    INSERT INTO manzac.usuarios_logs (
        usuario, 
        accion
    ) VALUES (
        _USUARIO, 
        _ACCION
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_USUARIO(
    IN _USUARIO VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.usuarios WHERE 
            usuario = _USUARIO
    );
    SELECT _VERIFY AS EXISTE;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_STATUS_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_STATUS_USUARIO(
    IN _USUARIO VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY 
        FROM manzac.usuarios WHERE 
            usuario = _USUARIO 
            AND status = 'ACTIVO'
    );
    SELECT _VERIFY AS ACTIVO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ALTA_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_ALTA_USUARIO(
    IN _TOKEN VARCHAR(80), IN _IDSISTEMA VARCHAR(150), IN _USUARIO VARCHAR(150), IN _PASSWORD VARCHAR(150),
    IN _ESTATUS VARCHAR(15), IN _NOMBRES VARCHAR(150), IN _APELLIDOS VARCHAR(250), IN _PERFIL VARCHAR(150)
)
BEGIN
    DECLARE _IDAUTH INT DEFAULT 0;
    INSERT INTO manzac.autorization (
        token
    ) VALUES (
        MD5(_TOKEN)
    );
    SET _IDAUTH = (
        SELECT 
            id 
        FROM manzac.autorization WHERE 
            token = MD5(_TOKEN)
    );
    INSERT INTO manzac.usuarios (
        id_sistema,
        usuario,
        password,
        status,
        id_autorization,
        nombres,
        apellidos,
        perfil
    ) VALUES (
        _IDSISTEMA,
        _USUARIO,
        MD5(_PASSWORD),
        _ESTATUS,
        _IDAUTH,
        _NOMBRES,
        _APELLIDOS,
        _PERFIL
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_USUARIO_EXISTE;
DELIMITER $$
CREATE PROCEDURE STP_USUARIO_EXISTE(
    IN _USUARIO VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY 
        FROM manzac.usuarios WHERE 
            usuario = _USUARIO 
    );
    SELECT _VERIFY AS ACTIVO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_USUARIOS;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_USUARIOS()
BEGIN
    SELECT
        US1.id,
        US1.id_sistema AS idSistema,
        US1.usuario AS usuario,
        US1.status AS status,
        US1.nombres AS nombres,
        US1.apellidos AS apellidos,
        US1.perfil AS perfil 
    FROM manzac.usuarios AS US1;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_USUARIO(
    IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        US1.id,
        US1.id_sistema AS idSistema,
        US1.usuario AS usuario,
        US1.status AS status,
        US1.nombres AS nombres,
        US1.apellidos AS apellidos,
        US1.perfil AS perfil 
    FROM manzac.usuarios AS US1
        WHERE US1.usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_ESTATUS_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_ESTATUS_USUARIO(
    IN _USUARIO VARCHAR(150),
    IN _STATUS VARCHAR(15)
)
BEGIN
    UPDATE manzac.usuarios SET 
        status = _STATUS 
    WHERE usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ALTA_REPORTE_SALIDA;
DELIMITER $$
CREATE PROCEDURE STP_ALTA_REPORTE_SALIDA(
    IN _IDTARJA VARCHAR(120), IN _TIPO VARCHAR(120), IN _FECHA VARCHAR(255), 
    IN _REFERENCIALM VARCHAR(255), IN _IMO VARCHAR(255), IN _HORAINICIO VARCHAR(255), 
    IN _HORAFIN VARCHAR(255), IN _CLIENTE VARCHAR(255), IN _MERCANCIA VARCHAR(255), 
    IN _AGENTEADUANAL VARCHAR(255), IN _EJECUTIVO VARCHAR(255), IN _CONTENEDORBL VARCHAR(255), 
    IN _PEDIMENTOBOOKING VARCHAR(255), IN _SELLO VARCHAR(255), IN _BUQUE VARCHAR(255), 
    IN _REFERENCIACLIENTE VARCHAR(255), IN _BULTOS VARCHAR(255), IN _PESO VARCHAR(255), 
    IN _TERMINAL VARCHAR(255), IN _TRANSPORTE VARCHAR(255), IN _OPERADOR VARCHAR(255), 
    IN _PLACAS VARCHAR(255), IN _LICENCIA VARCHAR(255), IN _OBSERVACIONES VARCHAR(1000), 
    IN _USUARIO VARCHAR(150) 
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.reportes_salidas 
            WHERE id_tarja = _IDTARJA
    );
    IF _VERIFY > 0 THEN
        DELETE FROM 
            manzac.reportes_salidas 
        WHERE id_tarja = _IDTARJA;
    END IF;
    INSERT INTO manzac.reportes_salidas (
        id_tarja, 
        tipo, 
        fecha, 
        referencialm, 
        imo, 
        hora_inicio, 
        hora_fin, 
        cliente, 
        mercancia, 
        agente_aduanal, 
        ejecutivo, 
        contenedor_bl, 
        pedimento_booking, 
        sello, 
        buque, 
        referencia_cliente, 
        bultos, 
        peso, 
        terminal, 
        transporte, 
        operador, 
        placas, 
        licencia, 
        observaciones, 
        usuario 
    ) VALUES (
        _IDTARJA, 
        _TIPO, 
        _FECHA, 
        CONVERT(_REFERENCIALM USING UTF8), 
        CONVERT(_IMO USING UTF8), 
        _HORAINICIO, 
        _HORAFIN, 
        CONVERT(_CLIENTE USING UTF8), 
        CONVERT(_MERCANCIA USING UTF8), 
        CONVERT(_AGENTEADUANAL USING UTF8), 
        CONVERT(_EJECUTIVO USING UTF8), 
        CONVERT(_CONTENEDORBL USING UTF8), 
        CONVERT(_PEDIMENTOBOOKING USING UTF8), 
        CONVERT(_SELLO USING UTF8), 
        CONVERT(_BUQUE USING UTF8), 
        CONVERT(_REFERENCIACLIENTE USING UTF8), 
        _BULTOS, 
        _PESO, 
        CONVERT(_TERMINAL USING UTF8), 
        CONVERT(_TRANSPORTE USING UTF8), 
        CONVERT(_OPERADOR USING UTF8), 
        CONVERT(_PLACAS USING UTF8), 
        CONVERT(_LICENCIA USING UTF8), 
        _OBSERVACIONES, 
        _USUARIO 
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ALTA_REPORTE_ENTRADA;
DELIMITER $$
CREATE PROCEDURE STP_ALTA_REPORTE_ENTRADA(
    IN _IDTARJA VARCHAR(120), IN _TIPO VARCHAR(120), IN _FECHA VARCHAR(255), 
    IN _REFERENCIALM VARCHAR(255), IN _IMO VARCHAR(255), IN _HORAINICIO VARCHAR(255), 
    IN _HORAFIN VARCHAR(255), IN _CLIENTE VARCHAR(255), IN _MERCANCIA VARCHAR(255), 
    IN _AGENTEADUANAL VARCHAR(255), IN _EJECUTIVO VARCHAR(255), IN _CONTENEDORBL VARCHAR(255), 
    IN _PEDIMENTOBOOKING VARCHAR(255), IN _SELLO VARCHAR(255), IN _BUQUE VARCHAR(255), 
    IN _REFERENCIACLIENTE VARCHAR(255), IN _BULTOS VARCHAR(255), IN _PESO VARCHAR(255), 
    IN _TERMINAL VARCHAR(255), IN _FECHADESPACHO VARCHAR(40), IN _DIASLIBRES VARCHAR(255), 
    IN _FECHAVENCIMIENTO VARCHAR(40), IN _MOVIMIENTO VARCHAR(255), IN _OBSERVACIONES VARCHAR(1000), 
    IN _USUARIO VARCHAR(150) 
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.reportes_entradas 
            WHERE id_tarja = _IDTARJA
    );
    IF _VERIFY > 0 THEN
        DELETE FROM 
            manzac.reportes_entradas 
        WHERE id_tarja = _IDTARJA;
    END IF;
    INSERT INTO manzac.reportes_entradas (
        id_tarja, 
        tipo, 
        fecha, 
        referencialm, 
        imo, 
        hora_inicio, 
        hora_fin, 
        cliente, 
        mercancia, 
        agente_aduanal, 
        ejecutivo, 
        contenedor_bl, 
        pedimento_booking, 
        sello, 
        buque, 
        referencia_cliente, 
        bultos, 
        peso, 
        terminal, 
        fecha_despacho, 
        dias_libres, 
        fecha_vencimiento, 
        movimiento, 
        observaciones, 
        usuario 
    ) VALUES (
        _IDTARJA, 
        _TIPO, 
        _FECHA, 
        CONVERT(_REFERENCIALM USING UTF8), 
        CONVERT(_IMO USING UTF8), 
        _HORAINICIO, 
        _HORAFIN, 
        CONVERT(_CLIENTE USING UTF8), 
        CONVERT(_MERCANCIA USING UTF8), 
        CONVERT(_AGENTEADUANAL USING UTF8), 
        CONVERT(_EJECUTIVO USING UTF8), 
        CONVERT(_CONTENEDORBL USING UTF8), 
        CONVERT(_PEDIMENTOBOOKING USING UTF8), 
        CONVERT(_SELLO USING UTF8), 
        CONVERT(_BUQUE USING UTF8), 
        CONVERT(_REFERENCIACLIENTE USING UTF8), 
        _BULTOS, 
        _PESO, 
        CONVERT(_TERMINAL USING UTF8), 
        CONVERT(_FECHADESPACHO USING UTF8), 
        _DIASLIBRES, 
        CONVERT(_FECHAVENCIMIENTO USING UTF8), 
        CONVERT(_MOVIMIENTO USING UTF8), 
        CONVERT(_OBSERVACIONES USING UTF8), 
        _USUARIO 
    );
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ALTA_REPORTE_DANIOS;
DELIMITER $$
CREATE PROCEDURE STP_ALTA_REPORTE_DANIOS(
    IN _IDTARJA VARCHAR(120), IN _TIPO VARCHAR(120), IN _FECHA VARCHAR(255), IN _FECHACREADO VARCHAR(255),
    IN _VERSION VARCHAR(255), IN _CLAVE VARCHAR(255), IN _FECHAREPORTE VARCHAR(255), IN _LINEANAVIERA VARCHAR(255),
    IN _CLIENTE VARCHAR(255), IN _NUMCONTENEDOR VARCHAR(255), IN _VACIO VARCHAR(10), IN _LLENO VARCHAR(10),
    IN _D20 VARCHAR(10), IN _D40 VARCHAR(10), IN _HC VARCHAR(10), IN _OTRO VARCHAR(10), IN _ESTANDAR VARCHAR(10),
    IN _OPENTOP VARCHAR(10), IN _FLATRACK VARCHAR(10), IN _REEFER VARCHAR(10), IN _REFORZADO VARCHAR(10),
    IN _NUMSELLO VARCHAR(150), IN _INTPUERTASIZQ VARCHAR(100), IN _INTPUERTASDER VARCHAR(100), IN _INTPISO VARCHAR(100),
    IN _INTTECHO VARCHAR(100), IN _INTPANELLATERALIZQ VARCHAR(100), IN _INTPANELLATERALDER VARCHAR(100),
    IN _INTPANELFONDO VARCHAR(100), IN _EXTPUERTASIZQ VARCHAR(100), IN _EXTPUERTASDER VARCHAR(100),
    IN _EXTPOSTE VARCHAR(100), IN _EXTPALANCA VARCHAR(100), IN _EXTGANCHOCIERRE VARCHAR(100), IN _EXTPANELIZQ VARCHAR(100),
    IN _EXTPANELDER VARCHAR(100), IN _EXTPANELFONDO VARCHAR(100), IN _EXTCANTONERA VARCHAR(100), IN _EXTFRISA VARCHAR(100),
    IN _OBSERVACIONES VARCHAR(1000), IN _USUARIO VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.reportes_danios 
            WHERE id_tarja = _IDTARJA
    );
    IF _VERIFY > 0 THEN
        DELETE FROM 
            manzac.reportes_danios 
        WHERE id_tarja = _IDTARJA;
    END IF;
    INSERT INTO manzac.reportes_danios (
        id_tarja, 
        tipo, 
        fecha, 
        fechaCreado, 
        version, 
        clave, 
        fecha_reporte, 
        linea_naviera, 
        cliente, 
        num_contenedor, 
        vacio, 
        lleno, 
        d20, 
        d40, 
        hc, 
        otro, 
        estandar, 
        opentop, 
        flatrack, 
        reefer, 
        reforzado, 
        num_sello, 
        int_puertas_izq, 
        int_puertas_der, 
        int_piso, 
        int_techo, 
        int_panel_lateral_izq, 
        int_panel_lateral_der, 
        int_panel_fondo, 
        ext_puertas_izq, 
        ext_puertas_der, 
        ext_poste, 
        ext_palanca, 
        ext_ganchoCierre, 
        ext_panel_izq, 
        ext_panel_der, 
        ext_panel_fondo, 
        ext_cantonera, 
        ext_frisa, 
        observaciones, 
        usuario
    ) VALUES (
        _IDTARJA,
        _TIPO,
        _FECHA,
        _FECHACREADO,
        CONVERT(_VERSION USING UTF8),
        CONVERT(_CLAVE USING UTF8),
        _FECHAREPORTE,
        CONVERT(_LINEANAVIERA USING UTF8),
        CONVERT(_CLIENTE USING UTF8),
        CONVERT(_NUMCONTENEDOR USING UTF8),
        _VACIO,
        _LLENO,
        _D20,
        _D40,
        _HC,
        _OTRO,
        _ESTANDAR,
        _OPENTOP,
        _FLATRACK,
        _REEFER,
        _REFORZADO,
        CONVERT(_NUMSELLO USING UTF8),
        CONVERT(_INTPUERTASIZQ USING UTF8),
        CONVERT(_INTPUERTASDER USING UTF8),
        CONVERT(_INTPISO USING UTF8),
        CONVERT(_INTTECHO USING UTF8),
        CONVERT(_INTPANELLATERALIZQ USING UTF8),
        CONVERT(_INTPANELLATERALDER USING UTF8),
        CONVERT(_INTPANELFONDO USING UTF8),
        CONVERT(_EXTPUERTASIZQ USING UTF8),
        CONVERT(_EXTPUERTASDER USING UTF8),
        CONVERT(_EXTPOSTE USING UTF8),
        CONVERT(_EXTPALANCA USING UTF8),
        CONVERT(_EXTGANCHOCIERRE USING UTF8),
        CONVERT(_EXTPANELIZQ USING UTF8),
        CONVERT(_EXTPANELDER USING UTF8),
        CONVERT(_EXTPANELFONDO USING UTF8),
        CONVERT(_EXTCANTONERA USING UTF8),
        CONVERT(_EXTFRISA USING UTF8),
        CONVERT(_OBSERVACIONES USING UTF8),
        _USUARIO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_REPORTE_ENTRADA_IDTARJA;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_REPORTE_ENTRADA_IDTARJA(
    IN _IDTARJA VARCHAR(120)
)
BEGIN
    SELECT
        RE.id_tarja AS idTarja, 
        RE.tipo AS tipo, 
        RE.fecha AS fecha, 
        RE.referencialm AS referenciaLm, 
        RE.imo AS imo, 
        RE.hora_inicio AS horaInicio, 
        RE.hora_fin AS horaFin, 
        RE.cliente AS cliente, 
        RE.mercancia AS mercancia, 
        RE.agente_aduanal AS agenteAduanal, 
        RE.ejecutivo AS ejecutivo, 
        RE.contenedor_bl AS contenedor, 
        RE.pedimento_booking AS pedimento, 
        RE.sello AS sello, 
        RE.buque AS buque, 
        RE.referencia_cliente AS refCliente, 
        RE.bultos AS bultos, 
        RE.peso AS peso, 
        RE.terminal AS terminal, 
        RE.fecha_despacho AS fechaDespacho, 
        RE.dias_libres AS diasLibres, 
        RE.fecha_vencimiento AS fechaVencimiento, 
        RE.movimiento AS movimiento, 
        RE.observaciones AS observaciones, 
        RE.usuario AS usuario, 
        CONCAT(US.nombres, ' ', US.apellidos) AS nombreUsuario 
    FROM manzac.reportes_entradas RE 
    LEFT OUTER JOIN manzac.usuarios US ON US.id_sistema = RE.usuario 
        WHERE RE.id_tarja = _IDTARJA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_REPORTE_ENTRADA_FECHA;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_REPORTE_ENTRADA_FECHA(
    IN _FECHAINICIO VARCHAR(30), IN _FECHAFIN VARCHAR(30)
)
BEGIN
    SELECT
        RE.id_tarja AS idTarja, 
        RE.tipo AS tipo, 
        RE.fecha AS fecha, 
        RE.referencialm AS referenciaLm, 
        RE.imo AS imo, 
        RE.hora_inicio AS horaInicio, 
        RE.hora_fin AS horaFin, 
        RE.cliente AS cliente, 
        RE.mercancia AS mercancia, 
        RE.agente_aduanal AS agenteAduanal, 
        RE.ejecutivo AS ejecutivo, 
        RE.contenedor_bl AS contenedor, 
        RE.pedimento_booking AS pedimento, 
        RE.sello AS sello, 
        RE.buque AS buque, 
        RE.referencia_cliente AS refCliente, 
        RE.bultos AS bultos, 
        RE.peso AS peso, 
        RE.terminal AS terminal, 
        RE.fecha_despacho AS fechaDespacho, 
        RE.dias_libres AS diasLibres, 
        RE.fecha_vencimiento AS fechaVencimiento, 
        RE.movimiento AS movimiento, 
        RE.observaciones AS observaciones, 
        RE.usuario AS usuario, 
        CONCAT(US.nombres, ' ', US.apellidos) AS nombreUsuario 
    FROM manzac.reportes_entradas RE 
    LEFT OUTER JOIN manzac.usuarios US ON US.id_sistema = RE.usuario 
        WHERE RE.fh_registro BETWEEN _FECHAINICIO AND _FECHAFIN;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_REPORTE_SALIDA_IDTARJA;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_REPORTE_SALIDA_IDTARJA(
    IN _IDTARJA VARCHAR(120)
)
BEGIN
    SELECT
        RS.id_tarja AS idTarja, 
        RS.tipo AS tipo, 
        RS.fecha AS fecha, 
        RS.referencialm AS referenciaLm, 
        RS.imo AS imo, 
        RS.hora_inicio AS horaInicio, 
        RS.hora_fin AS horaFin, 
        RS.cliente AS cliente, 
        RS.mercancia AS mercancia, 
        RS.agente_aduanal AS agenteAduanal, 
        RS.ejecutivo AS ejecutivo, 
        RS.contenedor_bl AS contenedor, 
        RS.pedimento_booking AS pedimento, 
        RS.sello AS sello, 
        RS.buque AS buque, 
        RS.referencia_cliente AS refCliente, 
        RS.bultos AS bultos, 
        RS.peso AS peso, 
        RS.terminal AS terminal, 
        RS.transporte AS transporte, 
        RS.operador AS operador, 
        RS.placas AS placas, 
        RS.licencia AS licencia, 
        RS.observaciones AS observaciones, 
        RS.usuario AS usuario, 
        CONCAT(US.nombres, ' ', US.apellidos) AS nombreUsuario 
    FROM manzac.reportes_salidas RS 
    LEFT OUTER JOIN manzac.usuarios US ON US.id_sistema = RS.usuario 
        WHERE RS.id_tarja = _IDTARJA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_REPORTE_SALIDA_FECHA;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_REPORTE_SALIDA_FECHA(
    IN _FECHAINICIO VARCHAR(30), IN _FECHAFIN VARCHAR(30)
)
BEGIN
    SELECT
        RS.id_tarja AS idTarja, 
        RS.tipo AS tipo, 
        RS.fecha AS fecha, 
        RS.referencialm AS referenciaLm, 
        RS.imo AS imo, 
        RS.hora_inicio AS horaInicio, 
        RS.hora_fin AS horaFin, 
        RS.cliente AS cliente, 
        RS.mercancia AS mercancia, 
        RS.agente_aduanal AS agenteAduanal, 
        RS.ejecutivo AS ejecutivo, 
        RS.contenedor_bl AS contenedor, 
        RS.pedimento_booking AS pedimento, 
        RS.sello AS sello, 
        RS.buque AS buque, 
        RS.referencia_cliente AS refCliente, 
        RS.bultos AS bultos, 
        RS.peso AS peso, 
        RS.terminal AS terminal, 
        RS.transporte AS transporte, 
        RS.operador AS operador, 
        RS.placas AS placas, 
        RS.licencia AS licencia, 
        RS.observaciones AS observaciones, 
        RS.usuario AS usuario, 
        CONCAT(US.nombres, ' ', US.apellidos) AS nombreUsuario 
    FROM manzac.reportes_salidas RS 
    LEFT OUTER JOIN manzac.usuarios US ON US.id_sistema = RS.usuario 
        WHERE RS.fh_registro BETWEEN _FECHAINICIO AND _FECHAFIN;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_REPORTE_DANIOS_IDTARJA;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_REPORTE_DANIOS_IDTARJA(
    IN _IDTARJA VARCHAR(120)
)
BEGIN
    SELECT
        RD.id_tarja AS idTarja, 
        RD.tipo AS tipo, 
        RD.fecha AS fecha, 
        RD.fechaCreado AS fechaCreado, 
        RD.version AS version, 
        RD.clave AS clave, 
        RD.fecha_reporte AS fechaReporte, 
        RD.linea_naviera AS lineaNaviera, 
        RD.cliente AS cliente, 
        RD.num_contenedor AS numContenedor, 
        RD.vacio AS vacio, 
        RD.lleno AS lleno, 
        RD.d20 AS d20, 
        RD.d40 AS d40, 
        RD.hc AS hc, 
        RD.otro AS otro, 
        RD.estandar AS estandar, 
        RD.opentop AS opentop, 
        RD.flatrack AS flatRack, 
        RD.reefer AS reefer, 
        RD.reforzado AS reforzado, 
        RD.num_sello AS numSello, 
        RD.int_puertas_izq AS intPuertasIzq, 
        RD.int_puertas_der AS intPuertasDer, 
        RD.int_piso AS intPiso, 
        RD.int_techo AS intTecho, 
        RD.int_panel_lateral_izq AS intPanelLateralIzq, 
        RD.int_panel_lateral_der AS intPanelLateralDer, 
        RD.int_panel_fondo AS intPanelFondo, 
        RD.ext_puertas_izq AS extPuertasIzq, 
        RD.ext_puertas_der AS extPuertasDer, 
        RD.ext_poste AS extPoste, 
        RD.ext_palanca AS extPalanca, 
        RD.ext_ganchoCierre AS extGanchoCierre, 
        RD.ext_panel_izq AS extPanelIzq, 
        RD.ext_panel_der AS extPanelDer, 
        RD.ext_panel_fondo AS extPanelFondo, 
        RD.ext_cantonera AS extCantonera, 
        RD.ext_frisa AS extFrisa, 
        RD.observaciones AS observaciones, 
        RD.usuario AS usuario, 
        CONCAT(US.nombres, ' ', US.apellidos) AS nombreUsuario 
    FROM manzac.reportes_danios RD 
    LEFT OUTER JOIN manzac.usuarios US ON US.id_sistema = RD.usuario 
        WHERE RD.id_tarja = _IDTARJA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_REPORTE_DANIOS_FECHA;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_REPORTE_DANIOS_FECHA(
    IN _FECHAINICIO VARCHAR(30), IN _FECHAFIN VARCHAR(30)
)
BEGIN
    SELECT
        RD.id_tarja AS idTarja, 
        RD.tipo AS tipo, 
        RD.fecha AS fecha, 
        RD.fechaCreado AS fechaCreado, 
        RD.version AS version, 
        RD.clave AS clave, 
        RD.fecha_reporte AS fechaReporte, 
        RD.linea_naviera AS lineaNaviera, 
        RD.cliente AS cliente, 
        RD.num_contenedor AS numContenedor, 
        RD.vacio AS vacio, 
        RD.lleno AS lleno, 
        RD.d20 AS d20, 
        RD.d40 AS d40, 
        RD.hc AS hc, 
        RD.otro AS otro, 
        RD.estandar AS estandar, 
        RD.opentop AS opentop, 
        RD.flatrack AS flatRack, 
        RD.reefer AS reefer, 
        RD.reforzado AS reforzado, 
        RD.num_sello AS numSello, 
        RD.int_puertas_izq AS intPuertasIzq, 
        RD.int_puertas_der AS intPuertasDer, 
        RD.int_piso AS intPiso, 
        RD.int_techo AS intTecho, 
        RD.int_panel_lateral_izq AS intPanelLateralIzq, 
        RD.int_panel_lateral_der AS intPanelLateralDer, 
        RD.int_panel_fondo AS intPanelFondo, 
        RD.ext_puertas_izq AS extPuertasIzq, 
        RD.ext_puertas_der AS extPuertasDer, 
        RD.ext_poste AS extPoste, 
        RD.ext_palanca AS extPalanca, 
        RD.ext_ganchoCierre AS extGanchoCierre, 
        RD.ext_panel_izq AS extPanelIzq, 
        RD.ext_panel_der AS extPanelDer, 
        RD.ext_panel_fondo AS extPanelFondo, 
        RD.ext_cantonera AS extCantonera, 
        RD.ext_frisa AS extFrisa, 
        RD.observaciones AS observaciones, 
        RD.usuario AS usuario, 
        CONCAT(US.nombres, ' ', US.apellidos) AS nombreUsuario 
    FROM manzac.reportes_danios RD 
    LEFT OUTER JOIN manzac.usuarios US ON US.id_sistema = RD.usuario 
        WHERE RD.fh_registro BETWEEN _FECHAINICIO AND _FECHAFIN;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_RESTABLECER_REPORTE_IMAGENES;
DELIMITER $$
CREATE PROCEDURE STP_RESTABLECER_REPORTE_IMAGENES(
    IN _IDTARJA VARCHAR(120)
)
BEGIN
    DELETE FROM 
        manzac.reportes_imagenes 
    WHERE id_tarja = _IDTARJA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ALTA_REPORTE_IMAGENES;
DELIMITER $$
CREATE PROCEDURE STP_ALTA_REPORTE_IMAGENES(
    IN _IDTARJA VARCHAR(120), IN _IDIMAGEN VARCHAR(120), IN _FORMATO VARCHAR(15),
    IN _FILA INT, IN _POSICION INT, IN _TIPO VARCHAR(120), IN _FOLDER VARCHAR(120),
    IN _USUARIO VARCHAR(150)
)
BEGIN
    INSERT INTO manzac.reportes_imagenes (
        id_tarja,
        id_imagen,
        formato,
        fila,
        posicion,
        tipo,
        folder,
        usuario
    ) VALUES (
        _IDTARJA,
        _IDIMAGEN,
        _FORMATO,
        _FILA,
        _POSICION,
        _TIPO,
        _FOLDER,
        _USUARIO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_REPORTE_IMAGENES_IDTARJA;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_REPORTE_IMAGENES_IDTARJA(
    IN _IDTARJA VARCHAR(120)
)
BEGIN
    SELECT
        id_tarja,
        id_imagen,
        formato,
        fila,
        posicion,
        tipo,
        folder,
        usuario
    FROM manzac.reportes_imagenes
        WHERE id_tarja = _IDTARJA;
END $$
DELIMITER ;






/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/




/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_SESION;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_SESION(
    IN _IDSISTEMA VARCHAR(120),
    IN _USUARIO VARCHAR(150),
    IN _SESSION VARCHAR(30),
    IN _FIREBASE VARCHAR(350)
)
BEGIN
    UPDATE manzac.usuarios SET 
        sesion = _SESSION, 
        id_firebase = _FIREBASE 
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACEPTA_ACTUALIZAR;
DELIMITER $$
CREATE PROCEDURE STP_ACEPTA_ACTUALIZAR(
    IN _IDSISTEMA VARCHAR(120), IN _ACEPTA BIT
)
BEGIN
    UPDATE manzac.usuarios SET 
        acepta = _ACEPTA
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_ESTATUS_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_ESTATUS_USUARIO(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        status 
    FROM manzac.usuarios 
    WHERE id_sistema = _IDSISTEMA 
        AND usuario = _USUARIO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_PERFIL_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_PERFIL_USUARIO(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        perfil 
    FROM manzac.usuarios 
    WHERE id_sistema = _IDSISTEMA 
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_COBRADOR(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.usuarios WHERE 
            id_sistema = _IDSISTEMA 
            AND usuario = _USUARIO 
            AND perfil = 'COBRADOR'
    );
    SELECT _VERIFY AS EXISTE;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ALTA_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_ALTA_COBRADOR(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150), IN _PASSWORD VARCHAR(150),
    IN _NOMBRES VARCHAR(150), IN _APELLIDOS VARCHAR(150) 
)
BEGIN
    DECLARE _IDAUTORIZACION INT DEFAULT 0;
    SET _IDAUTORIZACION = (
        SELECT 
            id_autorization 
        FROM manzac.usuarios WHERE
            id_sistema = _IDSISTEMA
            AND perfil = 'ADMINISTRADOR' 
        LIMIT 1
    );
    IF _IDAUTORIZACION > 0 THEN
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
            _IDSISTEMA,
            _USUARIO,
            MD5(_PASSWORD),
            'ACTIVO',
            _IDAUTORIZACION,
            CONVERT(_NOMBRES USING UTF8),
            CONVERT(_APELLIDOS USING UTF8),
            'COBRADOR'
        );
    ELSE
        SELECT 0;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_PASSWORD_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_PASSWORD_COBRADOR(
    IN _IDSISTEMA VARCHAR(120),
    IN _USUARIO VARCHAR(150),
    IN _PASSWORD VARCHAR(150)
)
BEGIN
    UPDATE manzac.usuarios SET 
        password = MD5(_PASSWORD) 
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_COBRADOR_INFO;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_COBRADOR_INFO(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        US1.id,
        US1.id_sistema,
        US1.usuario,
        US1.status,
        US1.nombres,
        US1.apellidos,
        US1.id_firebase
    FROM manzac.usuarios AS US1
        WHERE US1.id_sistema = _IDSISTEMA
            AND US1.usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_ESTATUS_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_ESTATUS_COBRADOR(
    IN _IDSISTEMA VARCHAR(120),
    IN _USUARIO VARCHAR(150),
    IN _STATUS VARCHAR(15)
)
BEGIN
    UPDATE manzac.usuarios SET 
        status = _STATUS 
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_USUARIOS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_USUARIOS_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        usuario,
        (
            CASE
                WHEN status = 'ACTIVO' THEN 1
                ELSE 0
            END
        ) AS estatus,
        nombres,
        apellidos
    FROM manzac.usuarios
        WHERE id_sistema = _IDSISTEMA
            AND perfil = 'COBRADOR';
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ACCION_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ACCION_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        IFNULL(accion, '-') AS accion
    FROM manzac.app_usuarios_acciones
        WHERE id_sistema = _IDSISTEMA
            AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ACCION_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ACCION_INSERT(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150),
    IN _ACCION VARCHAR(120)
)
BEGIN
    INSERT INTO manzac.app_usuarios_acciones (
        id_sistema, 
        usuario, 
        accion
    ) VALUES (
        _IDSISTEMA, 
        _USUARIO, 
        _ACCION
    );
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ACCION_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ACCION_DELETE(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    DELETE FROM manzac.app_usuarios_acciones
        WHERE id_sistema = _IDSISTEMA
            AND usuario = _USUARIO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_CONFIGURACION_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_CONFIGURACION_USUARIO(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT
        US1.id,
        US1.id_sistema AS idUsuario,
        US1.porcentaje_bonificacion AS porcentajeBonificacion,
        US1.porcentaje_moratorio AS porcentajeMoratorio 
    FROM manzac.configuracion AS US1
        WHERE US1.id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_VERIFICAR_BACKUP;
DELIMITER $$
CREATE PROCEDURE STP_APP_VERIFICAR_BACKUP(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_backup AS idBackup,
        usuario,
        fecha_creacion AS fechaCreacion 
    FROM manzac.app_log_backups
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_LOGBACKUP_PROCESS;
DELIMITER $$
CREATE PROCEDURE STP_APP_LOGBACKUP_PROCESS(
    IN _IDSISTEMA VARCHAR(120), IN _IDBACKUP VARCHAR(120),
    IN _USUARIO VARCHAR(150), IN _FECHACREACION VARCHAR(10)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.app_log_backups 
            WHERE id_sistema = _IDSISTEMA
    );
    IF _VERIFY = 0 THEN
        INSERT INTO manzac.app_log_backups (
            id_sistema,
            id_backup,
            usuario,
            fecha_creacion
        ) VALUES (
            _IDSISTEMA,
            _IDBACKUP,
            _USUARIO,
            _FECHACREACION
        );
    ELSE
        UPDATE manzac.app_log_backups SET
            id_backup = _IDBACKUP,
            usuario = _USUARIO,
            fecha_creacion = _FECHACREACION,
            fh_registro = CURRENT_TIMESTAMP
        WHERE id_sistema = _IDSISTEMA;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_zona AS idZona,
        value_zona AS valueZona,
        label_zona AS labelZona,
        fecha_creacion AS fechaCreacion,
        activo AS activobit
    FROM manzac.app_zonas
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_DELETE(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    DELETE FROM 
        manzac.app_zonas
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDZONA VARCHAR(120), IN _VALUEZONA VARCHAR(120), 
    IN _LABELZONA VARCHAR(40), IN _FECHACREACION VARCHAR(10), 
    IN _ACTIVO BIT
)
BEGIN
    INSERT INTO manzac.app_zonas (
        tabla, 
        id_sistema, 
        id_zona, 
        value_zona, 
        label_zona, 
        fecha_creacion, 
        activo
    ) VALUES (
        _TABLA, 
        _IDSISTEMA, 
        _IDZONA, 
        _VALUEZONA, 
        CONVERT(_LABELZONA USING UTF8), 
        _FECHACREACION, 
        _ACTIVO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_zona AS idZona,
        value_zona AS valueZona,
        label_zona AS labelZona,
        fecha_creacion AS fechaCreacion,
        activo AS activobit
    FROM manzac.app_zonas 
        WHERE value_zona = (
            SELECT 
                id_zona 
            FROM manzac.app_zonas_usuarios 
                WHERE usuario = _USUARIO 
                    AND id_sistema = _IDSISTEMA
            LIMIT 1
        );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_zona AS idZona,
        usuario 
    FROM manzac.app_zonas_usuarios
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_DELETE(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    DELETE FROM 
        manzac.app_zonas_usuarios
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDZONA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    INSERT INTO manzac.app_zonas_usuarios (
        tabla, 
        id_sistema, 
        id_zona, 
        usuario
    ) VALUES (
        _TABLA, 
        _IDSISTEMA, 
        _IDZONA, 
        _USUARIO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_VERIFY;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_VERIFY(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        COUNT(*) AS VERIFY
    FROM manzac.app_zonas_usuarios
        WHERE id_sistema = _IDSISTEMA
            AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_PROCESS;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_PROCESS(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), 
    IN _TIPOCOBRANZA VARCHAR(20), IN _ZONA VARCHAR(120), IN _NOMBRE TEXT, 
    IN _CANTIDAD FLOAT, IN _DESCRIPCION VARCHAR(100), IN _TELEFONO TEXT, 
    IN _DIRECCION TEXT, IN _CORREO TEXT, IN _FECHAREGISTRO VARCHAR(10), 
    IN _FECHAVENCIMIENTO VARCHAR(10), IN _SALDO FLOAT, IN _LATITUD TEXT, IN _LONGITUD TEXT, 
    IN _ULTIMOCARGO FLOAT, IN _FECHAULTIMOCARGO VARCHAR(10), IN _USUARIOULTIMOCARGO VARCHAR(120), 
    IN _ULTIMOABONO FLOAT, IN _FECHAULTIMOABONO VARCHAR(10), IN _USUARIOULTIMOABONO VARCHAR(120), 
    IN _ESTATUS VARCHAR(20), IN _BLOQUEADO VARCHAR(20), IN _IDCOBRADOR VARCHAR(120), 
    IN _ESTATUSMANUAL VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30), IN _USUARIOENVIA VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    DECLARE _BLOQUEO INT DEFAULT 0;
    DECLARE _ESBLOQUEO VARCHAR(20) DEFAULT 'SI';
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.app_cobranzas WHERE 
            id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA
    );
    IF _VERIFY = 0 THEN
        INSERT INTO manzac.app_cobranzas (
            tabla, 
            id_sistema, 
            id_cobranza, 
            tipo_cobranza, 
            zona, 
            nombre, 
            cantidad, 
            descripcion, 
            telefono, 
            direccion, 
            correo, 
            fecha_registro, 
            fecha_vencimiento, 
            saldo, 
            latitud, 
            longitud, 
            ultimo_cargo, 
            fecha_ultimo_cargo, 
            usuario_ultimo_cargo, 
            ultimo_abono, 
            fecha_ultimo_abono, 
            usuario_ultimo_abono, 
            estatus, 
            bloqueado, 
            id_cobrador,
            estatus_manual
        ) VALUES (
            _TABLA,
            _IDSISTEMA,
            _IDCOBRANZA,
            _TIPOCOBRANZA,
            _ZONA,
            AES_ENCRYPT(CONVERT(_NOMBRE USING UTF8), _ENCRYPTKEY),
            _CANTIDAD,
            CONVERT(_DESCRIPCION USING UTF8),
            AES_ENCRYPT(_TELEFONO, _ENCRYPTKEY),
            AES_ENCRYPT(CONVERT(_DIRECCION USING UTF8), _ENCRYPTKEY),
            AES_ENCRYPT(CONVERT(_CORREO USING UTF8), _ENCRYPTKEY),
            _FECHAREGISTRO,
            _FECHAVENCIMIENTO,
            _SALDO,
            AES_ENCRYPT(_LATITUD, _ENCRYPTKEY),
            AES_ENCRYPT(_LONGITUD, _ENCRYPTKEY),
            _ULTIMOCARGO,
            _FECHAULTIMOCARGO,
            _USUARIOULTIMOCARGO,
            _ULTIMOABONO,
            _FECHAULTIMOABONO,
            _USUARIOULTIMOABONO,
            _ESTATUS,
            _BLOQUEADO,
            _IDCOBRADOR,
            _ESTATUSMANUAL
        );
    ELSE
        IF _USUARIOENVIA = 'ADMINISTRADOR' THEN
            SET _ESBLOQUEO = 'SI';
        ELSE
            SET _ESBLOQUEO = 'NO';
        END IF;
        SET _BLOQUEO = (
            SELECT COUNT(*) AS BLOQUEO 
            FROM manzac.app_cobranzas
                WHERE id_sistema = _IDSISTEMA 
                AND id_cobranza = _IDCOBRANZA
                AND bloqueado = _ESBLOQUEO
        );
        IF _BLOQUEO = 0 THEN
            UPDATE manzac.app_cobranzas SET            
                tipo_cobranza = _TIPOCOBRANZA,
                zona = _ZONA,
                nombre = AES_ENCRYPT(CONVERT(_NOMBRE USING UTF8), _ENCRYPTKEY),
                cantidad = _CANTIDAD,
                descripcion = CONVERT(_DESCRIPCION USING UTF8),
                telefono = AES_ENCRYPT(_TELEFONO, _ENCRYPTKEY),
                direccion = AES_ENCRYPT(CONVERT(_DIRECCION USING UTF8), _ENCRYPTKEY),
                correo = AES_ENCRYPT(CONVERT(_CORREO USING UTF8), _ENCRYPTKEY),
                fecha_registro = _FECHAREGISTRO,
                fecha_vencimiento = _FECHAVENCIMIENTO,
                saldo = _SALDO,
                latitud = AES_ENCRYPT(_LATITUD, _ENCRYPTKEY),
                longitud = AES_ENCRYPT(_LONGITUD, _ENCRYPTKEY),
                ultimo_cargo = _ULTIMOCARGO,
                fecha_ultimo_cargo = _FECHAULTIMOCARGO,
                usuario_ultimo_cargo = _USUARIOULTIMOCARGO,
                ultimo_abono = _ULTIMOABONO,
                fecha_ultimo_abono = _FECHAULTIMOABONO,
                usuario_ultimo_abono = _USUARIOULTIMOABONO,
                estatus = _ESTATUS,
                bloqueado = _BLOQUEADO,
                id_cobrador = _IDCOBRADOR,
                estatus_manual = _ESTATUSMANUAL
            WHERE 
                id_sistema = _IDSISTEMA 
                AND id_cobranza = _IDCOBRANZA;
        ELSE
            SELECT _BLOQUEO AS BLOQUEO;
        END IF;
        
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_UNLOCK;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_UNLOCK(
    IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), IN _BLOQUEADO VARCHAR(20)
)
BEGIN
    UPDATE manzac.app_cobranzas SET            
        bloqueado = _BLOQUEADO
    WHERE 
        id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_ADMINISTRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_ADMINISTRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30)
)
BEGIN
    SELECT 
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_cobranza AS idCobranza,
        tipo_cobranza AS tipoCobranza,
        zona AS zona,
        CAST(AES_DECRYPT(nombre, _ENCRYPTKEY) AS CHAR) AS nombre,
        cantidad AS cantidad,
        descripcion AS descripcion,
        CAST(AES_DECRYPT(telefono, _ENCRYPTKEY) AS CHAR) AS telefono,
        CAST(AES_DECRYPT(direccion, _ENCRYPTKEY) AS CHAR) AS direccion,
        CAST(AES_DECRYPT(correo, _ENCRYPTKEY) AS CHAR) AS correo,
        fecha_registro AS fechaRegistro,
        fecha_vencimiento AS fechaVencimiento,
        saldo AS saldo,
        CAST(AES_DECRYPT(latitud, _ENCRYPTKEY) AS CHAR) AS latitud,
        CAST(AES_DECRYPT(longitud, _ENCRYPTKEY) AS CHAR) AS longitud,
        ultimo_cargo AS ultimoCargo,
        fecha_ultimo_cargo AS fechaUltimoCargo,
        usuario_ultimo_cargo AS usuarioUltimoCargo,
        ultimo_abono AS ultimoAbono,
        fecha_ultimo_abono AS fechaUltimoAbono,
        usuario_ultimo_abono AS usuarioUltimoAbono,
        estatus AS estatus,
        bloqueado AS bloqueado,
        id_cobrador AS idCobrador,
        estatus_manual AS estatusManual
    FROM manzac.app_cobranzas
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        COB1.tabla AS tabla,
        COB1.id_sistema AS idUsuario,
        COB1.id_cobranza AS idCobranza,
        COB1.tipo_cobranza AS tipoCobranza,
        COB1.zona AS zona,
        CAST(AES_DECRYPT(COB1.nombre, _ENCRYPTKEY) AS CHAR) AS nombre,
        COB1.cantidad AS cantidad,
        COB1.descripcion AS descripcion,
        CAST(AES_DECRYPT(COB1.telefono, _ENCRYPTKEY) AS CHAR) AS telefono,
        CAST(AES_DECRYPT(COB1.direccion, _ENCRYPTKEY) AS CHAR) AS direccion,
        CAST(AES_DECRYPT(COB1.correo, _ENCRYPTKEY) AS CHAR) AS correo,
        COB1.fecha_registro AS fechaRegistro,
        COB1.fecha_vencimiento AS fechaVencimiento,
        COB1.saldo AS saldo,
        CAST(AES_DECRYPT(COB1.latitud, _ENCRYPTKEY) AS CHAR) AS latitud,
        CAST(AES_DECRYPT(COB1.longitud, _ENCRYPTKEY) AS CHAR) AS longitud,
        COB1.ultimo_cargo AS ultimoCargo,
        COB1.fecha_ultimo_cargo AS fechaUltimoCargo,
        COB1.usuario_ultimo_cargo AS usuarioUltimoCargo,
        COB1.ultimo_abono AS ultimoAbono,
        COB1.fecha_ultimo_abono AS fechaUltimoAbono,
        COB1.usuario_ultimo_abono AS usuarioUltimoAbono,
        COB1.estatus AS estatus,
        COB1.bloqueado AS bloqueado,
        _USUARIO AS idCobrador,
        COB1.estatus_manual AS estatusManual
    FROM manzac.app_cobranzas COB1
    LEFT OUTER JOIN manzac.app_zonas_usuarios ZU1 ON COB1.zona = ZU1.id_zona
        WHERE COB1.id_sistema = _IDSISTEMA
			AND ZU1.usuario = _USUARIO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_DELETE(
    IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), IN _IDMOVIMIENTO VARCHAR(120)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.app_cargos_abonos WHERE 
            id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA 
            AND id_movimiento = _IDMOVIMIENTO
    );
    IF _VERIFY > 0 THEN
        DELETE FROM manzac.app_cargos_abonos 
            WHERE id_sistema = _IDSISTEMA 
                AND id_cobranza = _IDCOBRANZA 
                AND id_movimiento = _IDMOVIMIENTO;
    ELSE
        SET _VERIFY = 1;
        SELECT _VERIFY FROM manzac.app_cargos_abonos;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), 
    IN _IDMOVIMIENTO VARCHAR(120), IN _TIPO VARCHAR(20), IN _MONTO FLOAT, 
    IN _REFERENCIA VARCHAR(200), IN _USUARIOREGISTRO VARCHAR(150), 
    IN _FECHAREGISTRO VARCHAR(10), IN _GENERA VARCHAR(15)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.app_cargos_abonos WHERE 
            id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA
            AND id_movimiento = _IDMOVIMIENTO
    );
    IF _VERIFY = 0 THEN
        INSERT INTO manzac.app_cargos_abonos (
            tabla,
            id_sistema, 
            id_cobranza, 
            id_movimiento, 
            tipo, 
            monto, 
            referencia, 
            usuario_registro, 
            fecha_registro,
            genera
        ) VALUES (
            _TABLA, 
            _IDSISTEMA, 
            _IDCOBRANZA, 
            _IDMOVIMIENTO, 
            _TIPO, 
            _MONTO, 
            CONVERT(_REFERENCIA USING UTF8), 
            _USUARIOREGISTRO, 
            _FECHAREGISTRO,
            _GENERA
        );
    ELSE
        SELECT _VERIFY FROM manzac.app_cargos_abonos;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_ADMINISTRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_ADMINISTRADOR_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT
        CA1.tabla AS tabla,
        CA1.id_sistema AS idUsuario,
        CA1.id_cobranza AS idCobranza,
        CA1.id_movimiento AS idMovimiento,
        CA1.tipo AS tipo,
        CA1.monto AS monto,
        CA1.referencia AS referencia,
        CA1.usuario_registro AS usuarioRegistro,
        CA1.fecha_registro AS fechaRegistro,
        CA1.genera
    FROM manzac.app_cargos_abonos CA1
        WHERE CA1.id_sistema =  _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        CA1.tabla AS tabla,
        CA1.id_sistema AS idUsuario,
        CA1.id_cobranza AS idCobranza,
        CA1.id_movimiento AS idMovimiento,
        CA1.tipo AS tipo,
        CA1.monto AS monto,
        CA1.referencia AS referencia,
        CA1.usuario_registro AS usuarioRegistro,
        CA1.fecha_registro AS fechaRegistro,
        CA1.genera
    FROM manzac.app_cargos_abonos CA1
        LEFT OUTER JOIN manzac.app_cobranzas C1 ON CA1.id_cobranza = C1.id_cobranza
        LEFT OUTER JOIN manzac.app_zonas_usuarios ZU1 ON C1.zona = ZU1.id_zona
    WHERE CA1.id_sistema =  _IDSISTEMA
        AND ZU1.usuario = _USUARIO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_NOTAS_ADMINISTRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_NOTAS_ADMINISTRADOR_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_nota AS idNota,
        id_cobranza AS idCobranza,
        nota,
        usuario_crea AS usuarioCrea,
        usuario_visto AS usuarioVisto,
        fecha_crea AS fechaCrea
    FROM manzac.app_notas 
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_NOTAS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_NOTAS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        N1.tabla AS tabla,
        N1.id_sistema AS idUsuario,
        N1.id_nota AS idNota,
        N1.id_cobranza AS idCobranza,
        N1.nota,
        N1.usuario_crea AS usuarioCrea,
        N1.usuario_visto AS usuarioVisto,
        N1.fecha_crea AS fechaCrea
    FROM manzac.app_notas N1
        LEFT OUTER JOIN manzac.app_cobranzas C1 ON N1.id_cobranza = C1.id_cobranza
        LEFT OUTER JOIN manzac.app_zonas_usuarios ZU1 ON C1.zona = ZU1.id_zona
    WHERE N1.id_sistema = _IDSISTEMA
        AND ZU1.usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_NOTAS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_NOTAS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDNOTA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120),
    IN _NOTA VARCHAR(200), IN _USUARIOCREA VARCHAR(120),
    IN _USUARIOVISTO VARCHAR(120), IN _FECHACREA VARCHAR(10)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM manzac.app_notas WHERE 
            id_sistema = _IDSISTEMA 
            AND id_nota = _IDNOTA
    );
    IF _VERIFY = 0 THEN
        INSERT INTO manzac.app_notas (
            tabla, 
            id_sistema, 
            id_nota, 
            id_cobranza, 
            nota,
            usuario_crea,
            usuario_visto,
            fecha_crea
        ) VALUES (
            _TABLA, 
            _IDSISTEMA,
            _IDNOTA, 
            _IDCOBRANZA, 
            CONVERT(_NOTA USING UTF8),
            _USUARIOCREA,
            _USUARIOVISTO,
            _FECHACREA
        );
    ELSE
        IF _USUARIOVISTO = "" THEN
            UPDATE manzac.app_notas SET
                nota = CONVERT(_NOTA USING UTF8)
            WHERE
                id_sistema = _IDSISTEMA 
                AND id_nota = _IDNOTA;
        ELSE
            UPDATE manzac.app_notas SET
                nota = CONVERT(_NOTA USING UTF8),
                usuario_visto = _USUARIOVISTO
            WHERE
                id_sistema = _IDSISTEMA 
                AND id_nota = _IDNOTA;
        END IF;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CLIENTES_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CLIENTES_GET(
    IN _IDSISTEMA VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30)
)
BEGIN
    SELECT 
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_cliente AS idCliente,
        CAST(AES_DECRYPT(nombre, _ENCRYPTKEY) AS CHAR) AS nombre,
        CAST(AES_DECRYPT(telefono, _ENCRYPTKEY) AS CHAR) AS telefono,
        fecha_creacion AS fechaCreacion,
        activo AS activobit
    FROM manzac.app_clientes
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CLIENTES_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CLIENTES_DELETE(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    DELETE FROM 
        manzac.app_clientes
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CLIENTES_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CLIENTES_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDCLIENTE VARCHAR(120), IN _NOMBRE TEXT, 
    IN _TELEFONO TEXT, IN _FECHACREACION VARCHAR(10), 
    IN _ACTIVO BIT, IN _ENCRYPTKEY VARCHAR(30)
)
BEGIN
    INSERT INTO manzac.app_clientes (
        tabla, 
        id_sistema, 
        id_cliente, 
        nombre, 
        telefono, 
        fecha_creacion, 
        activo
    ) VALUES (
        _TABLA, 
        _IDSISTEMA, 
        _IDCLIENTE, 
        AES_ENCRYPT(CONVERT(_NOMBRE USING UTF8), _ENCRYPTKEY),
        AES_ENCRYPT(CONVERT(_TELEFONO USING UTF8), _ENCRYPTKEY),
        _FECHACREACION, 
        _ACTIVO
    );
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_INVENTARIOS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_INVENTARIOS_DELETE(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(120)
)
BEGIN
    DELETE FROM 
        manzac.app_inventarios
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_INVENTARIOS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_INVENTARIOS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), IN _IDARTICULO VARCHAR(120), 
    IN _CODIGOARTICULO VARCHAR(120), IN _DESCRIPCION VARCHAR(40), IN _MARCA VARCHAR(40), 
    IN _TALLA VARCHAR(40), IN _PRECIOCOMPRA FLOAT, 
    IN _PRECIOVENTA FLOAT, IN _EXISTENCIA FLOAT, IN _MAXIMO FLOAT, 
    IN _MINIMO FLOAT, IN _FECHACAMBIO VARCHAR(10), IN _USUARIO VARCHAR(120) 
)
BEGIN
    INSERT INTO manzac.app_inventarios (
        tabla,
        id_sistema,
        id_articulo,
        codigo_articulo,
        descripcion,
        marca,
        talla,
        precio_compra,
        precio_venta,
        existencia,
        maximo,
        minimo,
        fecha_cambio,
        usuario
    ) VALUES (
        _TABLA,
        _IDSISTEMA,
        _IDARTICULO,
        _CODIGOARTICULO,
        CONVERT(_DESCRIPCION USING UTF8),
        CONVERT(_MARCA USING UTF8),
        CONVERT(_TALLA USING UTF8),
        _PRECIOCOMPRA,
        _PRECIOVENTA,
        _EXISTENCIA,
        _MAXIMO,
        _MINIMO,
        _FECHACAMBIO,
        _USUARIO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_INVENTARIOS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_INVENTARIOS_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(120)
)
BEGIN
    SELECT 
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_articulo AS idArticulo,
        codigo_articulo AS codigoArticulo,
        descripcion,
        marca,
        talla,
        precio_compra AS precioCompra,
        precio_venta AS precioVenta,
        existencia,
        maximo AS maximo,
        minimo AS minimo,
        fecha_cambio AS fechaCambio,
        usuario
    FROM manzac.app_inventarios
        WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* -------------------- AUX ------------------------------ */
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_SESION_AUX;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_SESION_AUX(
    IN _FUNCION VARCHAR(150),
    IN _IDSISTEMA VARCHAR(400),
    IN _USUARIO VARCHAR(400),
    IN _SESSION VARCHAR(400),
    IN _FIREBASE VARCHAR(400)
)
BEGIN
    INSERT INTO manzac.app_aux (
        funcion,
        value1, 
        value2, 
        value3, 
        value4
    ) VALUES (
        _FUNCION,
        _IDSISTEMA, 
        _USUARIO, 
        _SESSION, 
        _FIREBASE
    );
END $$
DELIMITER ;