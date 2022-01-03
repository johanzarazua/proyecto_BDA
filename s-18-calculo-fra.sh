#!/bin/bash
# @Autor Hernández Gómez Alejandro, Zarazúa Ramírez Johan
# @Fecha 01/01/2022
# @Descripcion Caalculo del espacio de la FRA

export ORACLE_SID=hezaproy

rman @s-19-full-backup.rman

echo "@s-15-genera-redo.sql" | sqlplus sys/system as sysdba

rman @s-20-backup-0.rman

echo "@s-15-genera-redo.sql" | sqlplus sys/system as sysdba

rman @s-21-backup-1.rman