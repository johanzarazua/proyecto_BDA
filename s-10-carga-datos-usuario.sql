--@Autor:           Hernández Gómez Alejandro, Zarazúa ramírez Johan
--@Fecha creación:  29/12/2021
--@Descripción:     Carga de datos usuario

--si ocurre un error, se hace rollback de los datos y
--se sale de SQL *Plus
whenever  sqlerror exit rollback

Prompt conectando usuario heza_usuario
connect heza_usuario/hezau@HEZAPROY

set define off

Prompt realizando la carga de datos
@datos_iniciales/usuario.sql
@datos_iniciales/prestamo.sql
@datos_iniciales/libro_prestamo.sql

set define on

Prompt confirmando cambios
commit;

--Si se encuentra un error, no se sale de SQL *Plus
--no se hace commit ni rollback, es decir, se
--regresa al estado original.
whenever sqlerror continue none

Prompt Listo!