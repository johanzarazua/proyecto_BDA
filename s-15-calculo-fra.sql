--@Autor Hernández Gómez Alejandro, Zarazúa Ramírez Johan
--@Fecha 30/12/2021
--@Descripcion Cálculo FRA

whenever sqlerror exit rollback;

--Autenticación con el usuario sys 
connect sys/system as sysdba

--Configuración inicial backups
/*
su -l oracle
export ORACLE_SID=hezaproy
rman
rman> connect target "sys/system@hezaproy as sysdba"

rman> configure channel device type disk
format '/u01/app/oracle/oradata/HEZAPROY/disk_1/backups/backup_%U.bkp' maxpiecesize 2G;

*/


--Full Backup
/*
rman> backup database plus archivelog
tag bibliotecas_full_inicial;

list backup;

delete obsolete;
*/

--Consulta de datos backup
select session_key, bs_key, set_count, handle, tag 
from v$backup_piece_details 
order by bs_key;

select session_key, bs_key, status, start_time, completion_time,
  trunc(elapsed_seconds, 0) elapsed_seconds, deleted, size_bytes_display
from v$backup_piece_details 
order by bs_key;

--Ejecutar carga diaria

--backup nivel 0
/*
rman> backup as backupset incremental level 0 database plus archivelog
tag bibliotecas_backup_nivel_0_1;

list backup;

delete obsolete;

DF-47: 681.09 Mb
AL-48: 45.50 Kb
CF-49: 17.83 Mb
*/

--Ejecutar carga diaria

--backup nivel 1
/*
rman> backup as backupset incremental level 1 cumulative database plus archivelog
tag bibliotecas_backup_nivel_1_1;

list backup;

AL-50: 38.24 Mb
DF-51: 20.67 Mb
AL-52: 57.00 Kb
CF-53: 17.83 Mb
*/

--Cálculo de la FRA
/*

*/
