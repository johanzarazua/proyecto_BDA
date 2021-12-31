#!/bin/bash
# @Autor Hernández Gómez Alejandro, Zarazúa Ramírez Johan
# @Fecha 30/12/2021
# @Descripcion Creación de directorio para los archivelogs y pfiles (Ejecutar como root)


#Creación de la carpeta
dirU=/u01/app/oracle/oradata/HEZAPROY/disk_1/archivelogs/HEZAPROY/disk_a

if ! [ -d "${dirU}"/ ]; then
  #sudo su
  mkdir -p /u01/app/oracle/oradata/HEZAPROY/disk_1/archivelogs/disk_a
  cd /u01/app/oracle/oradata/HEZAPROY/disk_1
  chown -R oracle:oinstall archivelogs
  chmod -R 750 archivelogs
else
  echo "Directorio existente"
fi;

#Directorio para el respaldo del spfile
dirU=/u01/app/oracle/oradata/HEZAPROY/disk_1/respaldosSpfile

if ! [ -d "${dirU}"/ ]; then
  #sudo su
  mkdir -p /u01/app/oracle/oradata/HEZAPROY/disk_1/respaldosSpfile
  cd /u01/app/oracle/oradata/HEZAPROY/disk_1
  chown alejandro:oinstall respaldosSpfile
  chmod 774 respaldosSpfile
else
  echo "Directorio existente"
fi;

#Directorio para backups
dirU=/u01/app/oracle/oradata/HEZAPROY/disk_1/backups

if ! [ -d "${dirU}"/ ]; then
  #sudo su
  mkdir -p /u01/app/oracle/oradata/HEZAPROY/disk_1/backups
  cd /u01/app/oracle/oradata/HEZAPROY/disk_1
  chown oracle:oinstall backups
else
  echo "Directorio existente"
fi;


