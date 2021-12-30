--@Autor:           Hernández Gómez Alejandro, Zarazúa ramírez Johan
--@Fecha creación:  29/12/2021
--@Descripción:     Actualización tipo recurso

whenever  sqlerror exit rollback

Prompt conectando usuario sys
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