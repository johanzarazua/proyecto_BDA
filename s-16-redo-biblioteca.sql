--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 29/12/2021
--@Descripcion: Generacion de datos redo

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
  for i in 1..4 loop

      
      -- REDO BIBLIOTECA
      declare
        v_max_id number;
        v_count number;

        cursor cur_insert is
          select nombre, folio, ubi_geografica, 
            pagina_web, direccion from biblioteca sample(60) where rownum <= 300;
        
        cursor cur_update is 
          select * from biblioteca sample(60) where rownum <= 300;

      begin
        v_count := 0;
        for r in cur_insert loop
          select max(biblioteca_id) into v_max_id from biblioteca;
          insert into biblioteca (nombre, folio, ubi_geografica, pagina_web, direccion) 
            values (r.nombre||v_max_id, dbms_random.string('x',5), r.ubi_geografica, r.pagina_web, r. direccion);
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en BIBLIOTECA: '||v_count);
        v_total_dia := v_total_dia + v_count;

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

        cursor cur_insert is
          select nombre
            from area_conocimiento sample(80) where rownum <= 60;
        
        cursor cur_update is 
          select * from area_conocimiento;

      begin
        v_count := 0;
        for r in cur_insert loop
          select max(area_conocimiento_id) into v_max_id from area_conocimiento;
          insert into area_conocimiento (nombre) values (r.nombre||v_max_id);
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en AREA CONOCIMIENTO: '||v_count);
        v_total_dia := v_total_dia + v_count;

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

        cursor cur_insert is
          select titulo
            from status_recurso;
        
        cursor cur_update is 
          select * from status_recurso;

      begin
        v_count := 0;
        for r in cur_insert loop
          select max(status_recurso_id) into v_max_id from status_recurso;
          insert into status_recurso (titulo) values (r.titulo||v_max_id);
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en STATUS RECURSO: '||v_count);
        v_total_dia := v_total_dia + v_count;

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

        cursor cur_insert is
          select num_clasificacion, 
            fecha_adquisicion+1 as fecha_adquisicion, sysdate as fecha_status, tipo,
            recurso_nuevo_id, area_conocimiento_id
            from recurso sample(60) where rownum <= 300;

        cursor cur_update is 
          select * from recurso sample(60) where rownum <= 300;

      begin
        v_count := 0;
        for r in cur_insert loop
          select max(recurso_id) into v_max_id from recurso;
          select max(status_recurso_id) into v_max_id_srecurso from status_recurso;
          select max(biblioteca_id) into v_max_id_biblioteca from biblioteca;

          -- dbms_output.put_line('PK status: '||v_max_id_srecurso || ' | ' || v_rand);

          insert into recurso (num_clasificacion, fecha_adquisicion, fecha_status, tipo, 
            status_recurso_id, recurso_nuevo_id, area_conocimiento_id, biblioteca_id) 
            values (substr(r.num_clasificacion,14)||v_max_id, r.fecha_adquisicion, r.fecha_status, r.tipo, 
            trunc(dbms_random.value(1,v_max_id_srecurso)), 
            r.recurso_nuevo_id, r.area_conocimiento_id, 
            trunc(dbms_random.value(1,v_max_id_biblioteca)));
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en RECURSO: '||v_count);
        v_total_dia := v_total_dia + v_count;

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

        cursor cur_insert is
          select palabra
            from palabra_clave sample(80) where rownum <= 400;

        cursor cur_update is 
          select * from palabra_clave sample(50);

        cursor cur_delete is
          select palabra_clave_id from palabra_clave sample(5);

      begin
        v_count := 0;
        for r in cur_insert loop
          select max(palabra_clave_id) into v_max_id from palabra_clave;
          select max(recurso_id) into v_max_id_recurso from recurso;

          insert into palabra_clave (palabra, recurso_id) values(r.palabra||dbms_random.string('x',10), 
            trunc(dbms_random.value(1,v_max_id_recurso)) );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en PALABRA CLAVE: '||v_count);
        v_total_dia := v_total_dia + v_count;

        select max(palabra_clave_id) into v_max_id from palabra_clave;
        v_count := 0;
        for r in cur_update loop
          update palabra_clave set palabra = r.palabra||dbms_random.string('x',10), recurso_id = r.recurso_id 
            Where palabra_clave_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros editados en PALABRA CLAVE: '||v_count);
        v_total_dia := v_total_dia + v_count;
        
        v_count := 0;
        for r in cur_delete loop
          delete from palabra_clave where palabra_clave_id = r.palabra_clave_id;
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros eliminados en PALABRA CLAVE: '||v_count);
        v_total_dia := v_total_dia + v_count;

      end;
      

      -- REDO AUTOR
      declare
        v_max_id number;
        v_count number;

        cursor cur_insert is
          select nombre, apellidos
            from autor sample(60) where rownum <= 200;

        cursor cur_update is 
          select * from autor sample(60) where rownum <= 250;

      begin
        v_count := 0;
        for r in cur_insert loop
          select max(autor_id) into v_max_id from autor;
          insert into autor (nombre, apellidos) values(r.nombre||v_max_id, r.apellidos||v_max_id);
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en AUTOR: '||v_count);
        v_total_dia := v_total_dia + v_count;

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
      

      -- REDO EDITORIAL
      declare
        v_max_id number;
        v_count number;

        cursor cur_insert is
          select clave, nombre, descripcion from editorial sample(80) where rownum <= 200;

        cursor cur_update is 
          select * from editorial sample(50);

      begin
        v_count := 0;
        for r in cur_insert loop
          select max(editorial_id) into v_max_id from editorial;
          insert into editorial (clave, nombre, descripcion) values (r.clave||v_max_id, r.nombre||v_max_id, r.descripcion);
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en EDITORIAL: '||v_count);
        v_total_dia := v_total_dia + v_count;

        select max(editorial_id) into v_max_id from editorial;
        v_count := 0;
        for r in cur_update loop
          update editorial set clave = r.clave, nombre = r.nombre, descripcion =  r.descripcion 
            Where editorial_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros editados en EDITORIAL: '||v_count);
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