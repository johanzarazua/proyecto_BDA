--@Autor:           Hernández Gómez Alejandro, Zarazúa Ramírez Johan
--@Fecha creación:  29/12/2021
--@Descripción:     Carga de datos biblioteca

--si ocurre un error, se hace rollback de los datos y
--se sale de SQL *Plus
whenever  sqlerror exit rollback

Prompt conectando usuario sys
connect sys/system as sysdba

set define off

Prompt realizando la carga de datos
@biblioteca.sql
@area_conocimiento.sql
@lista_area_c.sql
@status_recurso.sql
@historico_status_recurso.sql
@palabra_clave.sql
@autor.sql
@editorial.sql
@recurso.sql
@libro.sql
@revista.sql
@tesis.sql
@autor_libro.sql



set define on

Prompt confirmando cambios
commit;

--Si se encuentra un error, no se sale de SQL *Plus
--no se hace commit ni rollback, es decir, se
--regresa al estado original.
whenever sqlerror continue none

Prompt Listo!