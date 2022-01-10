#!/bin/bash
# @Autor Hernández Gómez Alejandro, Zarazúa Ramírez Johan
# @Fecha 01/01/2022
# @Descripcion COnfiguraciones para backup de rman

export ORACLE_SID=hezaproy

#script con parametros FRA
echo "@s-23-habilita-fra.sql" | sqlplus sys/system as sysdba

#Backups de control files en fra
echo "configure controlfile autobackup format for device type disk clear;" | rman target sys/system@hezaproy