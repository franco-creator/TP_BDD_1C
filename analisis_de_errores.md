# Reporte de Auditoría y Análisis de Errores
**Trabajo Práctico: Modelo de Datos Relacional y Migración**  
**Esquema:** `LOS_RELACIONALES`  
**Base de Datos de Origen:** `GD1C2026.gd_esquema.Maestra`

Este documento detalla cada uno de los errores críticos, fallos de normalización y requerimientos faltantes identificados al contrastar el script de creación inicial (`script_creacion_inicial(v0.3).sql`) con la estructura real de la tabla maestra en el motor SQL Server.

---

## A. Errores Críticos (Bugs que rompen la ejecución o la integridad)

### 1. Ausencia de `COMMIT TRANSACTION`
* **Ubicación:** Bloque de ejecución final (Líneas 1055-1092).
* **Descripción:** El script abre una transacción con `BEGIN TRANSACTION` y ejecuta todos los Stored Procedures dentro de un bloque `TRY/CATCH`. Sin embargo, en caso de éxito, **no se ejecuta ningún `COMMIT`**.
* **Consecuencia:** La migración se procesa en memoria temporal, pero los cambios nunca se confirman. La transacción queda abierta en la sesión de SQL Server, bloqueando las tablas para otros usuarios. Si se cierra la conexión, se realiza un `ROLLBACK` automático y se pierden todos los datos migrados.
* **Solución:** Agregar `COMMIT TRANSACTION` al final del bloque `TRY`.

### 2. Conflicto de Tipos de Datos (FK vs PK) en `vuelo`
* **Ubicación:** Tabla `vuelo` (Línea 143) vs Tabla `aerolinea` (Línea 118).
* **Descripción:** En la tabla `aerolinea`, la clave primaria se define como:
  ```sql
  COD_AEROLINEA nvarchar(255) PRIMARY KEY
  ```
  Pero en la tabla `vuelo`, la clave foránea se define como:
  ```sql
  COD_AEROLINEA bigint REFERENCES LOS_RELACIONALES.aerolinea(COD_AEROLINEA)
  ```
* **Consecuencia:** SQL Server no permite crear una FK que apunte a una PK de tipo de dato diferente (`bigint` vs `nvarchar(255)`). La creación de la tabla `vuelo` fallará inmediatamente al ejecutar el script.
* **Solución:** Cambiar el tipo de dato de `vuelo.COD_AEROLINEA` a `nvarchar(255)`.

### 3. Inserción incorrecta de datos en `migracion_aerolinea`
* **Ubicación:** Stored Procedure `migracion_aerolinea` (Líneas 434-454).
* **Descripción:** La columna `ALIANZA` en la tabla `aerolinea` está definida como `bigint` (referenciando a `alianza.ALIANZA_ID`). Sin embargo, en el `SELECT` del procedimiento de migración se escribe:
  ```sql
  INSERT INTO LOS_RELACIONALES.aerolinea(COD_AEROLINEA, ALIANZA, ...)
  SELECT DISTINCT m.Aerolinea_Codigo, a.ALIANZA, ...
  ```
  Donde `a.ALIANZA` es la columna de texto (`nvarchar(255)`) que contiene el nombre de la alianza (ej. "Star Alliance"), no el ID numérico.
* **Consecuencia:** Error de conversión de tipo de datos en tiempo de ejecución al intentar insertar una cadena de texto en un campo `bigint`.
* **Solución:** Cambiar `a.ALIANZA` por `a.ALIANZA_ID` en la lista del `SELECT`.

### 4. Violación de Clave Primaria en `migracion_agente`
* **Ubicación:** Stored Procedure `migracion_agente` (Líneas 384-416).
* **Descripción:** La clave primaria de `agente` es `LEGAJO` (numérico). El SP utiliza `SELECT DISTINCT Agente_Legajo, ...`. Si un agente tiene múltiples filas en `Maestra` con variaciones menores en su dirección, teléfono o email, el `SELECT DISTINCT` devolverá múltiples filas con el mismo `Agente_Legajo` pero diferentes datos secundarios.
* **Consecuencia:** El motor de SQL Server arrojará un error de violación de clave primaria (registros duplicados para `LEGAJO`) y abortará la transacción completa.
* **Solución:** Garantizar la unicidad por legajo utilizando una consulta agrupada (`GROUP BY Agente_Legajo` con funciones de agregación como `MAX`) o una CTE con `ROW_NUMBER() OVER (PARTITION BY Agente_Legajo ORDER BY ...)`.

### 5. Duplicidad lógica de Clientes por `SELECT DISTINCT`
* **Ubicación:** Stored Procedure `migracion_cliente` (Líneas 355-382).
* **Descripción:** Similar al caso del agente. Si un cliente con el mismo DNI aparece en la tabla maestra con teléfonos o mails distintos registrados en diferentes transacciones, `SELECT DISTINCT` insertará múltiples filas para la misma persona física.
* **Consecuencia:** Se le asignarán múltiples identificadores auto-incrementales (`CLIENTE_ID`) al mismo cliente, fragmentando su historial de compras y solicitudes, violando el propósito de normalización.
* **Solución:** Filtrar y agrupar por `Cliente_Dni` para migrar un único registro representativo por cliente.

---

## B. Errores de Diseño y Normalización (Violaciones a las Reglas Relacionales)

### 1. La columna "Fantasma" `COD_CIUDAD` en `excursion`
* **Ubicación:** Tabla `excursion` (Línea 184) y su SP (Líneas 580-606).
* **Descripción:** El compañero definió `COD_CIUDAD` en `excursion`. Sin embargo, al examinar la tabla maestra real, **no existe ninguna columna de ciudad o país vinculada a las excursiones**. Al no encontrar de dónde migrar el dato, el compañero simplemente comentó las líneas del SP de migración:
  ```sql
  --COD_CIUDAD,
  ...
  -- JOIN LOS_RELACIONALES.ciudad c ON c.NOMBRE = m.Excursion_Ciudad
  ```
