--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 29/12/2021
--@Descripcion: Simulacion de carga diaria para instance recovery

Prompt primera transaccion con usuario heza_biblioteca (realiza commit)
connect heza_biblioteca/hezab

set serveroutput on;
whenever sqlerror exit rollback

-- Consulta para concer sequencias geeradas por las columnas identity
-- select table_name, column_name, data_default from user_tab_columns where table_name = <table>;
declare
  v_total_dia number;
begin

  v_total_dia := 0;
  -- loop para simular 1 dia
  for i in 1..5 loop

      
      -- REDO BIBLIOTECA
      declare
        v_max_id number;
        v_count number;
        
        cursor cur_update is 
          select * from biblioteca sample(40);

      begin
        
        select max(biblioteca_id) into v_max_id from biblioteca;
        v_count := 0;
        for r in cur_update loop
          update biblioteca set nombre = r.nombre, folio = r.folio, 
            ubi_geografica = r.ubi_geografica, pagina_web = r.pagina_web, 
            direccion = r.direccion Where biblioteca_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros editados en BIBLIOTECA: '||v_count);
        v_total_dia := v_total_dia + v_count;
      end;
      

      -- REDO AREA DE CONOCIMIENTO
      declare
        v_max_id number;
        v_count number;
        
        cursor cur_update is 
          select * from area_conocimiento;

      begin

        select max(area_conocimiento_id) into v_max_id from area_conocimiento;
        v_count := 0;
        for r in cur_update loop
          update area_conocimiento set nombre = r.nombre 
            Where area_conocimiento_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros editados en AREA CONOCIMIENTO: '||v_count);
        v_total_dia := v_total_dia + v_count;
      end;
      

      -- REDO STATUS RECURSO
      declare
        v_max_id number;
        v_count number;

        cursor cur_update is 
          select * from status_recurso;

      begin

        select max(status_recurso_id) into v_max_id from status_recurso;
        v_count := 0;
        for r in cur_update loop
          update status_recurso set titulo = r.titulo 
            Where status_recurso_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros editados en STATUS RECURSO: '||v_count);
        v_total_dia := v_total_dia + v_count;
      end;
      

      -- REDO RECURSO
      declare
        v_max_id number;
        v_max_id_srecurso number;
        v_max_id_biblioteca number;
        v_count number;

        cursor cur_update is 
          select * from recurso sample(40);

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
      

      -- REDO PALABRA CLAVE
      declare
        v_max_id number;
        v_max_id_recurso number;
        v_count number;

        cursor cur_update is 
          select * from palabra_clave sample(50);

      begin

        select max(palabra_clave_id) into v_max_id from palabra_clave;
        v_count := 0;
        for r in cur_update loop
          update palabra_clave set recurso_id = r.recurso_id 
            Where palabra_clave_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros editados en PALABRA CLAVE: '||v_count);
        v_total_dia := v_total_dia + v_count;

      end;
      

      -- REDO AUTOR
      declare
        v_max_id number;
        v_count number;

        cursor cur_update is 
          select * from autor sample(40);

      begin

        select max(autor_id) into v_max_id from autor;
        v_count := 0;
        for r in cur_update loop
          update autor set nombre = r.nombre, apellidos = r.apellidos 
            Where autor_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros editados en AUTOR: '||v_count);
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

Prompt segunda transaccion con usuario heza_usuario (no realiza commit)
connect heza_usuario/hezau

set serveroutput on;
whenever sqlerror exit rollback

declare
  v_total_dia number;
begin

  v_total_dia := 0;
  -- loop para simular 5 dias
  for i in 1..5 loop


    -- REDO para Usuario
      declare
        v_max_id number;
        v_count number;

        cursor cur_delete is 
          select usuario_id from usuario sample(15) 
            where usuario_id not in (select usuario_id from prestamo);

        cursor cur_update is
          select * from usuario sample(50);

      begin
        v_count := 0;
        for r in cur_delete loop
          delete from usuario Where usuario_id = r.usuario_id;
          v_count := v_count + 1;
        end loop;
        dbms_output.put_line('Registros eliminados en USUARIO: '||v_count);
        v_total_dia := v_total_dia + v_count;


        select max(usuario_id) into v_max_id from usuario;
        v_count := 0;
        for r in cur_update loop
          update usuario set nombre = r.nombre, apellidos = r.apellidos, 
            email = dbms_random.string('x',2)||r.email, es_estudiante = r.es_estudiante, 
            semestre = r.semestre, usuario = r.usuario||dbms_random.string('x',2),
            password = r.password, foto = r.foto, con_prestamo = 0, 
            con_prestamo_vencido = 0 Where usuario_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );

          v_count :=  v_count + 1;
            
        end loop;
        dbms_output.put_line('Registros editados en USUARIO: '||v_count);
        v_total_dia := v_total_dia + v_count;

      end;

      -- REDO prestamo y libro_prestamo
      declare
        v_max_id number;
        v_count_prestamo number;
        v_count_libros number;
        v_resultado number;
        v_num_libros number;

        cursor cur_insert is 
          select u.usuario_id, decode(max(p.folio_prestamo), null, 0+1, max(p.folio_prestamo)+1) folio
            from (select usuario_id from usuario sample(50) where rownum <= 300) u 
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
        dbms_output.put_line('Registros insertados en PRESTAMO: '||v_count_prestamo);
        dbms_output.put_line('Registros insertados en LIBRO_PRESTAMO: '||v_count_libros);
        v_total_dia := v_total_dia + v_count_prestamo + v_count_libros;

      end;
  end loop;

  dbms_output.put_line('Total de datos manipulados en un dia: ' || v_total_dia);
end;
/