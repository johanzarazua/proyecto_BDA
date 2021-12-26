#!/bin/bash
# @Autores Hernandez Gomez ALejandro, Johan Axel Zarazua Ramirez
# @Fecha 27/09/2021
# @Descripcion Ejercicio practico 2. Creacion de archivo de passwords y PFILE


dirArchivoPasswords=$ORACLE_HOME/dbs
archivo=inithezaproy.ora

echo "Cambiando oracle_sid"
export ORACLE_SID=hezaproy

echo "Creando archivo de passwords..."
orapwd FILE='$ORACLE_HOME/dbs/orapwhezaproy' force=y format=12.2 \
  SYS=password\
  SYSBACKUP=password

cd "${dirArchivoPasswords}"
touch "${archivo}"

ls -l $ORACLE_HOME/dbs/*hezaproy*

echo "db_name='hezaproy'" >> "${archivo}"
echo "control_files=(/u01/app/oracle/oradata/HEZAPROY/disk_1/control01.ctl,
      /u01/app/oracle/oradata/HEZAPROY/disk_2/control02.ctl,
      /u01/app/oracle/oradata/HEZAPROY/disk_3/control03.ctl)" >> "${archivo}"
echo "memory_target=768M" >> "${archivo}"