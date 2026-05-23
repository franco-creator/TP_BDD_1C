# Requerimientos del TP

## General

El alumno deberá primero, diseñar el nuevo modelo de datos, crear todos los componentes de base de datos y realizar la migración de datos. Luego deberá implementar un modelo de Inteligencia de Negocios que le permita obtener información puntual para un tablero de control.

## Modelo Transaccional del Sistema

El alumno deberá diseñar el modelo de datos correspondiente y desarrollar un script de base de datos SQL Server que realice la creación de su modelo de datos transaccional y la migración de los datos de la tabla maestra a su propio modelo.

### Base de Datos

El alumno deberá crear un modelo de datos que **<u>organice y normalice</u>** los datos de la única tabla provista por la cátedra.

Se debe incluir:

* **Creación de nuevas tablas.**
* **Creación de claves primarias y foráneas** para relacionar estas tablas.
* **Creación de constraints y triggers** sobre estas tablas cuando fuese necesario.
* **Creación de los índices** para acceder a los datos de estas tablas de manera eficiente.
* **Migración de datos:** Se deberán cargar todas las tablas creadas en el nuevo modelo utilizando la totalidad de los datos entregados por la cátedra en la única tabla del modelo anterior. Para realizar este punto deberán utilizarse Stored Procedures.
* **Creación de su propio esquema** con el nombre del grupo elegido

El alumno deberá entregar el DER del modelo transaccional y un único archivo de Script que al ejecutar realice todos los pasos mencionados anteriormente, en el orden correcto. Todo el modelo de datos confeccionado por el alumno deberá ser creado y cargado correctamente ejecutando este Script una única vez.


## Consideraciones

Todas las columnas creadas para las nuevas tablas **<u>deberán respetar los mismos tipos de datos</u>** de las columnas existentes en la tabla principal. A su vez el alumno podrá crear nuevas columnas, claves e identificadores para satisfacer sus necesidades. Pero nunca se podrá inventar información, por ejemplo, crear una sucursal o una venta que nunca existió.

Tener en cuenta que DEBEN crear su **propio esquema** con el nombre de su grupo, esto permite que tengan su espacio propio de resolución y no se mezclen y/o utilicen la solución de otro grupo o la propia que tenemos para corrección del trabajo práctico

## A hacer ahora 

### Entrega de Modelo de Datos Relacional y Migración

En esta entrega se deberán enviar:
* El script de creación y migración de datos (un único script) del modelo relacional según el formato especificado en la sección de formato de entrega del presente documento