-- CONSULTAS

-- Tabla Maestra
SELECT * FROM gd_esquema.Maestra

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'LOS_RELACIONALES'

-- Pais
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
WHERE Hospedaje_Pais IS NOT NULL

SELECT * FROM LOS_RELACIONALES.pais

-- Ciudad
SELECT Aeropuerto_Salida_Ciudad
FROM gd_esquema.Maestra
WHERE Aeropuerto_Salida_Ciudad IS NOT NULL
	UNION
SELECT Aeropuerto_Llegada_Ciudad
FROM gd_esquema.Maestra
WHERE Aeropuerto_Llegada_Ciudad IS NOT NULL
	UNION
SELECT Detalle_Solicitud_Ciudad
FROM gd_esquema.Maestra
WHERE Detalle_Solicitud_Ciudad IS NOT NULL
	UNION
SELECT Hospedaje_Ciudad
FROM gd_esquema.Maestra
WHERE Hospedaje_Ciudad IS NOT NULL

SELECT * FROM LOS_RELACIONALES.ciudad

-- Agencia
SELECT DISTINCT 
	Agencia_Nro_Agencia, 
	Agencia_Direccion, 
	Agencia_Telefono, 
	Agencia_Mail, 
	Agencia_Localidad, 
	Agencia_Provincia
FROM gd_esquema.Maestra
WHERE Agencia_Nro_Agencia IS NOT NULL

SELECT * FROM LOS_RELACIONALES.agencia

-- Cliente
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
WHERE Cliente_Dni IS NOT NULL

SELECT * FROM LOS_RELACIONALES.cliente

-- Agente
SELECT DISTINCT
	Agente_Legajo, 
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

SELECT * FROM LOS_RELACIONALES.agente

-- Alianza
SELECT DISTINCT Aerolinea_Alianza
FROM gd_esquema.Maestra
WHERE Aerolinea_Alianza IS NOT NULL

SELECT * FROM LOS_RELACIONALES.alianza

-- Aerolinea
SELECT DISTINCT
	Aerolinea_Codigo,
	Aerolinea_Alianza,
	Aerolinea_Nombre, 
	Aerolinea_Pais
FROM gd_esquema.Maestra
WHERE Aerolinea_Codigo IS NOT NULL

SELECT * FROM LOS_RELACIONALES.aerolinea

-- Aeropuerto Salida
SELECT DISTINCT
	Aeropuerto_Salida_Codigo,
	Aeropuerto_Salida_Descripcion, 
	Aeropuerto_Salida_Ciudad, 
	Aeropuerto_Salida_Pais
FROM gd_esquema.Maestra	
WHERE Aeropuerto_Salida_Codigo IS NOT NULL

SELECT * FROM LOS_RELACIONALES.aeropuerto_salida

--Aeropuerto Llegada
SELECT DISTINCT
	Aeropuerto_Llegada_Codigo,
	Aeropuerto_Llegada_Descripcion, 
	Aeropuerto_Llegada_Ciudad, 
	Aeropuerto_Llegada_Pais
FROM gd_esquema.Maestra	
WHERE Aeropuerto_Llegada_Codigo IS NOT NULL

SELECT * FROM LOS_RELACIONALES.aeropuerto_llegada

-- Vuelo
SELECT DISTINCT
	Vuelo_Duracion,
	Vuelo_Fecha_Llegada,
	Vuelo_Fecha_Salida,
	Vuelo_Horario_Llegada,
	Vuelo_Horario_Salida,
	Vuelo_Incluye_Carry,
	Vuelo_Incluye_Valija,
	Vuelo_Precio
FROM gd_esquema.Maestra
WHERE Vuelo_Fecha_Llegada IS NOT NULL

SELECT * FROM LOS_RELACIONALES.vuelo

-- Hospedaje
SELECT DISTINCT
	Hospedaje_Ciudad,
	Hospedaje_Pais,
	Hospedaje_Nombre,
	Hospedaje_Direccion, 
	Hospedaje_Incluye_Desayuno, 
	Hospedaje_Check_In, 
	Hospedaje_Check_Out
