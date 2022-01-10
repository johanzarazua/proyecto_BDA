--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 01/01/2022
--@Descripcion: Configuracion de paramtros para habilitar la FRA

whenever  sqlerror exit rollback;

conn sys/system as sysdba

-- Parametros FRA
alter system set db_recovery_file_dest_size = 1600M;
alter system set db_recovery_file_dest = '/u01/app/oracle/oradata/HEZAPROY/disk_fra';
alter system set db_flashback_retention_target = 1600;

-- Copias de redologs dentro de la FRA
alter system set log_archive_dest_2 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST';