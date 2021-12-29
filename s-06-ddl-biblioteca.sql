--@Autor: Hernandez Gomez Alejandro, Johan Axel Zarazua Ramirez
--@Fecha creacion: 27/12/2021
--@Descripcion: Creacion de tablas e indices del modulo biblioteca

connect heza_biblioteca

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
-- table: area_conocimiento 
--
create table area_conocimiento(
  area_conocimiento_id    integer          generated always as identity,
  nombre                  varchar2(50)     not null,
  constraint area_conocimiento_pk primary key (area_conocimiento_id) using index(
    create unique index area_conocimiento_pk_iuk on 
      area_conocimiento(area_conocimiento_id) tablespace ts_biblioteca_index
  )  
) tablespace ts_biblioteca;


-- 
-- table: autor 
--
create table autor(
  autor_id     integer          generated always as identity,
  nombre       varchar2(50)     not null,
  apellidos    varchar2(100)    not null,
  constraint autor_pk primary key (autor_id) using index(
    create unique index autor_pk_iuk on autor(autor_id) 
      tablespace ts_biblioteca_index 
  )
) tablespace ts_biblioteca;


-- 
-- table: status_recurso 
--
create table status_recurso(
  status_recurso_id    integer          generated always as identity,
  titulo               varchar2(100)    not null,
  constraint status_recurso_pk primary key (status_recurso_id) using index(
    create unique index status_recurso_pk_iuk on 
      status_recurso(status_recurso_id) tablespace ts_biblioteca_index
  )
) tablespace ts_biblioteca;


-- 
-- table: blibioteca 
--
create table blibioteca(
  biblioteca_id     integer          generated always as identity,
  nombre            varchar2(50)     not null,
  folio             varchar2(5)      not null,
  ubi_geografica    varchar2(50)     not null,
  pagina_web        varchar2(250)    not null,
  direccion         varchar2(500)    not null,
  constraint blibioteca_pk primary key (biblioteca_id) using index(
    create unique index blibioteca_pk_iuk on blibioteca(biblioteca_id) 
      tablespace ts_biblioteca_index
  )
) tablespace ts_biblioteca;


-- 
-- table: recurso 
--
create table recurso(
  recurso_id              integer          generated always as identity,
  num_clasificacion       varchar2(20)     not null,
  fecha_adquisicion       date             not null,
  fecha_status            date             not null,
  tipo                    varchar2(1)      not null,
  status_recurso_id       integer          not null,
  recurso_nuevo_id        integer,
  area_conocimiento_id    integer          not null,
  biblioteca_id           integer          not null,
  constraint recurso_pk primary key (recurso_id) using index(
    create unique index recurso_pk_iuk on recurso (recurso_id)
      tablespace ts_biblioteca_index
  ), 
  constraint recurso_status_recurso_id_fk foreign key (status_recurso_id)
    references status_recurso(status_recurso_id),
  constraint recurso_recurso_nuevo_id_fk foreign key (recurso_nuevo_id)
    references recurso(recurso_id),
  constraint recurso_area_conocimiento_id_fk foreign key (area_conocimiento_id)
    references area_conocimiento(area_conocimiento_id),
  constraint recurso_biblioteca_id_fk foreign key (biblioteca_id)
    references blibioteca(biblioteca_id),
  constraint recurso_tipo_chk check ( tipo in ('L', 'R', 'T') )
) tablespace ts_biblioteca;

--
-- indices para Fk's de recurso
--
create index recurso_status_recurso_id_fk_ix on recurso(status_recurso_id)
  tablespace ts_biblioteca_index;
create index recurso_recurso_nuevo_id_fk_ix on recurso(recurso_nuevo_id)
  tablespace ts_biblioteca_index;
create index recurso_area_conocimiento_id_fk_ix on recurso(area_conocimiento_id)
  tablespace ts_biblioteca_index;
create index recurso_biblioteca_id_fk_ix on recurso(biblioteca_id)
  tablespace ts_biblioteca_index;


-- 
-- table: editorial 
--
create table editorial(
  editorial_id    integer          generated always as identity,
  clave           varchar2(50)     not null,
  nombre          varchar2(150)    not null,
  descripcion     varchar2(250)    not null,
  constraint editorial_pk primary key (editorial_id) using index(
    create unique index editorial_pk_iuk on editorial(editorial_id)
      tablespace ts_biblioteca_index
  )
) tablespace ts_biblioteca;


-- 
-- table: libro 
--
create table libro(
  recurso_id      integer          not null,
  titulo          varchar2(40)     not null,
  isbn            varchar2(17)     not null,
  pdf             blob             default empty_blob() not null,
  descripcion     varchar2(500)    not null,
  editorial_id    integer          not null,
  constraint libro_pk primary key (recurso_id) using index(
    create unique index libro_pk_iuk on libro(recurso_id)
      tablespace ts_biblioteca_index
  ), 
  constraint libro_recurso_id_fk foreign key (recurso_id)
    references recurso(recurso_id),
  constraint libro_editorial_id_fk foreign key (editorial_id)
    references editorial(editorial_id)
) tablespace ts_biblioteca
lob(pdf) store as (tablespace ts_lob);

-- create index libro_recurso_id_fk_ix on libro(recurso_id)
--   tablespace ts_biblioteca_index;
create index libro_editorial_id_fk_ix on libro(editorial_id)
  tablespace ts_biblioteca_index;


-- 
-- table: autor_libro 
--
create table autor_libro(
  autor_libro_id    integer          generated always as identity,
  recurso_id        integer          not null,
  autor_id          integer          not null,
  constraint autor_libro_pk primary key (autor_libro_id) using index(
    create unique index autor_libro_pk_iuk on autor_libro(autor_libro_id)
      tablespace ts_biblioteca_index
  ), 
  constraint autor_libro_recurso_id_fk foreign key (recurso_id)
    references libro(recurso_id),
  constraint autor_libro_autor_id_fk foreign key (autor_id)
    references autor(autor_id)
) tablespace ts_biblioteca;

-- create index autor_libro_recurso_id_fk_ix on autor_libro(recurso_id)
--   tablespace ts_biblioteca_index;
create index autor_libro_autor_id_fk_ix on autor_libro(autor_id)
  tablespace ts_biblioteca_index;


-- 
-- table: historico_status_recurso 
--
create table historico_status_recurso(
  historico_status_recurso_id    integer          generated always as identity,
  fecha                          date             not null,
  recurso_id                     integer          not null,
  status_recurso_id              integer          not null,
  constraint historico_status_recurso_pk primary key
    (historico_status_recurso_id) using index(
      create unique index historico_status_recurso_pk_iuk on
        historico_status_recurso(historico_status_recurso_id) 
        tablespace ts_biblioteca_index   
    ), 
  constraint historico_status_recurso_recurso_id_fk foreign key (recurso_id)
    references recurso(recurso_id),
  constraint historico_status_recurso_status_recurso_id_fk foreign key
    (status_recurso_id) references status_recurso(status_recurso_id)
) tablespace ts_biblioteca;

create index historico_status_recurso_recurso_id_fk_ix on
  historico_status_recurso(recurso_id) tablespace ts_biblioteca_index;
create index historico_status_recurso_status_recurso_id_fk_ix on
  historico_status_recurso(status_recurso_id) tablespace ts_biblioteca_index;


-- 
-- table: lista_area_c 
--
create table lista_area_c(
  lista_area_c_id         integer          generated always as identity,
  biblioteca_id           integer          not null,
  area_conocimiento_id    integer          not null,
  constraint lista_area_c_pk primary key (lista_area_c_id) using index(
    create unique index lista_area_c_pk_iuk on lista_area_c(lista_area_c_id)
      tablespace ts_biblioteca_index
  ), 
  constraint lista_area_c_biblioteca_id_fk foreign key (biblioteca_id)
    references blibioteca(biblioteca_id),
  constraint lista_area_c_area_conocimiento_id_fk foreign key
    (area_conocimiento_id) references area_conocimiento(area_conocimiento_id)
) tablespace ts_biblioteca;

create index lista_area_c_biblioteca_id_fk_ix on lista_area_c(biblioteca_id)
  tablespace ts_biblioteca_index;
create index lista_area_c_area_conocimiento_id_fk_ix on 
  lista_area_c(area_conocimiento_id) tablespace ts_biblioteca_index;


-- 
-- table: palabra_clave 
--
create table palabra_clave(
  palabra_clave_id    integer          generated always as identity,
  palabra             varchar2(80)     not null,
  recurso_id          integer          not null,
  constraint palabra_clave_pk primary key (palabra_clave_id) using index(
    create unique index palabra_clave_pk_iuk on palabra_clave(palabra_clave_id)
      tablespace ts_biblioteca_index
  ), 
  constraint palabra_clave_recurso_id_fk foreign key (recurso_id)
    references recurso(recurso_id),
  constraint palabra_clave_palabra_recurso_id_uk unique (recurso_id, palabra)
    using index(
      create unique index palabra_clave_palabra_recurso_id_uk_iuk on
        palabra_clave(recurso_id, palabra) tablespace ts_biblioteca_index
    )
) tablespace ts_biblioteca;


-- 
-- table: revista 
--
create table revista(
  recurso_id          integer          not null,
  titulo              varchar2(40)     not null,
  sinopsis            varchar2(500)    not null,
  mes_publicacion     number(2, 0)     not null,
  anio_publicacion    number(4, 0)     not null,
  num_emision         varchar2(40)     not null,
  editorial_id        integer          not null,
  constraint revista_pk primary key (recurso_id) using index(
    create unique index revista_pk_iuk on revista(recurso_id)
      tablespace ts_biblioteca_index
  ), 
  constraint revista_recurso_id_fk foreign key (recurso_id)
    references recurso(recurso_id),
  constraint revista_editorial_id_fk foreign key (editorial_id)
    references editorial(editorial_id)
) tablespace ts_biblioteca;

-- create index revista_recurso_id_fk_ix on revista(recurso_id)
--   tablespace ts_biblioteca_index;
create index revista_editorial_id_fk_ix on revista(editorial_id)
  tablespace ts_biblioteca_index;


-- 
-- table: tesis 
--
create table tesis(
  recurso_id          integer          not null,
  titulo              varchar2(40)     not null,
  tesista             varchar2(200)    not null,
  carrera             varchar2(80)     not null,
  universidad         varchar2(200)    not null,
  anio_publicacion    number(4, 0)     not null,
  mes_publicacion     number(2, 0)     not null,
  pdf                 blob,
  constraint tesis_pk primary key (recurso_id) using index(
    create unique index tesis_pk_iuk on tesis(recurso_id)
      tablespace ts_biblioteca_index
  ), 
  constraint tesis_recurso_id_fk foreign key (recurso_id)
    references recurso(recurso_id)
) tablespace ts_biblioteca
lob(pdf) store as (tablespace ts_lob);

grant references on libro to heza_usuario;