FROM gd_esquema.Maestra
WHERE Hospedaje_Ciudad IS NOT NULL

SELECT * FROM LOS_RELACIONALES.hospedaje

-- Habitacion
SELECT DISTINCT 
	Habitacion_Nombre, 
	Habitacion_Descripcion, 
	Habitacion_Precio_Noche 
FROM gd_esquema.Maestra
WHERE Habitacion_Nombre IS NOT NULL

SELECT * FROM LOS_RELACIONALES.habitacion

-- Excursion
SELECT DISTINCT
	Excursion_Nombre, 
	Excursion_Descripcion, 
	Excursion_Horario, 
	Excursion_Duracion, 
	Excursion_Precio
FROM gd_esquema.Maestra
WHERE Excursion_Nombre IS NOT NULL

SELECT * FROM LOS_RELACIONALES.excursion

-- Proveedor
SELECT DISTINCT
	Proveedor_Nombre, 
	Proveedor_Mail, 
	Proveedor_Telefono
FROM gd_esquema.Maestra
WHERE Proveedor_Nombre IS NOT NULL

SELECT * FROM LOS_RELACIONALES.proveedor

-- Canal de venta
SELECT DISTINCT
	Venta_Canal_Venta
FROM gd_esquema.Maestra
WHERE Venta_Canal_Venta IS NOT NULL

SELECT * FROM LOS_RELACIONALES.canal_venta

-- Medio de pago
SELECT DISTINCT
	Venta_Medio_Pago
FROM gd_esquema.Maestra
WHERE Venta_Medio_Pago IS NOT NULL

SELECT * FROM LOS_RELACIONALES.medio_pago

-- Aspecto
SELECT DISTINCT
	Aspecto_Aspecto
FROM gd_esquema.Maestra
WHERE Aspecto_Aspecto IS NOT NULL

SELECT * FROM LOS_RELACIONALES.aspecto

-- Encuesta
SELECT DISTINCT
	Encuesta_Codigo_Encuesta,
	Encuesta_Fecha_Encuesta,
    Encuesta_Comentarios
FROM gd_esquema.Maestra 
WHERE Encuesta_Codigo_Encuesta IS NOT NULL

SELECT * FROM LOS_RELACIONALES.encuesta

-- Detalle Encuesta Puntaje
SELECT DISTINCT
	Detalle_Encuesta_Puntaje
FROM gd_esquema.Maestra
WHERE Detalle_Encuesta_Puntaje IS NOT NULL

SELECT * FROM LOS_RELACIONALES.detalle_encuesta_puntaje

-- Solicitud
SELECT DISTINCT 
	Solicitud_Nro_Solicitud,  
	Solicitud_Fecha_Solicitud, 
	Solicitud_Fecha_Inicio_Tentativa, 
	Solicitud_Fecha_Fin_Tentativa, 
	Solicitud_Cant_Pax, 
	Solicitud_Observaciones, 
	Solicitud_Presupuesto_Estimado
FROM gd_esquema.Maestra	
WHERE Solicitud_Nro_Solicitud IS NOT NULL

SELECT * FROM LOS_RELACIONALES.solicitud

-- Detalle Solicitud
SELECT DISTINCT
	Detalle_Solicitud_Ciudad,
	Detalle_Solicitud_Cant_Dias_Aprox, 
	Detalle_Solicitud_Observaciones
FROM gd_esquema.Maestra
WHERE Detalle_Solicitud_Ciudad IS NOT NULL
	AND Detalle_Solicitud_Cant_Dias_Aprox IS NOT NULL
	AND Detalle_Solicitud_Observaciones IS NOT NULL

SELECT * FROM LOS_RELACIONALES.detalle_solicitud

-- Propuesta
SELECT DISTINCT
	Propuesta_Nro_Propuesta,
	Propuesta_Fecha_Emision, 
	Propuesta_Vigencia_Hasta, 
	Propuesta_Fecha_Desde, 
	Propuesta_Fecha_Hasta, 
	Propuesta_Subtotal, 
	Propuesta_Descuento, 
	Propuesta_Importe_Total
