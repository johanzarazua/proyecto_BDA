#!/bin/bash
# @Autores Hernandez Gomez ALejandro, Johan Axel Zarazua Ramirez
# @Fecha 27/09/2021
# @Descripcion Simulacion de punto de montaje y creacion de rutas necesarias.


directorio=/unam-bda
pathProy=/u01/app/oracle/oradata
dbName=HEZAPROY

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
dd if=/dev/zero of=disk_p_2.img bs=100M count=10
dd if=/dev/zero of=disk_p_3.img bs=100M count=10

#se comprueba la creacion de los archivos de loop device
du -sh disk_p_*.img

#validamos el status del comando anterior, si es 0 no hay error los archivos se crearon
status=$?
if [ "${status}" -eq 0 ]; then
  echo "Archivos de loop device creados correctamente"

  #creacion de loop device
  losetup -fP disk_p_2.img
  losetup -fP disk_p_3.img

  mkfs.ext4 disk_p_2.img
  mkfs.ext4 disk_p_3.img

  cd "${pathProy}"
  mkdir "${dbName}"

  cd "${dbName}"
  mkdir disk_1
  mkdir disk_2
  mkdir disk_3

  mount -a

  cd "${pathProy}"
  chown -R  oracle:oinstall *
  chmod -R  750 *

else 
  echo "Problema con los archivos loop device"
fi;