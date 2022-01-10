--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 03/01/2022
--@Descripcion: Simulacion de instance recovery

set serveroutput on;

@s-27-carga-diaria-IR.sql

conn sys/system as sysdba

Prompt Tiempo estimado de recuperacion para la carga de datos
select estimated_mttr from V$INSTANCE_RECOVERY;


Prompt shutdown abort
shutdown abort

set timing on;
Prompt levantando la instancia 
startup
set timing off;

-- alter system set fast_start_mttr_target = 1800;