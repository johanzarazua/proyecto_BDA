--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 02/01/2022
--@Descripcion: MUeve una copia de control file a la FRA

conn sys/system as sysdba

-- Consultamos el valor de los control Files
show parameter control_files;

--Editar el parametro control file agregando el nombre del archivo de control creado en la FRA
alter system set 
  control_files = '/u01/app/oracle/oradata/HEZAPROY/disk_1/control01.ctl', '/u01/app/oracle/oradata/HEZAPROY/disk_2/control02.ctl', '/u01/app/oracle/oradata/HEZAPROY/disk_fra/control03.ctl'
  scope = spfile;
-- Configuracion original
-- alter system set 
--   control_files = '/u01/app/oracle/oradata/HEZAPROY/disk_1/control01.ctl','/u01/app/oracle/oradata/HEZAPROY/disk_2/control02.ctl','/u01/app/oracle/oradata/HEZAPROY/disk_3/control03.ctl'
--   scope = spfile;

-- Se detiene la instancia y se inicia en modo nomount
shutdown immediate
startup nomount

-- Utilizando rman para mover el control file
-- !echo "restore controlfile to '/u01/app/oracle/oradata/HEZAPROY/disk_fra/control03.ctl' from '/u01/app/oracle/oradata/HEZAPROY/disk_3/control03.ctl'; " | rman target /
!echo "restore controlfile from '/u01/app/oracle/oradata/HEZAPROY/disk_3/control03.ctl'; " | rman target /

!find /u01/app/oracle/oradata/HEZAPROY/ -type f -name control*


--detener la instancia y levantarla en modo normal 
shutdown immediate
startup

set linesisze window
col name for a60
select status, name, is_recovery_dest_file from v$controlfile;

select * from v$recovery_file_dest;

select * from v$recovery_file_dest;