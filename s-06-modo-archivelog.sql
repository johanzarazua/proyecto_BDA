--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 29/12/2021
--@Descripcion: Modo archivelog

whenever sqlerror exit rollback;

--Autenticación con el usuario sys 
connect sys/system as sysdba

--Respaldo del archivo de parámetros
create pfile='/u01/app/oracle/oradata/HEZAPROY/disk_1/respaldosSpfile/pf-01-spparameter-pfile.txt' from spfile;

--Configuración de parámetros
alter system set log_archive_max_processes = 5 scope = spfile;

alter system set log_archive_dest_1 = 'LOCATION=/u01/app/oracle/oradata/HEZAPROY/disk_1/archivelogs/disk_a MANDATORY' scope = spfile;
--alter system set log_archive_dest_2 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST' scope = spfile;

alter system set log_archive_format = 'arch_hezaproy_%t_%s_%r.arc' scope = spfile;

alter system set log_archive_min_succeed_dest = 1 scope = spfile;

--Habilitación del modo archivelog
shutdown immediate
startup mount

alter database archivelog;

--Comprobación del modo archivelog
alter database open;
archive log list

--Segundo respaldo del archivo de parámetros
create pfile='/u01/app/oracle/oradata/HEZAPROY/disk_1/respaldosSpfile/pf-02-spparameter-pfile.txt' from spfile;
