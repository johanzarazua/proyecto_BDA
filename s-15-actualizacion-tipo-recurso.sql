--@Autor:           Hernández Gómez Alejandro, Zarazúa ramírez Johan
--@Fecha creación:  29/12/2021
--@Descripción:     Actualización tipo recurso

whenever  sqlerror exit rollback

Prompt conectando usuario sys
connect heza_biblioteca

prompt creando trigger para historico_status_recurso
CREATE OR REPLACE TRIGGER tr_historico_status_recurso
AFTER INSERT OR UPDATE
ON recurso
FOR EACH ROW
DECLARE
  v_fecha date;
  v_recurso_id number;
  v_status_recurso_id number;
BEGIN
  v_fecha := sysdate;
  v_recurso_id := :new.recurso_id;
  v_status_recurso_id := :new.status_recurso_id;
  CASE
    WHEN INSERTING THEN
      insert into historico_status_recurso (fecha, recurso_id, status_recurso_id)
      values (v_fecha, v_recurso_id, v_status_recurso_id);
    WHEN UPDATING ('status_recurso_id') THEN
      insert into historico_status_recurso (fecha, recurso_id, status_recurso_id)
      values (v_fecha, :old.recurso_id, v_status_recurso_id);
  END CASE;
END tr_historico_status_recurso;
/

connect sys/system as sysdba
create public synonym libro for heza_biblioteca.libro;
grant select on heza_biblioteca.libro to heza_usuario;

connect heza_usuario

set serveroutput on

prompt creando procedimiento para insertar en prestamo
CREATE OR REPLACE PROCEDURE p_crea_prestamo (
  p_folio_prestamo IN number,
  p_fecha_vigencia IN date,
  p_fecha_devolucion IN date,
  p_multa IN number,
  p_usuario_id IN number
)
AS
  v_con_prestamo number;
  v_con_prestamo_vencido number;
  v_max_id number;
  v_id number;
BEGIN
  select con_prestamo, con_prestamo_vencido into v_con_prestamo, v_con_prestamo_vencido
  from usuario where usuario_id = p_usuario_id;
  select max(recurso_id) into v_max_id from libro;
  if v_con_prestamo == 1 or v_con_prestamo_vencido == 1 then
    DBMS_OUTPUT.PUT_LINE('No hay mas prestamos disponibles para el usuario ' || 
      p_usuario_id);
  else
    insert into prestamo (folio_prestamo, fecha_vigencia, fecha_devolucion, 
      multa, usuario_id)
    values (p_folio_prestamo, p_fecha_vigencia, p_fecha_devolucion, p_multa, 
      p_usuario_id) returning prestamo_id into v_id;
    insert into libro_prestamo (recurso_id, prestamo_id) 
    values (trunc(dbms_random.value(1, max_id)), v_id);
  end if;
END p_crea_prestamo;
/

connect heza_biblioteca

update recurso set tipo = 'L' where recurso_id = (
  select recurso_id from recurso rec 
  join libro lib on rec.recurso_id = lib.recurso_id
); 

update recurso set tipo = 'R' where recurso_id = (
  select recurso_id from recurso rec 
  join revista rev on rec.recurso_id = rev.recurso_id
); 

update recurso set tipo = 'T' where recurso_id = (
  select recurso_id from recurso rec 
  join tesis tes on rec.recurso_id = tes.recurso_id
); 