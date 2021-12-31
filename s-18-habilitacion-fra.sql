--@Autor Hernández Gómez Alejandro, Zarazúa Ramírez Johan
--@Fecha 31/12/2021
--@Descripcion Habilitación FRA

whenever sqlerror exit rollback;

--Autenticación con el usuario sys 
connect sys/system as sysdba

alter system set db_recovery_file_dest_size = 1362M scope = both;
alter system set db_recovery_file_dest = '/u01/app/oracle/oradata/HEZAPROY/disk_1' scope = both;
alter system set db_flashback_retention_target = 1440 scope = both;

--rman> configure controlfile autobackup format for device type disk clear
alter system set log_archive_dest_2 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST' scope = spfile;