* **Consecuencia:** La columna queda en la base de datos pero siempre con valor `NULL`. Además, demuestra que se intentó modelar algo que el origen de datos no permite sustentar.
* **Solución:** Eliminar la columna `COD_CIUDAD` de la tabla `excursion` para ser fieles a la información provista por la cátedra.

### 2. Redundancia de País y Ciudad (Violación de la Tercera Forma Normal - 3NF)
* **Ubicaciones:** 
  * Tabla `hospedaje` (Línea 156): Contiene `PAIS nvarchar(255)` a pesar de que ya referencia a `COD_CIUDAD` (el cual ya está vinculado a `pais`).
  * Tablas `aeropuerto_salida` (Línea 125) y `aeropuerto_llegada` (Línea 133): Contienen columnas para guardar los nombres de las ciudades y países como texto, a pesar de que ya tienen la FK `COD_CIUDAD`.
* **Consecuencia:** Duplicidad innecesaria de datos (redundancia). Si se actualiza el nombre de una ciudad o país en su tabla maestra de ciudades/países, los nombres guardados como texto en hospedajes o aeropuertos quedarán desactualizados (anomalía de actualización).
* **Solución:** Eliminar los campos de texto redundantes de ciudades y países en `hospedaje` y en los aeropuertos. Obtener esta información siempre mediante `JOIN`.

### 3. Duplicación de la Entidad Aeropuerto
* **Ubicación:** Tablas `aeropuerto_salida` y `aeropuerto_llegada`.
* **Descripción:** Se crearon dos tablas estructural y lógicamente idénticas para separar aeropuertos de salida y llegada. En el mundo real (y relacional), un aeropuerto (ej. JFK) es un único registro que funciona tanto para salidas como para llegadas.
* **Consecuencia:** Desperdicio de almacenamiento, dificultad para mantener datos de aeropuertos consistentes y mala práctica de diseño relacional.
* **Solución:** Fusionar ambas tablas en una única tabla llamada `aeropuerto` (con `AER_CODIGO` como PK). Luego, en la tabla `vuelo`, declarar dos claves foráneas (`COD_AEROPUERTO_SALIDA` y `COD_AEROPUERTO_LLEGADA`) que apunten a la misma tabla `aeropuerto`.

### 4. Falta de Claves Primarias (PK) en Tablas de Detalle y Unión
* **Ubicaciones:**
  * `detalle_solicitud` (Línea 70)
  * `detalle_encuesta_puntaje` (Línea 93)
  * `venta_propuesta` (Línea 235)
* **Descripción:** Estas tablas fueron creadas sin ninguna Clave Primaria que identifique de forma unívoca a cada registro.
* **Consecuencia:** Permite la inserción de filas exactamente idénticas (duplicados completos), violando la teoría relacional y los estándares mínimos de calidad de base de datos.
* **Solución:** Definir claves primarias compuestas basadas en sus claves foráneas:
  * En `detalle_solicitud`: `PRIMARY KEY (COD_SOLICITUD, COD_CIUDAD)`
  * En `detalle_encuesta_puntaje`: `PRIMARY KEY (COD_ENCUESTA, COD_ASPECTO)`
  * En `venta_propuesta`: `PRIMARY KEY (COD_VENTA, COD_PROPUESTA)`

---

## C. Requerimientos Faltantes de la Cátedra (No Implementados)

### 1. Ausencia Total de Índices Personalizados
* **Descripción:** El enunciado del TP exige expresamente la *"Creación de los índices para acceder a los datos de estas tablas de manera eficiente"*. 
* **Faltante:** El script no tiene una sola sentencia `CREATE INDEX`. Únicamente se crean los índices automáticos por defecto de las claves primarias (índices agrupados).
* **Solución:** Diseñar e implementar índices no agrupados (`CREATE NONCLUSTERED INDEX`) en las columnas de mayor consulta y filtrado en los stored procedures (por ejemplo: `cliente(DNI)`, `venta(FECHA_VENTA)`, `vuelo(FECHA_SALIDA)`).

### 2. Ausencia de Restricciones (Constraints) de Validación y Negocio
* **Descripción:** Se requiere incorporar restricciones de base de datos para asegurar la consistencia.
* **Faltante:** No hay restricciones `CHECK` que impidan precios negativos, fechas de fin anteriores a las de inicio, o carry-on/valijas con valores inválidos. Tampoco hay valores por defecto (`DEFAULT`).
* **Solución:** Incorporar `CHECK` constraints en campos clave:
  * `PRECIO >= 0` en habitaciones, vuelos y excursiones.
  * `FECHA_FIN_TENTATIVA >= FECHA_INICIO_TENTATIVA` en solicitudes.
  * `FECHA_HASTA >= FECHA_DESDE` en propuestas y ventas de hospedaje.

### 3. Falta de Idempotencia y Limpieza (Drop Scripts)
* **Descripción:** El script debe poder ejecutarse múltiples veces consecutivas de forma limpia para pruebas.
* **Faltante:** Si se ejecuta el script actual una segunda vez, fallará inmediatamente porque el esquema `LOS_RELACIONALES` y las tablas ya existen.
* **Solución:** Añadir un bloque condicional de `DROP` al inicio del script que elimine de manera segura el esquema, los stored procedures, las vistas y las tablas en el orden correcto de dependencias (claves foráneas primero).
