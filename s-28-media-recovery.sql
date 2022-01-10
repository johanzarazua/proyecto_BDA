--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 26/12/2021
--@Descripcion: Creacion de tablespaces

sqlplus sys/system as sysdba

shutdown immediate
--Falla ts_usuario01.dbf
startup
/*
rman
list failure;
advise failure;
restore datafile 6;
recover datafile 6;
sql 'alter database datafile 6 online';
*/
