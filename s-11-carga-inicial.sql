--@Autor:           Hernández Gómez Alejandro, Zarazúa Ramírez Johan
--@Fecha creación:  30/12/2021
--@Descripción:     Carga incial de datos

whenever  sqlerror exit rollback

Prompt conectando con usuario sys
connect sys/system as sysdba

Prompt Desactivando el modo archivelog
shutdown immediate
startup mount
alter database noarchivelog;
alter database open;

Prompt Ejecutando scripts con datos
@@s-12-carga-datos-biblioteca.sql
@@s-13-carga-datos-usuario.sql

Prompt Caraga inicial lista, activando archivelog
shutdown immediate
startup mount
alter database archivelog;
alter database open;

Prompt Listo !!!
disconnect