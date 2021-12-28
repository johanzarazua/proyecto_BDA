--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 26/12/2021
--@Descripcion: Creacion de usuarios y asigancion de privilegios

connect sys as sysdba

-- Rol de privilegios
create role rol_admin_proy;
grant create session, create table, create sequence, create synonym,
  create public synonym, create view, create procedure,
  create trigger to rol_admin_proy;

-- Usuario para el modulo usuario
create user heza_usaurio identified by hezau default tablespace ts_usuario
  quota unlimited on ts_usuario
  quota unlimited on ts_usuario_index
  quota unlimited on ts_lob;

-- Usuario para modulo biblioteca
create user heza_biblioteca identified by hezab default tablespace ts_biblioteca
  quota unlimited on ts_biblioteca
  quota unlimited on ts_biblioteca_index
  quota unlimited on ts_lob;

grant rol_admin_proy to heza_usaurio, heza_biblioteca;