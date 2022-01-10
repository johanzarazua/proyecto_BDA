--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 26/12/2021
--@Descripcion: Creacion de tablespaces

connect sys@hezaproy as sysdba

set serveroutput on;
whenever sqlerror exit rollback

Prompt Borrando tablespaces
declare
  cursor cur_constraits is 
    Select OWNER, CONSTRAINT_NAME, TABLE_NAME, CONSTRAINT_TYPE from DBA_CONSTRAINTS 
      where owner like 'HEZA_%' and CONSTRAINT_TYPE <> 'C';

  cursor cur_ts is 
    select tablespace_name from dba_tablespaces where tablespace_name like 'TS_%'
      order by 1 desc;

begin
  for r in cur_constraits loop
    DBMS_OUTPUT.PUT_LINE('Eliminando Constrait => ' || r.constraint_name);
    execute immediate 'alter table ' || r.owner ||'.'||r.table_name 
      || ' drop constraint ' || r.constraint_name;
  end loop;

  for r in cur_ts loop
    DBMS_OUTPUT.PUT_LINE('Eliminando TS => ' || r.tablespace_name);
    execute immediate 'drop tablespace ' || r.tablespace_name 
      || ' including contents and datafiles';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, se obtuvo excepción  no esperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/
-- Tablespace comun para almacenar fotografias y PDFs
Prompt Crenado tablespace para datos blob
create bigfile tablespace ts_lob
  datafile '/u01/app/oracle/oradata/HEZAPROY/disk_1/ts_blob01.dbf' size 3G
  extent management local autoallocate
  segment space management auto;

Prompt Crenado tablespaces para modulo usuario
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

Prompt Crenado tablespaces para modulo biblioteca
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

Prompt Listo !!!
disconnect