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