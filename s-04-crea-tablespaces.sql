--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 26/12/2021
--@Descripcion: Creacion de tablespaces

connect sys as sysdba

-- Tablespace comun para almacenar fotografias y PDFs
create bigfile tablespace ts_lob
  datafile '/u01/app/oracle/oradata/HEZAPROY/disk_1/ts_blob01.dbf' size 3G
  extent management local autoallocate
  segment space management auto;

-- Tablespace para modulo usuarios
create tablespace ts_usuario
  datafile '/u01/app/oracle/oradata/HEZAPROY/disk_2/ts_usuario01.dbf' size 250M
    autoextend on next 50M maxsize 500M
  extent management local autoallocate
  segment space management auto;

create tablespace ts_usuario_index
  datafile '/u01/app/oracle/oradata/HEZAPROY/disk_2/ts_usuario_index01.dbf'
    size 100M autoextend on next 50M maxsize 300M
  extent management local autoallocate
  segment space management auto;

-- Tablespace para modulo biblioteca
create bigfile tablespace ts_biblioteca
  datafile '/u01/app/oracle/oradata/HEZAPROY/disk_3/ts_biblioteca01.dbf'
    size 500M autoextend on next 100M maxsize 3G
  extent management local autoallocate
  segment space management auto;

create tablespace ts_biblioteca_index
  datafile '/u01/app/oracle/oradata/HEZAPROY/disk_3/ts_biblioteca_index01.dbf'
    size 100M autoextend on next 50M maxsize 500m
  extent management local autoallocate
  segment space management auto;
