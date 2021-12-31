--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 26/12/2021
--@Descripcion: Creacion de usuarios y asigancion de privilegios

connect sys as sysdba

set serveroutput on;
whenever sqlerror exit rollback

Prompt Borrando usuarios y roles
declare 
  v_count_rol number;
  v_count_hezau number;
  v_count_hezab number;
begin
  select count(*) into v_count_rol from dba_roles where role = 'ROL_ADMIN_PROY';
  if v_count_rol > 0 then
    execute immediate 'drop role ROL_ADMIN_PROY';
  end if;

  select count(*) into v_count_hezab from all_users where username = 'HEZA_BIBLIOTECA';
  if v_count_hezab > 0 then
    execute immediate 'drop user HEZA_BIBLIOTECA cascade';
  end if;

  select count(*) into v_count_hezau from all_users where username = 'HEZA_USUARIO';
  if v_count_hezau > 0 then
    execute immediate 'drop user HEZA_USUARIO cascade';
  end if;
exception
  when others then
    dbms_output.put_line('ERROR, se obtuvo excepción  no esperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/

Prompt Creando rol para los usuarios
-- Rol de privilegios
create role rol_admin_proy;
grant create session, create table, create sequence, create synonym,
  create public synonym, create view, create procedure,
  create trigger to rol_admin_proy;

Prompt Creando usuario para modulo usuario
-- Usuario para el modulo usuario
create user heza_usuario identified by hezau default tablespace ts_usuario
  quota unlimited on ts_usuario
  quota unlimited on ts_usuario_index
  quota unlimited on ts_lob;

Prompt Creando usuario para modulo biblioteca
-- Usuario para modulo biblioteca
create user heza_biblioteca identified by hezab default tablespace ts_biblioteca
  quota unlimited on ts_biblioteca
  quota unlimited on ts_biblioteca_index
  quota unlimited on ts_lob;

Prompt Asignando rol a usuarios
grant rol_admin_proy to heza_usuario, heza_biblioteca;

Prompt Listo !!!
disconnect