--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 02/01/2022
--@Descripcion: Mueve un grupo de redo dentro de la FRA

whenever  sqlerror exit rollback;

conn sys/system as sysdba

-- Consultar informacion de los grupos de redo existentes
set linesize window
col member for a60
select l.thread#, group#, sequence#, l.status, member, type,  
  IS_RECOVERY_DEST_FILE is_rdf 
from 
  v$logfile inner join v$log l
  using (group#) order by  l.thread#, group#;

-- Bloque PL para crear grupos de redo dentro de la FRA y miembros fuera 
declare
  cursor cur_grops_logs is
    select group# grp, thread# thr, bytes/1024 bytes from v$log
      order by 1;
    
  v_max_group number;
  v_statement varchar2(2048);
  v_log_switch varchar2(1024) := 'alter system switch logfile';
  v_checkpoint_gbl varchar2(1024) := 'alter system checkpoint global';
begin
  select max(group#) + 1 into v_max_group from v$log;

  for r in cur_grops_logs loop
    v_statement := 'alter database add logfile thread ' || r.thr || ' size 50M';
    execute immediate v_statement;
    execute immediate 'alter database add logfile member ''/u01/app/oracle/oradata/HEZAPROY/disk_1/redo0' || v_max_group || 'b.log'' to group ' || v_max_group;
    execute immediate 'alter database add logfile member ''/u01/app/oracle/oradata/HEZAPROY/disk_2/redo0' || v_max_group || 'c.log'' to group ' || v_max_group;
    begin
      v_statement := 'alter database drop logfile group ' || r.grp;
      execute immediate v_statement;
    exception
      when others then
        execute immediate v_log_switch;
        execute immediate v_checkpoint_gbl;
        execute immediate v_statement;
    end;
    execute immediate v_log_switch;
  end loop;
end;
/

-- Agregar miembros a los grupos creados 
-- alter database add logfile member '/u01/app/oracle/oradata/HEZAPROY/disk_1/redo04b.log' to group 4;
-- alter database add logfile member '/u01/app/oracle/oradata/HEZAPROY/disk_2/redo04c.log' to group 4;

-- alter database add logfile member '/u01/app/oracle/oradata/HEZAPROY/disk_1/redo05b.log' to group 5;
-- alter database add logfile member '/u01/app/oracle/oradata/HEZAPROY/disk_2/redo05c.log' to group 5;

-- alter database add logfile member '/u01/app/oracle/oradata/HEZAPROY/disk_1/redo06b.log' to group 6;
-- alter database add logfile member '/u01/app/oracle/oradata/HEZAPROY/disk_2/redo06c.log' to group 6;