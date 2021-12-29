--@Autor:           Hernández Gómez Alejandro, Zarazúa Ramírez Johan
--@Fecha creación:  29/12/2021
--@Descripción:     Carga de datos biblioteca

--si ocurre un error, se hace rollback de los datos y
--se sale de SQL *Plus
whenever  sqlerror exit rollback

Prompt conectando usuario heza_biblioteca
connect heza_biblioteca@HEZAPROY

set define off

Prompt realizando la carga de datos
@@datos_iniciales/biblioteca.sql
@@datos_iniciales/area_conocimiento.sql
@@datos_iniciales/status_recurso.sql
@@datos_iniciales/recurso.sql
@@datos_iniciales/historico_status_recurso.sql
@@datos_iniciales/palabra_clave.sql
@@datos_iniciales/autor.sql
@@datos_iniciales/editorial.sql
@@datos_iniciales/libro.sql
@@datos_iniciales/revista.sql
@@datos_iniciales/tesis.sql
@@datos_iniciales/lista_area_c.sql
@@datos_iniciales/autor_libro.sql



set define on

Prompt confirmando cambios
commit;

--Si se encuentra un error, no se sale de SQL *Plus
--no se hace commit ni rollback, es decir, se
--regresa al estado original.
whenever sqlerror continue none

Prompt Listo!