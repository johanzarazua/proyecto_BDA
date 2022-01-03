--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 03/01/2022
--@Descripcion: Simulacion de instance recovery

Prompt Conectando con usuario heza_biblioteca, sus cambios haran commit
connect heza_biblioteca/hezab

set serveroutput on;
whenever sqlerror exit rollback

declare
  v_total_dia number;
begin

  v_total_dia := 0;
  -- loop para simular 1 dia
  for i in 1..6 loop

      -- REDO RECURSO
      declare
        v_max_id number;
        v_max_id_srecurso number;
        v_max_id_biblioteca number;
        v_count number;

        cursor cur_update is 
          select * from recurso sample(30) where rownum <= 100;

      begin
        v_count := 0;
        select max(recurso_id) into v_max_id from recurso;
        select max(status_recurso_id) into v_max_id_srecurso from status_recurso;
        for r in cur_update loop
          update recurso set status_recurso_id = trunc(dbms_random.value(1,v_max_id_srecurso))
            where recurso_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count := v_count + 1;
        end loop;
        dbms_output.put_line('Registros editando status en RECURSO: '||v_count);
        v_total_dia := v_total_dia + v_count;

      end;

  end loop;

  dbms_output.put_line('Total de datos manipulados en un dia: ' || v_total_dia);
end;
/

Prompt Confirmando cambios
commit;

Prompt Listo !!!
disconnect

Prompt Conectando con usuario heza_biblioteca, sus cambios no haran commit
connect heza_usuario/hezau

set serveroutput on;
whenever sqlerror exit rollback

-- Consulta para concer sequencias geeradas por las columnas identity
-- select table_name, column_name, data_default from user_tab_columns where table_name = <table>;

declare
  v_total_dia number;
begin

  v_total_dia := 0;
  -- loop para simular 5 dias
  for i in 1..6 loop

      -- REDO prestamo y libro_prestamo
      declare
        v_max_id number;
        v_count_prestamo number;
        v_count_libros number;
        v_resultado number;
        v_num_libros number;

        cursor cur_insert is 
          select u.usuario_id, decode(max(p.folio_prestamo), null, 0+1, max(p.folio_prestamo)+1) folio
            from (select usuario_id from usuario sample(50) where rownum <= 100) u 
            left join prestamo p on u.usuario_id = p.usuario_id
            group by (u.usuario_id);
        
      begin
        
        v_count_prestamo := 0;
        v_count_libros := 0;
        for r in cur_insert loop
          dbms_output.put_line('Generando prestamo para el usuario: '||r.usuario_id);
          p_crea_prestamo(r.folio,r.usuario_id,v_resultado,v_num_libros);

          if v_resultado > 0 then
            v_count_prestamo := v_count_prestamo + 1;
            v_count_libros := v_count_libros + v_num_libros;
          end if;

        end loop;
        -- dbms_output.put_line('Registros insertados en PRESTAMO: '||v_count_prestamo);
        -- dbms_output.put_line('Registros insertados en LIBRO_PRESTAMO: '||v_count_libros);
        v_total_dia := v_total_dia + v_count_prestamo + v_count_libros;

      end;

  end loop;

  dbms_output.put_line('Total de datos manipulados en un dia: ' || v_total_dia);
end;
/

conn sys/system as sysdba

shutdown abort

set timing on
startup
set timing off

alter system set fast_start_mttr_target = 1800;