FROM gd_esquema.Maestra 
WHERE Propuesta_Nro_Propuesta IS NOT NULL

SELECT * FROM LOS_RELACIONALES.propuesta

-- Estado Propuesta
SELECT DISTINCT
	Propuesta_Estado
FROM gd_esquema.Maestra
WHERE Propuesta_Estado IS NOT NULL

-- Detalle Propuesta Vuelo
SELECT DISTINCT
	Detalle_Propuesta_Vuelo_Cant_Pasajes,
	Detalle_Propuesta_Vuelo_Precio,
	Detalle_Propuesta_Vuelo_Subtotal
FROM gd_esquema.Maestra
WHERE Detalle_Propuesta_Vuelo_Cant_Pasajes IS NOT NULL

SELECT * FROM LOS_RELACIONALES.estado_propuesta

-- Detalle Propuesta Habitacion
SELECT DISTINCT
	Detalle_Propuesta_Hospedaje_Cant,
	Detalle_Propuesta_Hospedaje_Fecha_Desde,
	Detalle_Propuesta_Hospedaje_Fecha_Hasta,
	Detalle_Propuesta_Hospedaje_Precio,
	Detalle_Propuesta_Hospedaje_Subtotal
FROM gd_esquema.Maestra
WHERE Detalle_Propuesta_Hospedaje_Cant IS NOT NULL

SELECT * FROM LOS_RELACIONALES.detalle_propuesta_habitacion

-- Venta
SELECT DISTINCT
		Venta_Nro_Venta,
		Venta_Canal_Venta,
		Venta_Medio_Pago,
		Venta_Fecha_Venta, 
		Venta_Subtotal, 
		Venta_Descuento, 
		Venta_Importe_Total
FROM gd_esquema.Maestra	
WHERE Venta_Nro_Venta IS NOT NULL

SELECT * FROM LOS_RELACIONALES.venta

-- Venta Propuesta (REVISAR)
SELECT 
	Venta_Nro_Venta, 
	Propuesta_Nro_Propuesta 
FROM gd_esquema.Maestra
WHERE Venta_Nro_Venta IS NOT NULL
	OR Propuesta_Nro_Propuesta IS NOT NULL

	SELECT * FROM LOS_RELACIONALES.venta_propuesta

-- Detalle Venta Vuelo
SELECT DISTINCT
	Detalle_Venta_Vuelo_Cod_Reserva,
	Detalle_Venta_Vuelo_Cantidad_Pasajes,
	Detalle_Venta_Vuelo_Precio_Unitario,
	Detalle_Venta_Vuelo_Subtotal
FROM gd_esquema.Maestra
WHERE Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL

SELECT * FROM LOS_RELACIONALES.detalle_venta_vuelo

-- Detalle Venta Habitacion
SELECT DISTINCT
	Detalle_Venta_Hospedaje_Cod_Reserva,
	Detalle_Venta_Hospedaje_Cantidad,
	Detalle_Venta_Hospedaje_Fecha_Desde,
	Detalle_Venta_Hospedaje_Fecha_Hasta,
	Detalle_Venta_Hospedaje_Precio_Unitario,
	Detalle_Venta_Hospedaje_Subtotal
FROM gd_esquema.Maestra
WHERE Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL

SELECT * FROM LOS_RELACIONALES.detalle_venta_habitacion

-- Detalle Venta Excursion

SELECT DISTINCT
	Detalle_Venta_Excursion_Cod_Reserva,
	Detalle_Venta_Excursion_Cant,
	Detalle_Venta_Excursion_Fecha_Reserva,
	Detalle_Venta_Excursion_Precio_Unitario,
	Detalle_Venta_Excursion_Subtotal
FROM gd_esquema.Maestra
WHERE Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL

SELECT * FROM LOS_RELACIONALES.detalle_venta_excursion