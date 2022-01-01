#!/bin/bash
# @Autor Hernández Gómez Alejandro, Zarazúa Ramírez Johan
# @Fecha 30/12/2021
# @Descripcion Creación de loop devices y directorio para los archivelogs y pfiles (Ejecutar como root)

directorio=/unam-bda
pathProy=/u01/app/oracle/oradata/HEZAPROY
fraName=disk_fra
diskU=/u01/app/oracle/oradata/HEZAPROY/disk_1 

#si no existe el directorio se crea
if ! [ -d "${directorio}"/ ]; then
  echo "Creando directorio ${directorio}..."
  mkdir "${directorio}"
else
  echo "El directorio ya existe"
fi;

#cambio al directorio
cd "${directorio}"

#archivos de loop device
dd if=/dev/zero of=disk_fra.img bs=100M count=10

#se comprueba la creacion de los archivos de loop device
du -sh disk_p_*.img

#validamos el status del comando anterior, si es 0 no hay error los archivos se crearon
status=$?
if [ "${status}" -eq 0 ]; then
  echo "Archivos de loop device creados correctamente"

  #creacion de loop device
  losetup -fP disk_fra.img

  mkfs.ext4 disk_fra.img

  cd "${pathProy}"
  mkdir "${fraName}"

  mount -a

  chown -R  oracle:oinstall "${fraName}"
  chmod -R  750 "${fraName}"

else 
  echo "Problema con los archivos loop device"
fi;


cd "${diskU}"

#Directorio para el respaldo del spfile
dirU=respaldosSpfile

if ! [ -d "${dirU}"/ ]; then
  #sudo su
  mkdir ${dirU}
  chown oracle:oinstall ${dirU}
  chmod 774 ${dirU}
else
  echo "Directorio existente"
fi;

#Directorio para backups
dirU=backups

if ! [ -d "${dirU}"/ ]; then
  #sudo su
  mkdir ${dirU}
  chown oracle:oinstall ${dirU}
  chmod 774 ${dirU}
else
  echo "Directorio existente"
fi;

#Directorio para el respaldo del spfile
dirU=archivelogs

if ! [ -d "${dirU}"/ ]; then
  #sudo su
  mkdir ${dirU}
  chown oracle:oinstall ${dirU}
  chmod 774 ${dirU}
else
  echo "Directorio existente"
fi;