--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 30/12/2021
--@Descripcion: Generacion de datos redo

connect heza_usuario/hezau

set serveroutput on;
whenever sqlerror exit rollback

-- Consulta para concer sequencias geeradas por las columnas identity
-- select table_name, column_name, data_default from user_tab_columns where table_name = <table>;

-- Procedimiento para insertar en prestamo
prompt creando procedimiento para insertar en prestamo
CREATE OR REPLACE PROCEDURE p_crea_prestamo (
  p_folio_prestamo IN number,
  p_usuario_id IN number,
  p_resultado out number, p_num_libros out number
)
AS
  v_con_prestamo number;
  v_con_prestamo_vencido number;
  v_max_id number;
  v_id prestamo.prestamo_id%TYPE;
BEGIN
  select con_prestamo, con_prestamo_vencido into v_con_prestamo, v_con_prestamo_vencido
    from usuario where usuario_id = p_usuario_id;

  select max(recurso_id) into v_max_id from libro;
  if v_con_prestamo = 1 or v_con_prestamo_vencido = 1 then
    DBMS_OUTPUT.PUT_LINE('Por el momento el usuario ' || p_usuario_id || ' no puede solicitar mas prestamos');
    p_resultado := 0;
    p_num_libros := 0;
  else
    insert into prestamo (folio_prestamo, fecha_vigencia, fecha_devolucion, 
      multa, usuario_id)
    values (p_folio_prestamo, null, null, 0, 
      p_usuario_id) RETURNING prestamo_id into v_id;
    
    p_num_libros := 0;
    for i in 1..trunc(dbms_random.value(2,5)) loop
      insert into libro_prestamo (recurso_id, prestamo_id) 
      values( trunc(dbms_random.value(1, v_max_id)) , v_id);
      p_num_libros := p_num_libros + 1;
    end loop;
    dbms_output.put_line('Numero de libros prestados: '||p_num_libros);
    p_resultado := 1;
  end if;

  return;
END p_crea_prestamo;
/
show errors

declare
  v_total_dia number;
begin

  v_total_dia := 0;
  -- loop para simular 5 dias
  for i in 1..4 loop


    -- REDO para Usuario
      declare
        v_max_id number;
        v_count number;

        cursor cur_insert is
          select nombre, apellidos, matricula, email, es_estudiante, semestre, usuario,
            password, foto, con_prestamo, con_prestamo_vencido 
            from usuario sample(60) where rownum <= 400;

        cursor cur_update is
          select * from usuario sample(60) where rownum <= 500;

        cursor cur_delete is 
          select usuario_id from usuario sample(5) 
            where usuario_id not in (select usuario_id from prestamo);
      begin
        v_count := 0;
        for r in cur_insert loop
          select max(usuario_id) into v_max_id from usuario;
          insert into usuario (nombre, apellidos, matricula, email, es_estudiante, semestre,
            usuario, password, foto, con_prestamo, con_prestamo_vencido) 
            values (r.nombre, r.apellidos, r.matricula||dbms_random.string('x',10), 
              dbms_random.string('x',10)||r.email, r.es_estudiante, r.semestre, 
              r.usuario||dbms_random.string('x',8), dbms_random.string('x',16), r.foto, 
              r.con_prestamo, r.con_prestamo_vencido
            );
          v_count :=  v_count + 1;
        end loop;
        dbms_output.put_line('Registros insertados en USUARIO: '||v_count);
        v_total_dia := v_total_dia + v_count;

        select max(usuario_id) into v_max_id from usuario;
        v_count := 0;
        for r in cur_update loop
          update usuario set nombre = r.nombre, apellidos = r.apellidos, 
            email = dbms_random.string('x',10)||r.email, es_estudiante = r.es_estudiante, 
            semestre = r.semestre, usuario = r.usuario||dbms_random.string('x',8),
            password = r.password, foto = r.foto, con_prestamo = 0, 
            con_prestamo_vencido = 0 Where usuario_id = (
              select trunc(dbms_random.value(1,v_max_id)) from dual
            );

          v_count :=  v_count + 1;
            
        end loop;
        dbms_output.put_line('Registros editados en USUARIO: '||v_count);
        v_total_dia := v_total_dia + v_count;


        for r in cur_delete loop
          delete from usuario Where usuario_id = r.usuario_id;
          v_count := v_count + 1;
        end loop;
        dbms_output.put_line('Registros eliminados en USUARIO: '||v_count);
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

Prompt Confirmando cambios
commit;

Prompt Listo !!!
disconnect