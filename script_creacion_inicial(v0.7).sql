USE GD1C2026
GO

-- CREAR SCHEMA --

CREATE SCHEMA LOS_RELACIONALES;
GO

-- CREAR TABLAS --

CREATE TABLE LOS_RELACIONALES.agencia(
	NRO_AGENCIA bigint PRIMARY KEY,
	DIRECCION nvarchar(255),
	TELEFONO nvarchar(255),
	MAIL nvarchar(255),
	LOCALIDAD nvarchar(255),
	PROVINCIA nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.cliente(
	CLIENTE_ID bigint IDENTITY PRIMARY KEY,
	COD_AGENCIA bigint REFERENCES LOS_RELACIONALES.agencia(NRO_AGENCIA),
	NOMBRE nvarchar(255),
	APELLIDO nvarchar(255),
	DNI nvarchar(255),
	TELEFONO nvarchar(255),
	EMAIL nvarchar(255),
	DIRECCION nvarchar(255),
	FECHA_NAC date,
	LOCALIDAD nvarchar(255),
	PROVINCIA nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.agente(
	LEGAJO bigint PRIMARY KEY,
	COD_AGENCIA bigint REFERENCES LOS_RELACIONALES.agencia(NRO_AGENCIA),
	NOMBRE nvarchar(255),
	APELLIDO nvarchar(255),
	DNI nvarchar(255),
	FECHA_NAC date,
	TELEFONO nvarchar(255),
	EMAIL nvarchar(255),
	DIRECCION nvarchar(255),
	LOCALIDAD nvarchar(255),
	PROVINCIA nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.solicitud(
	NRO_SOLICITUD bigint PRIMARY KEY,
	COD_AGENTE bigint REFERENCES LOS_RELACIONALES.agente(LEGAJO),
	COD_CLIENTE bigint REFERENCES LOS_RELACIONALES.cliente(CLIENTE_ID),
	FECHA_SOLICITUD date,
	FECHA_INICIO_TENTATIVA date,
	FECHA_FIN_TENTATIVA date,
	CANT_PAX int,
	OBSERVACIONES nvarchar(max),
	PRESUPUESTO_ESTIMADO decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.pais(
	PAIS_ID bigint IDENTITY PRIMARY KEY,
	NOMBRE nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.ciudad(
	CIUDAD_ID bigint IDENTITY PRIMARY KEY,
	COD_PAIS bigint REFERENCES LOS_RELACIONALES.pais(PAIS_ID),
	NOMBRE nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.detalle_solicitud(
	COD_SOLICITUD bigint REFERENCES LOS_RELACIONALES.solicitud(NRO_SOLICITUD),
	COD_CIUDAD bigint REFERENCES LOS_RELACIONALES.ciudad(CIUDAD_ID), 
	DT_SOL_CANT_DIAS_APROX int,
	DT_SOL_OBSERVACIONES nvarchar(max),

	CONSTRAINT PK_DETALLE_SOLICITUD
        PRIMARY KEY (COD_SOLICITUD, COD_CIUDAD)
);

CREATE TABLE LOS_RELACIONALES.estado_propuesta(
	ESTADO_ID bigint IDENTITY PRIMARY KEY,
	ESTADO nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.encuesta(
	CODIGO_ENCUESTA bigint PRIMARY KEY,
	COD_AGENTE bigint REFERENCES LOS_RELACIONALES.agente(LEGAJO),
	COD_CLIENTE bigint REFERENCES LOS_RELACIONALES.cliente(CLIENTE_ID),
	FECHA_ENCUESTA date,
	COMENTARIOS nvarchar(max)
);

CREATE TABLE LOS_RELACIONALES.aspecto(
	ASPECTO_ID bigint IDENTITY PRIMARY KEY,
	ASPECTO nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.detalle_encuesta_puntaje(
	COD_ENCUESTA bigint REFERENCES LOS_RELACIONALES.encuesta(CODIGO_ENCUESTA),
	COD_ASPECTO bigint REFERENCES LOS_RELACIONALES.aspecto(ASPECTO_ID),
	DT_ENCUESTA_PUNTAJE int,

	CONSTRAINT PK_DETALLE_ENCUESTA_PUNTAJE
		PRIMARY KEY (COD_ENCUESTA, COD_ASPECTO)
);

CREATE TABLE LOS_RELACIONALES.propuesta(
	NRO_PROPUESTA bigint PRIMARY KEY,
	COD_SOLICITUD bigint REFERENCES LOS_RELACIONALES.solicitud(NRO_SOLICITUD),
	COD_ESTADO bigint REFERENCES LOS_RELACIONALES.estado_propuesta(ESTADO_ID),
	FECHA_EMISION date,
	VIGENCIA_HASTA date,
	FECHA_DESDE date,
	FECHA_HASTA date,
	SUBTOTAL decimal(18,2),
	DESCUENTO decimal(18,2),
	IMPORTE_TOTAL decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.alianza(
	ALIANZA_ID bigint IDENTITY PRIMARY KEY,
	ALIANZA nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.aerolinea(
	CODIGO_AEROLINEA nvarchar(255) PRIMARY KEY,
	COD_PAIS bigint REFERENCES LOS_RELACIONALES.pais(PAIS_ID),					-- AGREGADO
	ALIANZA bigint REFERENCES LOS_RELACIONALES.alianza(ALIANZA_ID),
	NOMBRE nvarchar(255),
	-- PAIS nvarchar(255)														-- ELIMINADO
);

CREATE TABLE LOS_RELACIONALES.aeropuerto_salida(
	AER_SAL_CODIGO nvarchar(10) PRIMARY KEY,
	COD_PAIS bigint REFERENCES LOS_RELACIONALES.pais(PAIS_ID),					-- AGREGADO																			-- AGREGADO
	COD_CIUDAD bigint REFERENCES LOS_RELACIONALES.ciudad(CIUDAD_ID),
	AER_SAL_DESCRIPCION nvarchar(200),
	-- AER_SAL_CIUDAD nvarchar(255), 											-- ELIMINADO
	-- AER_SAL_PAIS nvarchar(255)												-- ELIMINADO
);

CREATE TABLE LOS_RELACIONALES.aeropuerto_llegada(
	AER_LLEG_CODIGO nvarchar(10) PRIMARY KEY,
	COD_PAIS bigint REFERENCES LOS_RELACIONALES.pais(PAIS_ID),					-- AGREGADO
	COD_CIUDAD bigint REFERENCES LOS_RELACIONALES.ciudad(CIUDAD_ID),
	AER_LLEG_DESCRIPCION nvarchar(200),
	--AER_LLEG_CIUDAD nvarchar(255),											-- ELIMINADO
	--AER_LLEG_PAIS nvarchar(255)												-- ELIMINADO
);

CREATE TABLE LOS_RELACIONALES.vuelo(
	NRO_VUELO bigint IDENTITY PRIMARY KEY,
	COD_AEROLINEA nvarchar(255) REFERENCES LOS_RELACIONALES.aerolinea(CODIGO_AEROLINEA),
	COD_AEROPUERTO_SALIDA nvarchar(10) REFERENCES LOS_RELACIONALES.aeropuerto_salida(AER_SAL_CODIGO),
	COD_AEROPUERTO_LLEGADA nvarchar(10) REFERENCES LOS_RELACIONALES.aeropuerto_llegada(AER_LLEG_CODIGO),
	FECHA_SALIDA date,
	HORARIO_SALIDA nvarchar(50),
	FECHA_LLEGADA  date,
	HORARIO_LLEGADA nvarchar(50),
	DURACION int,
	PRECIO decimal(18,2),
	INCLUYE_CARRY bit,
	INCLUYE_VALIJA bit
);

CREATE TABLE LOS_RELACIONALES.hospedaje(
	CODIGO_HOSPEDAJE bigint IDENTITY PRIMARY KEY,
	COD_PAIS bigint REFERENCES LOS_RELACIONALES.pais(PAIS_ID),					-- AGREGADO
	COD_CIUDAD bigint REFERENCES LOS_RELACIONALES.ciudad(CIUDAD_ID),
	-- PAIS nvarchar(255),														-- ELIMINADO
	NOMBRE nvarchar(255),
	DIRECCION nvarchar(255),
	INCLUYE_DESAYUNO bit,
	CHECK_IN nvarchar(50),
	CHECK_OUT nvarchar(50)
);

CREATE TABLE LOS_RELACIONALES.habitacion(
	HABITACION_ID bigint IDENTITY PRIMARY KEY,
	COD_HOSPEDAJE bigint REFERENCES LOS_RELACIONALES.hospedaje(CODIGO_HOSPEDAJE),
	NOMBRE nvarchar(255),
	DESCRIPCION nvarchar(max),
	PRECIO decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.proveedor(
	PROVEEDOR_ID bigint IDENTITY PRIMARY KEY,
	NOMBRE nvarchar(255),
	EMAIL nvarchar(255),
	TELEFONO nvarchar(255)
);

-- REVISAR
CREATE TABLE LOS_RELACIONALES.excursion(
	COD_EXCURSION bigint IDENTITY PRIMARY KEY,
	-- COD_CIUDAD bigint REFERENCES LOS_RELACIONALES.ciudad(CIUDAD_ID),				-- ELIMINADO
	COD_PROVEEDOR bigint REFERENCES LOS_RELACIONALES.proveedor(PROVEEDOR_ID),
	NOMBRE nvarchar(255),
	DESCRIPCION nvarchar(max),
	HORARIO nvarchar(50),
	DURACION int,
	PRECIO decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.detalle_propuesta_vuelo(
	COD_RESERVA_VUELO bigint IDENTITY PRIMARY KEY,
	COD_PROPUESTA bigint REFERENCES LOS_RELACIONALES.propuesta(NRO_PROPUESTA),
	COD_VUELO bigint REFERENCES LOS_RELACIONALES.vuelo(NRO_VUELO),
	DT_PROP_VUELO_CANT_PASAJES int,
	DT_PROP_VUELO_PRECIO decimal(18,2),
	DT_PROP_VUELO_SUBTOTAL decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.detalle_propuesta_habitacion(
	COD_RESERVA_HOSPEDAJE bigint IDENTITY PRIMARY KEY,
	COD_PROPUESTA bigint REFERENCES LOS_RELACIONALES.propuesta(NRO_PROPUESTA),
	COD_HABITACION bigint REFERENCES LOS_RELACIONALES.habitacion(HABITACION_ID),
	DT_PROP_HOSPEDAJE_FECHA_DESDE date,
	DT_PROP_HOSPEDAJE_FECHA_HASTA date,
	DT_PROP_HOSPEDAJE_CANT int,
	DT_PROP_HOSPEDAJE_PRECIO decimal(18,2),
	DT_PROP_HOSPEDAJE_SUBTOTAL decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.canal_venta(
	CANAL_VENTA_ID bigint IDENTITY PRIMARY KEY,
	CANAL_VENTA nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.medio_pago(
	MEDIO_PAGO_ID bigint IDENTITY PRIMARY KEY,
	MEDIO_PAGO nvarchar(255)
);

CREATE TABLE LOS_RELACIONALES.venta(
	NRO_VENTA bigint PRIMARY KEY,
	COD_CLIENTE bigint REFERENCES LOS_RELACIONALES.cliente(CLIENTE_ID),
	COD_AGENTE bigint REFERENCES LOS_RELACIONALES.agente(LEGAJO),
	CANAL_VENTA bigint REFERENCES LOS_RELACIONALES.canal_venta(CANAL_VENTA_ID),
	MEDIO_PAGO bigint REFERENCES LOS_RELACIONALES.medio_pago(MEDIO_PAGO_ID),
	FECHA_VENTA date,
	SUBTOTAL decimal(18,2),
	DESCUENTO decimal(18,2),
	IMPORTE_TOTAL decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.venta_propuesta(
	COD_VENTA bigint REFERENCES LOS_RELACIONALES.venta(NRO_VENTA),
	COD_PROPUESTA bigint REFERENCES LOS_RELACIONALES.propuesta(NRO_PROPUESTA),

	CONSTRAINT PK_VENTA_PROPUESTA
        PRIMARY KEY (COD_VENTA, COD_PROPUESTA)
);

CREATE TABLE LOS_RELACIONALES.detalle_venta_vuelo(
	DT_VENTA_VUELO_COD_RESERVA nvarchar(255) PRIMARY KEY,
	COD_VENTA bigint REFERENCES LOS_RELACIONALES.venta(NRO_VENTA),
	COD_VUELO bigint REFERENCES LOS_RELACIONALES.vuelo(NRO_VUELO),
	DT_VENTA_VUELO_CANT_PASAJES int,
	DT_VENTA_VUELO_PRECIO_UNITARIO decimal(18,2),
	DT_VENTA_VUELO_SUBTOTAL decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.detalle_venta_habitacion(
	DT_VENTA_HOSP_COD_RESERVA nvarchar(255) PRIMARY KEY,
	COD_VENTA bigint REFERENCES LOS_RELACIONALES.venta(NRO_VENTA),
	COD_HABITACION bigint REFERENCES LOS_RELACIONALES.habitacion(HABITACION_ID),
	DT_VENTA_HOSPEDAJE_FECHA_DESDE date,
	DT_VENTA_HOSPEDAJE_FECHA_HASTA date,
	DT_VENTA_HOSPEDAJE_CANTIDAD int,
	DT_VENTA_HOSPEDAJE_PRECIO_UNITARIO decimal(18,2),
	DT_VENTA_HOSPEDAJE_SUBTOTAL decimal(18,2)
);

CREATE TABLE LOS_RELACIONALES.detalle_venta_excursion(
	DT_VENTA_EXC_COD_RESERVA nvarchar(255) PRIMARY KEY,
	COD_VENTA bigint REFERENCES LOS_RELACIONALES.venta(NRO_VENTA),
	COD_EXCURSION bigint REFERENCES LOS_RELACIONALES.excursion(COD_EXCURSION),
	DT_VENTA_EXCURSION_FECHA_RESERVA date,
	DT_VENTA_EXCURSION_CANT int,
	DT_VENTA_EXCURSION_PRECIO_UNITARIO decimal(18,2),
	DT_VENTA_EXCURSION_SUBTOTAL decimal(18,2)
);

GO

-- CREAR STORED PROCEDURES PARA MIGRACIÓN --

CREATE PROCEDURE migracion_pais
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.pais (
        NOMBRE
    )
    SELECT Aeropuerto_Salida_Pais
    FROM gd_esquema.Maestra
	WHERE Aeropuerto_Salida_Pais IS NOT NULL
		UNION
    SELECT Aeropuerto_Llegada_Pais
    FROM gd_esquema.Maestra
	WHERE Aeropuerto_Llegada_Pais IS NOT NULL
		UNION
    SELECT Aerolinea_Pais
    FROM gd_esquema.Maestra
	WHERE Aerolinea_Pais IS NOT NULL
		UNION
    SELECT Hospedaje_Pais
    FROM gd_esquema.Maestra
	WHERE Hospedaje_Pais IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_ciudad
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.ciudad(
		COD_PAIS, 
		NOMBRE
	)
	SELECT
        p.PAIS_ID,
        m.Aeropuerto_Salida_Ciudad
    FROM gd_esquema.Maestra m
        JOIN LOS_RELACIONALES.pais p
            ON p.NOMBRE = m.Aeropuerto_Salida_Pais
	WHERE m.Aeropuerto_Salida_Ciudad IS NOT NULL
		UNION
    SELECT
        p.PAIS_ID,
        m.Aeropuerto_Llegada_Ciudad
    FROM gd_esquema.Maestra m
        JOIN LOS_RELACIONALES.pais p
            ON p.NOMBRE = m.Aeropuerto_Llegada_Pais
	WHERE m.Aeropuerto_Llegada_Ciudad IS NOT NULL
		UNION
    SELECT
        p.PAIS_ID,
        m.Hospedaje_Ciudad
    FROM gd_esquema.Maestra m
        JOIN LOS_RELACIONALES.pais p
            ON p.NOMBRE = m.Hospedaje_Pais
	WHERE m.Hospedaje_Ciudad IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_agencia
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.agencia(
		NRO_AGENCIA, 
		DIRECCION, 
		TELEFONO, 
		MAIL, 
		LOCALIDAD, 
		PROVINCIA
	)
	SELECT DISTINCT 
		Agencia_Nro_Agencia, 
		Agencia_Direccion, 
		Agencia_Telefono, 
		Agencia_Mail, 
		Agencia_Localidad, 
		Agencia_Provincia
	FROM gd_esquema.Maestra
	WHERE Agencia_Nro_Agencia IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_cliente
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.cliente(
		NOMBRE, 
		APELLIDO, 
		DNI, 
		TELEFONO, 
		EMAIL, 
		DIRECCION,
		FECHA_NAC, 
		LOCALIDAD, 
		PROVINCIA
	)
	SELECT DISTINCT
		Cliente_Nombre,
        Cliente_Apellido,
        Cliente_Dni,
        Cliente_Tel,
        Cliente_Mail,
        Cliente_Direccion,
        Cliente_Fecha_Nac,
        Cliente_Localidad,
        Cliente_Provincia 
	FROM gd_esquema.Maestra
	WHERE Cliente_Dni IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_agente
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.agente(
		LEGAJO, 
		COD_AGENCIA, 
		NOMBRE, 
		APELLIDO, 
		DNI, 
		FECHA_NAC, 
		TELEFONO, 
		EMAIL, 
		DIRECCION, 
		LOCALIDAD, 
		PROVINCIA
	)
	SELECT DISTINCT
		Agente_Legajo, 
		Agencia_Nro_Agencia,
		Agente_Nombre,
        Agente_Apellido,
        Agente_Dni,
        Agente_Fecha_Nac,
        Agente_Telefono,
        Agente_Mail,
        Agente_Direccion,
        Agente_Localidad,
        Agente_Provincia
	FROM gd_esquema.Maestra
	WHERE Agente_Legajo IS NOT NULL 
		AND Agencia_Nro_Agencia IS NOT NULL
END;
GO

CREATE PROCEDURE migracion_alianza
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.alianza(
		ALIANZA
	)
	SELECT DISTINCT
		Aerolinea_Alianza
	FROM gd_esquema.Maestra
	WHERE Aerolinea_Alianza IS NOT NULL
END;
GO

CREATE PROCEDURE migracion_aerolinea
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.aerolinea(
		CODIGO_AEROLINEA,
		COD_PAIS,
		ALIANZA, 
		NOMBRE 
	)
	SELECT DISTINCT
		m.Aerolinea_Codigo,
		p.PAIS_ID,
		a.ALIANZA_ID,
		m.Aerolinea_Nombre
	FROM gd_esquema.Maestra m
		LEFT JOIN LOS_RELACIONALES.alianza a ON a.ALIANZA = m.Aerolinea_Alianza
		JOIN LOS_RELACIONALES.pais p ON p.NOMBRE = M.Aerolinea_Pais
	WHERE Aerolinea_Codigo IS NOT NULL
END;
GO

CREATE PROCEDURE migracion_aeropuerto_salida
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.aeropuerto_salida(
		AER_SAL_CODIGO,
		COD_PAIS,
		COD_CIUDAD, 
		AER_SAL_DESCRIPCION 
	)
	SELECT DISTINCT
		m.Aeropuerto_Salida_Codigo,
		p.PAIS_ID,
		c.CIUDAD_ID,
		m.Aeropuerto_Salida_Descripcion
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.pais p ON p.NOMBRE = m.Aeropuerto_Salida_Pais
		JOIN LOS_RELACIONALES.ciudad c ON c.NOMBRE = m.Aeropuerto_Salida_Ciudad
	WHERE m.Aeropuerto_Salida_Codigo IS NOT NULL
		AND m.Aeropuerto_Salida_Pais IS NOT NULL
		AND m.Aeropuerto_Salida_Ciudad IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_aeropuerto_llegada
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.aeropuerto_llegada(
		AER_LLEG_CODIGO,
		COD_PAIS,
		COD_CIUDAD, 
		AER_LLEG_DESCRIPCION
	)
	SELECT DISTINCT
		m.Aeropuerto_Llegada_Codigo,
		p.PAIS_ID,
		c.CIUDAD_ID, 
		m.Aeropuerto_Llegada_Descripcion
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.pais p ON p.NOMBRE = m.Aeropuerto_Llegada_Pais
		JOIN LOS_RELACIONALES.ciudad c ON c.NOMBRE = m.Aeropuerto_Llegada_Ciudad
	WHERE m.Aeropuerto_Llegada_Codigo IS NOT NULL
		AND m.Aeropuerto_Llegada_Pais IS NOT NULL
		AND m.Aeropuerto_Llegada_Ciudad IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_proveedor
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.proveedor(
		NOMBRE, 
		EMAIL, 
		TELEFONO
	)
	SELECT DISTINCT
		Proveedor_Nombre, 
		Proveedor_Mail, 
		Proveedor_Telefono
	FROM gd_esquema.Maestra
	WHERE Proveedor_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_hospedaje
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.hospedaje(
		COD_PAIS,
		COD_CIUDAD,
		NOMBRE, 
		DIRECCION, 
		INCLUYE_DESAYUNO, 
		CHECK_IN, 
		CHECK_OUT
	)
	SELECT DISTINCT
		p.PAIS_ID,
		c.CIUDAD_ID,
		m.Hospedaje_Nombre,
		m.Hospedaje_Direccion, 
		m.Hospedaje_Incluye_Desayuno, 
		m.Hospedaje_Check_In, 
		m.Hospedaje_Check_Out
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.pais p ON p.NOMBRE = m.Hospedaje_Pais
		JOIN LOS_RELACIONALES.ciudad c ON c.NOMBRE = m.Hospedaje_Ciudad
	WHERE m.Hospedaje_Nombre IS NOT NULL
		AND m.Hospedaje_Ciudad IS NOT NULL
		AND m.Hospedaje_Pais IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_habitacion
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.habitacion(
		COD_HOSPEDAJE, 
		NOMBRE, 
		DESCRIPCION, 
		PRECIO
	)
	SELECT DISTINCT
		h.CODIGO_HOSPEDAJE, 
		m.Habitacion_Nombre, 
		m.Habitacion_Descripcion, 
		m.Habitacion_Precio_Noche
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.hospedaje h ON h.NOMBRE = m.Hospedaje_Nombre
			AND h.DIRECCION = m.Hospedaje_Direccion
	WHERE m.Habitacion_Nombre IS NOT NULL;
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_excursion
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.excursion(
		COD_PROVEEDOR, 
		NOMBRE, 
		DESCRIPCION, 
		HORARIO, 
		DURACION, 
		PRECIO
	)
	SELECT DISTINCT
		p.PROVEEDOR_ID,
		m.Excursion_Nombre, 
		m.Excursion_Descripcion, 
		m.Excursion_Horario, 
		m.Excursion_Duracion, 
		m.Excursion_Precio
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.proveedor p ON p.NOMBRE = m.Proveedor_Nombre
	WHERE m.Excursion_Nombre IS NOT NULL
		AND m.Proveedor_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_estado_propuesta
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.estado_propuesta(
		ESTADO
	)
	SELECT DISTINCT
		Propuesta_Estado
	FROM gd_esquema.Maestra
	WHERE Propuesta_Estado IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_canal_venta
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.canal_venta(
		CANAL_VENTA
	)
	SELECT DISTINCT
		Venta_Canal_Venta
	FROM gd_esquema.Maestra
	WHERE Venta_Canal_Venta IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_medio_pago
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.medio_pago(
		MEDIO_PAGO
	)
	SELECT DISTINCT
		Venta_Medio_Pago
	FROM gd_esquema.Maestra
	WHERE Venta_Medio_Pago IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_aspecto
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.aspecto(
		ASPECTO
	)
	SELECT DISTINCT
		Aspecto_Aspecto
	FROM gd_esquema.Maestra
	WHERE Aspecto_Aspecto IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_encuesta
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.encuesta(
		CODIGO_ENCUESTA, 
		COD_AGENTE,
		COD_CLIENTE,
		FECHA_ENCUESTA, 
		COMENTARIOS
	)
	SELECT DISTINCT
        m.Encuesta_Codigo_Encuesta,
		m.Agente_Legajo,
		c.CLIENTE_ID,
        m.Encuesta_Fecha_Encuesta,
        m.Encuesta_Comentarios
    FROM gd_esquema.Maestra m
		JOIN LOS_RELACIONALES.cliente c ON c.DNI = m.Cliente_Dni
    WHERE Encuesta_Codigo_Encuesta IS NOT NULL
END;
GO

CREATE PROCEDURE migracion_solicitud
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.solicitud(
		NRO_SOLICITUD, 
		COD_AGENTE, 
		COD_CLIENTE, 
		FECHA_SOLICITUD, 
		FECHA_INICIO_TENTATIVA, 
		FECHA_FIN_TENTATIVA, 
		CANT_PAX, 
		OBSERVACIONES, 
		PRESUPUESTO_ESTIMADO
	)
	SELECT DISTINCT 
		m.Solicitud_Nro_Solicitud, 
		m.Agente_Legajo, 
		c.CLIENTE_ID, 
		m.Solicitud_Fecha_Solicitud, 
		m.Solicitud_Fecha_Inicio_Tentativa, 
		m.Solicitud_Fecha_Fin_Tentativa, 
		m.Solicitud_Cant_Pax, 
		m.Solicitud_Observaciones, 
		m.Solicitud_Presupuesto_Estimado
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.cliente c ON c.DNI = m.Cliente_Dni
	WHERE m.Solicitud_Nro_Solicitud IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_detalle_solicitud
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.detalle_solicitud(
		COD_SOLICITUD, 
		COD_CIUDAD, 
		DT_SOL_CANT_DIAS_APROX, 
		DT_SOL_OBSERVACIONES
	)
	SELECT DISTINCT
		m.Solicitud_Nro_Solicitud,
		c.CIUDAD_ID,
		m.Detalle_Solicitud_Cant_Dias_Aprox, 
		m.Detalle_Solicitud_Observaciones
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.ciudad c ON c.NOMBRE = m.Detalle_Solicitud_Ciudad
	WHERE m.Solicitud_Nro_Solicitud IS NOT NULL
		AND m.Detalle_Solicitud_Ciudad IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_propuesta
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.propuesta(
		NRO_PROPUESTA, 
		COD_SOLICITUD, 
		COD_ESTADO, 
		FECHA_EMISION, 
		VIGENCIA_HASTA, 
		FECHA_DESDE, 
		FECHA_HASTA, 
		SUBTOTAL, 
		DESCUENTO, 
		IMPORTE_TOTAL
	)
	SELECT DISTINCT
		m.Propuesta_Nro_Propuesta,
		s.NRO_SOLICITUD, 
		ep.ESTADO_ID,
		m.Propuesta_Fecha_Emision, 
		m.Propuesta_Vigencia_Hasta, 
		m.Propuesta_Fecha_Desde, 
		m.Propuesta_Fecha_Hasta, 
		m.Propuesta_Subtotal, 
		m.Propuesta_Descuento, 
		m.Propuesta_Importe_Total
	FROM gd_esquema.Maestra m
		JOIN LOS_RELACIONALES.solicitud s ON s.NRO_SOLICITUD = m.Solicitud_Nro_Solicitud
		JOIN LOS_RELACIONALES.estado_propuesta ep ON ep.ESTADO = m.Propuesta_Estado
	WHERE Propuesta_Nro_Propuesta IS NOT NULL
		AND m.Solicitud_Nro_Solicitud IS NOT NULL
		AND m.Propuesta_Estado IS NOT NULL;
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_vuelo
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.vuelo( 
		COD_AEROLINEA, 
		COD_AEROPUERTO_SALIDA, 
		COD_AEROPUERTO_LLEGADA, 
		FECHA_SALIDA, 
		HORARIO_SALIDA, 
		FECHA_LLEGADA, 
		HORARIO_LLEGADA, 
		DURACION, 
		PRECIO, 
		INCLUYE_CARRY, 
		INCLUYE_VALIJA
	)
	SELECT DISTINCT
		a.CODIGO_AEROLINEA,
		asal.AER_SAL_CODIGO,
		alleg.AER_LLEG_CODIGO,
		m.Vuelo_Fecha_Salida, 
		m.Vuelo_Horario_Salida, 
		m.Vuelo_Fecha_Llegada, 
		m.Vuelo_Horario_Llegada, 
		m.Vuelo_Duracion, 
		m.Vuelo_Precio, 
		m.Vuelo_Incluye_Carry, 
		m.Vuelo_Incluye_Valija
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.aerolinea a ON a.CODIGO_AEROLINEA = m.Aerolinea_Codigo
		JOIN LOS_RELACIONALES.aeropuerto_salida asal ON asal.AER_SAL_CODIGO = m.Aeropuerto_Salida_Codigo
		JOIN LOS_RELACIONALES.aeropuerto_llegada alleg ON alleg.AER_LLEG_CODIGO = m.Aeropuerto_Llegada_Codigo
	WHERE m.Aerolinea_Codigo IS NOT NULL
		AND m.Aeropuerto_Salida_Codigo IS NOT NULL
		AND m.Aeropuerto_Llegada_Codigo IS NOT NULL;
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_detalle_propuesta_vuelo
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.detalle_propuesta_vuelo( 
		COD_PROPUESTA, 
		COD_VUELO, 
		DT_PROP_VUELO_CANT_PASAJES, 
		DT_PROP_VUELO_PRECIO, 
		DT_PROP_VUELO_SUBTOTAL
	)
	SELECT DISTINCT
		p.NRO_PROPUESTA,
		v.NRO_VUELO,
		m.Detalle_Propuesta_Vuelo_Cant_Pasajes, 
		m.Detalle_Propuesta_Vuelo_Precio, 
		m.Detalle_Propuesta_Vuelo_Subtotal
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.propuesta p ON p.NRO_PROPUESTA = m.Propuesta_Nro_Propuesta
		JOIN LOS_RELACIONALES.vuelo v ON v.COD_AEROLINEA = m.Aerolinea_Codigo
	WHERE m.Propuesta_Nro_Propuesta IS NOT NULL
		AND m.Aerolinea_Codigo IS NOT NULL;
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_detalle_propuesta_habitacion
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.detalle_propuesta_habitacion( 
		COD_PROPUESTA, 
		COD_HABITACION, 
		DT_PROP_HOSPEDAJE_FECHA_DESDE, 
		DT_PROP_HOSPEDAJE_FECHA_HASTA, 
		DT_PROP_HOSPEDAJE_CANT, 
		DT_PROP_HOSPEDAJE_PRECIO, 
		DT_PROP_HOSPEDAJE_SUBTOTAL
	)
	SELECT DISTINCT
		p.NRO_PROPUESTA, 
		h.HABITACION_ID,
		m.Detalle_Propuesta_Hospedaje_Fecha_Desde, 
		m.Detalle_Propuesta_Hospedaje_Fecha_Hasta, 
		m.Detalle_Propuesta_Hospedaje_Cant, 
		m.Detalle_Propuesta_Hospedaje_Precio, 
		m.Detalle_Propuesta_Hospedaje_Subtotal
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.propuesta p ON p.NRO_PROPUESTA = m.Propuesta_Nro_Propuesta
		JOIN LOS_RELACIONALES.habitacion h ON h.NOMBRE = m.Hospedaje_Nombre
	WHERE m.Propuesta_Nro_Propuesta IS NOT NULL
		AND m.Habitacion_Nombre IS NOT NULL;			
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_venta
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.venta(
		NRO_VENTA, 
		COD_CLIENTE, 
		COD_AGENTE, 
		CANAL_VENTA, 
		MEDIO_PAGO, 
		FECHA_VENTA, 
		SUBTOTAL, 
		DESCUENTO, 
		IMPORTE_TOTAL
	)
	SELECT DISTINCT
		m.Venta_Nro_Venta,
		c.CLIENTE_ID,
		a.LEGAJO,
		cv.CANAL_VENTA_ID,
		mp.MEDIO_PAGO_ID,
		m.Venta_Fecha_Venta, 
		m.Venta_Subtotal, 
		m.Venta_Descuento, 
		m.Venta_Importe_Total
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.cliente c ON c.DNI = m.Cliente_Dni
		JOIN LOS_RELACIONALES.agente a ON a.LEGAJO = m.Agente_Legajo
		JOIN LOS_RELACIONALES.canal_venta cv ON cv.CANAL_VENTA = m.Venta_Canal_Venta
		JOIN LOS_RELACIONALES.medio_pago mp ON mp.MEDIO_PAGO = m.Venta_Medio_Pago
	WHERE m.Venta_Nro_Venta IS NOT NULL
		AND m.Cliente_Dni IS NOT NULL
		AND m.Agente_Legajo IS NOT NULL
		AND m.Venta_Canal_Venta IS NOT NULL
		AND m.Venta_Medio_Pago IS NOT NULL;				
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_venta_propuesta
AS 
BEGIN
	INSERT INTO LOS_RELACIONALES.venta_propuesta(
		COD_VENTA,
		COD_PROPUESTA
	)
	SELECT DISTINCT
		v.NRO_VENTA,
		p.NRO_PROPUESTA
	FROM gd_esquema.Maestra m
		LEFT JOIN LOS_RELACIONALES.venta v ON v.NRO_VENTA = m.Venta_Nro_Venta
		LEFT JOIN LOS_RELACIONALES.propuesta p ON p.NRO_PROPUESTA = m.Propuesta_Nro_Propuesta
	WHERE m.Venta_Nro_Venta IS NOT NULL
		AND m.Propuesta_Nro_Propuesta IS NOT NULL;
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_detalle_venta_vuelo
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.detalle_venta_vuelo(
		DT_VENTA_VUELO_COD_RESERVA, 
		COD_VENTA, 
		COD_VUELO, 
		DT_VENTA_VUELO_CANT_PASAJES, 
		DT_VENTA_VUELO_PRECIO_UNITARIO, 
		DT_VENTA_VUELO_SUBTOTAL
	)
	SELECT DISTINCT 
		m.Detalle_Venta_Vuelo_Cod_Reserva,
		vt.NRO_VENTA,
		v.NRO_VUELO,
		m.Detalle_Venta_Vuelo_Cantidad_Pasajes, 
		m.Detalle_Venta_Vuelo_Precio_Unitario, 
		m.Detalle_Venta_Vuelo_Subtotal
	FROM gd_esquema.Maestra m
		JOIN LOS_RELACIONALES.venta vt ON vt.NRO_VENTA = m.Venta_Nro_Venta
		JOIN LOS_RELACIONALES.vuelo v ON v.COD_AEROLINEA = m.Aerolinea_Codigo
	WHERE m.Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL
		AND m.Venta_Nro_Venta IS NOT NULL
		AND m.Aerolinea_Codigo IS NOT NULL;
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_detalle_venta_hospedaje
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.detalle_venta_habitacion(
		DT_VENTA_HOSP_COD_RESERVA, 
		COD_VENTA, 
		COD_HABITACION, 
		DT_VENTA_HOSPEDAJE_FECHA_DESDE, 
		DT_VENTA_HOSPEDAJE_FECHA_HASTA, 
		DT_VENTA_HOSPEDAJE_CANTIDAD, 
		DT_VENTA_HOSPEDAJE_PRECIO_UNITARIO, 
		DT_VENTA_HOSPEDAJE_SUBTOTAL
	)
	SELECT DISTINCT 
		m.Detalle_Venta_Hospedaje_Cod_Reserva,
		v.NRO_VENTA,
		h.HABITACION_ID,
		m.Detalle_Venta_Hospedaje_Fecha_Desde, 
		m.Detalle_Venta_Hospedaje_Fecha_Hasta, 
		m.Detalle_Venta_Hospedaje_Cantidad, 
		m.Detalle_Venta_Hospedaje_Precio_Unitario, 
		m.Detalle_Venta_Hospedaje_Subtotal
	FROM gd_esquema.Maestra m
		JOIN LOS_RELACIONALES.venta v ON v.NRO_VENTA = m.Venta_Nro_Venta
		JOIN LOS_RELACIONALES.habitacion h ON h.NOMBRE = m.Hospedaje_Nombre
	WHERE m.Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL
		AND m.Venta_Nro_Venta IS NOT NULL
		AND m.Hospedaje_Nombre IS NOT NULL;
END;
GO

-- REVISAR
CREATE PROCEDURE migracion_detalle_venta_excursion
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.detalle_venta_excursion(
		DT_VENTA_EXC_COD_RESERVA, 
		COD_VENTA, 
		COD_EXCURSION, 
		DT_VENTA_EXCURSION_FECHA_RESERVA, 
		DT_VENTA_EXCURSION_CANT, 
		DT_VENTA_EXCURSION_PRECIO_UNITARIO, 
		DT_VENTA_EXCURSION_SUBTOTAL
	)
	SELECT DISTINCT 
		m.Detalle_Venta_Excursion_Cod_Reserva,
		v.NRO_VENTA,
		e.COD_EXCURSION,
		m.Detalle_Venta_Excursion_Fecha_Reserva, 
		m.Detalle_Venta_Excursion_Cant, 
		m.Detalle_Venta_Excursion_Precio_Unitario, 
		m.Detalle_Venta_Excursion_Subtotal
	FROM gd_esquema.Maestra m
		JOIN LOS_RELACIONALES.venta v ON v.NRO_VENTA = m.Venta_Nro_Venta
		JOIN LOS_RELACIONALES.excursion e ON e.NOMBRE = m.Excursion_Nombre
			AND e.HORARIO = m.Excursion_Horario
		-- AGREGAR JOINS SI SON NECESARIOS
	WHERE m.Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL;
END;
GO

CREATE PROCEDURE migracion_detalle_encuesta_puntaje
AS
BEGIN
	INSERT INTO LOS_RELACIONALES.detalle_encuesta_puntaje(
		COD_ENCUESTA, 
		COD_ASPECTO, 
		DT_ENCUESTA_PUNTAJE
	)
	SELECT DISTINCT
		e.CODIGO_ENCUESTA,
		a.ASPECTO_ID,
		m.Detalle_Encuesta_Puntaje
	FROM gd_esquema.Maestra	m
		JOIN LOS_RELACIONALES.encuesta e ON e.CODIGO_ENCUESTA = m.Encuesta_Codigo_Encuesta
		JOIN LOS_RELACIONALES.aspecto a ON a.ASPECTO = m.Aspecto_Aspecto 
	WHERE m.Encuesta_Codigo_Encuesta IS NOT NULL
		AND m.Aspecto_Aspecto IS NOT NULL;
END;
GO

-- MIGRAR DATOS (EJECUCIÓN STORE PROCEDURES) --

BEGIN TRANSACTION;

BEGIN TRY

	EXECUTE migracion_pais
	EXECUTE migracion_ciudad
	EXECUTE migracion_agencia
	EXECUTE migracion_cliente
	EXECUTE migracion_agente
	EXECUTE migracion_alianza
	EXECUTE migracion_aerolinea
	EXECUTE migracion_aeropuerto_salida
	EXECUTE migracion_aeropuerto_llegada
	EXECUTE migracion_proveedor
	EXECUTE migracion_hospedaje
	EXECUTE migracion_habitacion
	EXECUTE migracion_excursion
	EXECUTE migracion_estado_propuesta
	EXECUTE migracion_canal_venta
	EXECUTE migracion_medio_pago
	EXECUTE migracion_aspecto
	EXECUTE migracion_encuesta
	EXECUTE migracion_solicitud
	EXECUTE migracion_detalle_solicitud
	EXECUTE migracion_vuelo
	EXECUTE migracion_propuesta
	EXECUTE migracion_detalle_propuesta_vuelo
	EXECUTE migracion_detalle_propuesta_habitacion
	EXECUTE migracion_venta
	EXECUTE migracion_venta_propuesta
	EXECUTE migracion_detalle_venta_vuelo
	EXECUTE migracion_detalle_venta_hospedaje
	EXECUTE migracion_detalle_venta_excursion
	EXECUTE migracion_detalle_encuesta_puntaje

	COMMIT TRANSACTION;

	PRINT 'Migración realizada correctamente';

END TRY

BEGIN CATCH
	
	ROLLBACK TRANSACTION;

	PRINT 'Error al realizar migración';
	PRINT ERROR_NUMBER()
	PRINT ERROR_SEVERITY()
	PRINT ERROR_PROCEDURE()
	PRINT ERROR_LINE()
	PRINT ERROR_MESSAGE()

END CATCH;
GO