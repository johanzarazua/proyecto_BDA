--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 27/12/2021
--@Descripcion: Creacion de tablas e indices del modulo usuario

connect heza_usuario/hezau

Prompt Creando tablas y objetos del modulo usuario
set serveroutput on;
whenever sqlerror exit rollback

-- Bloque para eliminar objectos en caso de existir
declare 
  cursor cur_objetos is
    select object_name from user_objects where object_type = 'TABLE';
begin
  for r in cur_objetos loop
    execute immediate 'drop table ' || r.object_name || ' cascade constraints PURGE';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, se obtuvo excepción  no esperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/

-- 
-- table: usuario 
--
create table usuario(
  usuario_id              integer          generated always as identity(start with 1 increment by 1),
  nombre                  varchar2(50)     not null,
  apellidos               varchar2(40)     not null,
  matricula               varchar2(40)     not null,
  email                   varchar2(200)    not null,
  es_estudiante           number(1, 0)     not null,
  semestre                number(2, 0),
  usuario                 varchar2(100)     not null,
  password                varchar2(40)     not null,
  foto                    blob             default on null empty_blob(),
  con_prestamo            number(1, 0)     not null,
  con_prestamo_vencido    number(1, 0)     not null,
  constraint usuario_pk primary key (usuario_id) using index(
    create unique index usuario_pk_iuk on usuario(usuario_id)
      tablespace ts_usuario_index
  ),
  constraint usuario_email_uk unique (email) using index(
    create unique index usuario_email_uk_iuk on
      usuario(email) tablespace ts_usuario_index
  ),
  constraint usuario_usuario_uk unique (usuario) using index(
    create unique index usuario_usuario_uk_iuk on
      usuario(usuario) tablespace ts_usuario_index
  ),
  constraint usuario_semestre_chk 
    check ( (es_estudiante = 1 and semestre between 1 and 10) or
      es_estudiante = 0 and semestre is null  )
) tablespace ts_usuario
lob(foto) store as (tablespace ts_lob);


-- 
-- table: prestamo 
--
create table prestamo(
  prestamo_id         integer          generated always as identity(start with 1 increment by 1),
  folio_prestamo      number(10, 0)    not null,
  fecha_vigencia      date             default on null sysdate + 7,
  fecha_devolucion    date,
  multa               number(10, 2)    default on null 0,
  usuario_id          integer          not null,
  constraint prestamo_pk primary key (prestamo_id) using index(
    create unique index prestamo_pk_iuk on prestamo(prestamo_id)
      tablespace ts_usuario_index
  ), 
  constraint prestamo_usuario_id_fk foreign key (usuario_id)
    references usuario(usuario_id),
  constraint prestamo_folio_usuario_id_uk unique (usuario_id, folio_prestamo)
    using index(
      create unique index prestamo_folio_usuario_id_uk_iuk on
        prestamo(usuario_id, folio_prestamo) tablespace ts_usuario_index
    )
) tablespace ts_usuario;


create index prestamo_usuario_id_fk_ix on prestamo(usuario_id) 
  tablespace ts_usuario_index;


-- 
-- table: libro_prestamo 
--
create table libro_prestamo(
  libro_prestamo_id    integer          generated always as identity(start with 1 increment by 1),
  recurso_id           integer          not null,
  prestamo_id          integer          not null,
  constraint libro_prestamo_pk primary key (libro_prestamo_id) using index(
    create unique index libro_prestamo_pk_iuk on 
      libro_prestamo(libro_prestamo_id) tablespace ts_usuario_index
  ), 
  constraint libro_prestamo_prestamo_id_fk foreign key (prestamo_id)
    references prestamo(prestamo_id),
  constraint libro_prestamo_recurso_id_fk foreign key (recurso_id)
    references heza_biblioteca.libro(recurso_id)
) tablespace ts_usuario;

create index libro_prestamo_prestamo_id_fk_ix on libro_prestamo(prestamo_id)
  tablespace ts_usuario_index;
create index libro_prestamo_recurso_id_fk_ix on libro_prestamo(recurso_id)
  tablespace ts_usuario_index;

Prompt Listo !!!
disconnect