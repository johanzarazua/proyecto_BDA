**PROYECTO BDA.**
==

En estre proyecto se realiza la creación de una base de datos desde consola con
el fin de poner en prcatica los conceptos de adminstricacion de una base de datos
utilizando Oracle 19c en un sistema operativo linux. Adicionalmente, se creara 
e implemenrara un modelo relacional con base en las siguientes reglas de negocio.

> ADMINISTRACIÓN DE BIBLIOTECAS
> 
> La siguiente base de datos será construida para controlar las diversas bibliotecas con las que cuenta una universidad a nivel nacional. De cada
biblioteca se almacena su nombre, un folio único de 5 caracteres, su ubicación geográfica (latitud, longitud), su dirección de su página web y su dirección.
Cada biblioteca ofrece recursos de distintas áreas de conocimiento por ejemplo, biología, matemáticas, historia, etc. Se almacena la lista de áreas
de conocimiento de cada biblioteca.
El concepto de recurso se refiere a los elementos que una biblioteca ofrece a sus usuarios. Las bibliotecas ofrecen 3 tipos: libros, revistas.
Independiente del tipo, para cada recurso se almacena su número de clasificación (alfanumérico formado de 3 secciones o grupos de caracteres, en total
son 18 caracteres). Se registra la fecha de adquisición del material, el área de conocimiento al que pertenece. Para controlar la situación de cada material,
se ha definido una serie de status: Disponible para préstamo, en préstamo, solo de consulta en sala, dañado, en reparación, extraviado, en préstamo
expirado. Se desea almacenar su status actual, fecha de status y el histórico de valores a lo largo del tiempo. Para realizar consultas rápidas, cada recurso
almacena un listado de palabras clave. La única limitante para registrar palabras es que estas deben ser sustantivos y no deben duplicarse. Pudieran
estar registradas el 100% de los sustantivos que tiene un libro.
Al paso del tiempo, un recurso puede salir de servicio por diversas causas. La más común por antigüedad. El recurso debe ser reemplazado por uno
nuevo. Para garantizar esta regla, al recurso viejo se le asocia el recurso que lo va a reemplazar.
Para los libros se almacena ISBN, título, editorial y su lista de autores. Se cuenta con un catálogo de editoriales en el que se guarda clave, nombre
y descripción. Para cada libro se guardan un PDF con un breve resumen del libro para ser promocionado en la página. Para el caso de las revistas se
almacena su título, sinopsis, el año y mes de publicación, nombre de la empresa que la edita y el número de emisión. Para las tesis, se almacena el título
de la tesis, el nombre completo del tesista, la carrera, el nombre de la universidad, el mes y año en la que se publicó. En algunos casos la tesis también
se encuentra en formato digital. Se almacena el documento PDF.
La biblioteca cuenta con un registro global de usuarios. Para cada uno se almacena, nombre, apellidos, número de matrícula, email obligatorio,
número de semestre (en caso de ser estudiante aun), username y password empleados para el sitio web. Al registrarse, el usuario debe tomarse una
foto la cual se debe almacenar.
Para realizar un préstamo se realiza el siguiente procedimiento: El usuario puede solicitar cualquier número de préstamos, pero uno a la vez. Un
préstamo no puede tener más de 5 libros. Cada préstamo tiene un periodo de vigencia. Cuando se le otorga un préstamo a un usuario se prende una
bandera llamada “con préstamo”. Cuando la vigencia del préstamo expira, se prende otra bandera llamada “con préstamo vencido”. Al entregar los
libros se almacena la fecha de entrega y en caso de aplicar el importe de la multa del préstamo por entrega tardía o por maltrato de recursos.
Cada usuario cuenta con su consecutivo de préstamos iniciando en 1.

## MODELO RELACIONAL DEL CASO DE ESTUDIO. 
---

![Modelo relacional](Modelo_logico.png)

Este modelo sera dividido en 2 modulos y cada uno de ellos sera administrado por un usuario particular
|Modulo|Descripción|Usuario|
|------|-----------|-------|
|Usuario|Objetos y funcionalidades relacionadas a los usuarios y sus préstamos|heza_usuario
|Biblioteca|Objetos y funcionalidades relacionadas a las bibliotecas, áreas de conocimiento, recursos y status del recurso|heza_biblioteca|

![Modulos](Modulos.png)

### DISEÑO LOGICO DE LA BASE DE DATOS

<table>
  <thead>
    <tr>
      <th>Tabla</th>
      <th>Modulo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>usuario</td>
      <td rowspan=3>Usuario</td>
    </tr>
    <tr>
      <td>prestamo</td>
    </tr>
    <tr>
      <td>libro_prestamo</td>
    </tr>
    <tr>
      <td>lista_area_c</td>
      <td rowspan=13>Biblioteca</td>
    </tr>
    <tr>
      <td>biblioteca</td>
    </tr>
    <tr>
      <td>area_conocimiento</td>
    </tr>
    <tr>
      <td>recurso</td>
    </tr>
    <tr>
      <td>libro</td>
    </tr>
    <tr>
      <td>revista</td>
    </tr>
    <tr>
      <td>tesis</td>
    </tr>
    <tr>
      <td>autor</td>
    </tr>
    <tr>
      <td>autor_libro</td>
    </tr>
    <tr>
      <td>editorial</td>
    </tr>
    <tr>
      <td>palabra_clave</td>
    </tr>
    <tr>
      <td>status_recurso</td>
    </tr>
    <tr>
      <td>historico_status_recurso</td>
    </tr>
  </tbody>
</table>

### ESQUEMA DE INDEXADO
|Nombre de la tabla|Nombre del índice|tipo|Proposito|
|------------------|-----------------|----|---------|
|Usuario|usuario_pk|Primary key|Identificar de manera única cada registro
|Area_conocimiento|area_conocimiento_pk|Primary key|Identificar de manera única cada registro
|BIblioteca |biblioteca_pk|Primary key|Identificar de manera única cada registro
|Lista_area_c|lista_area_c_pk|Primary key|Identificar de manera única cada registro
|Lista_area_c|lista_area_c_blibioteca_id_fk|Foreing key|Relacionar lista de áreas de conocimiento con biblioteca
|Lista_area_c|lista_area_c_area_conocimiento_id_fk|Foreing key|Relacionar lista de áreas de conocimiento con áreas de conocimiento
|Status_recurso|status_recurso_pk|Primary key |Identificar de manera única cada registro
|Recurso|recurso_pk|Primary key|Identificar de manera única cada registro
|Recurso|recurso_recurso_nuevo_id_fk|Foreing key|Relacionar recurso antiguo con su sustituto
|Recurso|recurso_area_conocimiento_id_fk|Foreing key |Relacionar recurso con área de conocimiento
|Recurso|recurso_status_recurso_id_fk|Foreing key |Relacionar recurso con status
|Recurso|recurso_biblioteca_id_fk|Foreing key |Relacionar recurso con biblioteca
|Palabra_clave|palabra_clave_pk|Primary key|Identificar de manera única cada registro
|Palabra_clave|palabra_clave_recurso_id_fk|Foreing key|Relacionar las palabras claves de un recurso
|Palabra_clave|palabra_clave_palabra_recurso_id_uk|Unique |Combinación única entre recurso y palabra clave
|Historico_status_recurso|historico_status_recurso_pk|Primary key|Identificar de manera única cada registro
|Historico_status_recurso|historico_status_recurso_recurso_id_fk|Foreing key|Relacionar histórico con recurso
|Historico_status_recurso|historico_status_recurso_status_recurso_id_fk|Foreing key|Relacionar histórico con status
|Tesis|tesis_pk|Primary key|Identificar de manera única cada registro
|Tesis|tesis_recurso_id_fk|Foreing key|Relacionar tesis con recurso
|Revista|revista_pk|Primary key|Identificar de manera única cada registro
|Revista |revista_recurso_id_fk|Foreing key|Relacionar revista con recurso
|Revista|revista_editorial_id_fk|Foreing key|Relacionar revista con editorial
|Libro|libro_pk|Primary key|Identificar de manera única cada registro
|Libro|libro_recurso_id_pk|Foreing key|Relacionar libro con recurso
|Libro|libro_editorial_id_fk|Foreing key|Relacionar libro con editorial
|Editorial|editorial_pk|Primary key|Identificar de manera única cada registro
|Autor|autor_pk|Primary key|Identificar de manera única cada registro
|Autor_libro|autor_libro_pk|Primary key|Identificar de manera única cada registro
|Autor_libro|autor_libro_recurso_id_fk|Foreing key|Relacionar lista de autores del libro con recurso
|Autor_libro|autor_libro_autor_id_fk|Foreing key|Relacionar lista de autores del libro con un autor
|Prestamo|prestamo_pk|Primary key|Identificar de manera única cada registro
|Prestamo|prestamo_usuario_id_fk|Foreing key|Relacionar préstamo con un usuario
|Prestamo|prestamo_folio_usuario_uk|Unique |Combinación única entre préstamo y usuario
|Libro_prestamo|libro_prestamo_pk|Primary key|Identificar de manera única cada registro
|Libro_prestamo|libro_prestamo_folio_prestamo_fk|Foreing key|Relacionar la lista de libros que incluye un préstamo
|Libro_prestamo|libro_prestamo_recurdo_id_fk|Foreing key|Relacionar un recurso con la lista de recursos que incluye el préstamo

## DEFINICION DE TABLESPACES
---

### TABLESPACES COMUNES A LOS MODULOS
|Nombre|Configuracion|
|---------------------|-------------|
|ts_ blob|Big file, 3G, extent management local autoallocate y segment space management auto, $ORACLE_BASE/oradata/$ORACLE_SID/disk_1/ts_blob01.dbf|

### TABLESPACES POR MODULO
<b>Modulo Usuario:</b>
|Nombre|Objetivo|Tipo|Configuracion|
|------|--------|----|-------------|
|ts_usuario|Almacenar datos sobre las tablas|permanente|Small file (un datafile), de 250M auto extendible hasta 500M, extent management local autoallocate y segment space management auto, $ORACLE_BASE/oradata/$ORACLE_SID/disk_2/usuariots.dbf|
|ts_usuario_index|Guardar en un ts dedicado los índices del módulo|permanente|Small file (un datafile),  de 100M auto extendible hasta 300M, extent management local autoallocate y segment space management auto, $ORACLE_BASE/oradata/$ORACLE_SID/disk_2/usuarioidxts.dbf|

<b>Modulo BIblioteca</b>
|Nombre|Objetivo|Tipo|Configuracion|
|------|--------|----|-------------|
|ts_biblioteca|Almacenar datos sobre las tablas|permanente|Big file, de 500M auto extendible hasta 3GB, extent management local autoallocate y segment space management auto, $ORACLE_BASE/oradata/$ORACLE_SID/disk_3/usuariots.dbf
|ts_blibioteca_index|Guardar en un ts dedicado los índices del módulo|permanente|Small file (un datafile),  de 100M auto extendible hasta 500M, extent management local autoallocate y segment space management auto, $ORACLE_BASE/oradata/$ORACLE_SID/disk_2/usuarioidxts.dbf

### ASIGNACION DE TABLESPACES PARA TABLAS DE CADA MODULO
<b>Modulo Usuario:</b>
|Tabla|Tablesapce|
|-----|----------|
|Usario|ts_usuario|
|Prestamo|ts_usuario|
|Libro_prestamo|ts_usuario|

<b>Modulo BIblioteca</b>
|Tabla|Tablesapce|
|-----|----------|
|Biblioteca|ts_biblioteca|
|Lsita_area_c|ts_biblioteca|
|Area_conocimineto|ts_biblioteca|
|Status_recurso|ts_biblioteca|
|Historico_status_recurso|ts_biblioteca|
|Recurso|ts_biblioteca|
|Libro|ts_biblioteca|
|Revista|ts_biblioteca|
|Tesis|ts_biblioteca|
|Palabra_clave|ts_biblioteca|
|Editorial|ts_biblioteca|
|Autor|ts_biblioteca|
|Autor_libro|ts_biblioteca|

### ASIGNACION DE TABLESPACES PARA INDICES DE CADA MODULO
<b>Modulo Usuario:</b>
|Nombre del índice|Tipo de indice|Nombre de la tabla|Nombre de la columna|Nombre del tablespace|
|-----------------|--------------|------------------|--------------------|---------------------|
|usuario_pk|Primary key|Usuario|usuario_id|ts_usuario_index|
|prestamo_pk|Primary key|Prestamo|prestamo_id|ts_usuario_index|
|prestamo_usuario_id_fk|Foreing key|Prestamo|usuario_id|ts_usuario_index|
|prestamo_folio_usuario_uk|Unique |Prestamo|usuario_id, folio_prestamo|ts_usuario_index|
|libro_prestamo_pk|Primary key|Libro_prestamo|libro_prestamo_id|ts_usuario_index|
|libro_prestamo_folio_prestamo_fk|Foreing key|Libro_prestamo|prestamo_id|ts_usuario_index|
|libro_prestamo_recurdo_id_fk|Foreing key|Libro_prestamo|recurso_id|ts_usuario_index|

<b>Modulo BIblioteca</b>
|Nombre del índice|Tipo de indice|Nombre de la tabla|Nombre de la columna|Nombre del tablespace|
|-----------------|--------------|------------------|--------------------|---------------------|
|biblioteca_pk|Primary key|Biblioteca|biblioteca_id|ts_biblioteca_index
|lista_area_c_pk|Primary key|Lista_area_c|lista_area_c_id|ts_biblioteca_index
|lista_area_c_blibioteca_id_fk|Foreing key|Lista_area_c|biblioteca_id|ts_biblioteca_index
|lista_area_c_area_conocimiento_id_fk|Foreing key|Lista_area_c|area_conocimiento_id|ts_biblioteca_index
|autor_libro_pk|Primary key|Autor_libro|autor_libro_id|ts_biblioteca_index
|autor_libro_recurso_id_fk|Foreing key|Autor_libro|recurso_id|ts_biblioteca_index
|autor_libro_autor_id_fk|Foreing key|Autor_libro|autor_id|ts_biblioteca_index
|autor_pk|Primary key|Autor|autor_id|ts_biblioteca_index
|editorial_pk|Primary key |Editorial|editorial_id|ts_biblioteca_index
|area_conocimeinto_pk|Primary key|Area_conocimiento|area_conocimiento_id|ts_biblioteca_index
|status_recurso_pk|Primary key|Status_recurso|status_recurso_id|ts_biblioteca_index
|palabra_clave_pk|Primary key|Palabra_clave|palabra_clave_id|ts_biblioteca_index
|palabra_clave_recurso_id_fk|Foreing key|Palabra_clave|recurso_id|ts_biblioteca_index
|palabra_clave_palabra_recurso_id_uk|Unique |Palabra_clave|recurso_id, palabra|ts_biblioteca_index
|historico_status_recurso_pk|Primary key|Historico_status_recurso|historico_status_recurso_id|ts_biblioteca_index
|historico_status_recurso_recurso_id_fk|Foreing key|Historico_status_recurso|status_recurso_id|ts_biblioteca_index
|historico_status_recurso_status_recurso_id_fk|Foreing key|Historico_status_recurso|recurso_id|ts_biblioteca_index
|recurso_pk|Primary key|Recurso|recurso_id|ts_biblioteca_index
|recurso_recurso_nuevo_id_fk|Foreing key|Recurso|recurso_nuevo_id|ts_biblioteca_index
|recurso_area_conocimiento_id_fk|Foreing key |Recurso|area_conocimiento_id|ts_biblioteca_index
|recurso_status_recurso_id_fk|Foreing key |Recurso|status_recurso_id|ts_biblioteca_index
|recurso_biblioteca_id_fk|Foreing key |Recurso|biblioteca_id|ts_biblioteca_index
|tesis_pk|Primary key|Tesis|recurso_id|ts_biblioteca_index
|tesis_recurso_id_fk|Foreing key|Tesis|recurso_id|ts_biblioteca_index
|revista_pk|Primary key|Revista|recurso_id|ts_biblioteca_index
|revista_recurso_id_fk|Foreing key|Revista|recurso_id|ts_biblioteca_index
|revista_editorial_id_fk|Foreing key|Revista|editorial_id|ts_biblioteca_index
|libro_pk|Primary key|Libro|recurso_id|ts_biblioteca_index
|libro_recurso_id_pk|Foreing key|Libro|recurso_id|ts_biblioteca_index
|libro_editorial_id_fk|Foreing key|Libro|editorial_id|ts_biblioteca_index

### ASIGNACION DE TABLESPACES PARA COLUMNAS CLOB/BLOB DE CADA MODULO
<b>Modulo Usuario:</b>
|Nombre de la columna clob/blob|Nombre del índice asociado a la columna clob/blob|Nombre de la tabla|Nombre del tablespace para la columna clob/blob|Nombre del tablespace para el índice de la columna clob/blob|
|-----------|---------|------------|-------------|---------------|
|foto|usuario_foto_idx|Usuario|ts_blob|ts_usario_index|

<b>Modulo BIblioteca</b>
|Nombre de la columna clob/blob|Nombre del índice asociado a la columna clob/blob|Nombre de la tabla|Nombre del tablespace para la columna clob/blob|Nombre del tablespace para el índice de la columna clob/blob|
|-----------|---------|------------|-------------|---------------|
|PDF|libro_pdf_idx|Libro|ts_blob|ts_bibliteca_index|
|PDF|tesis_pdf_idx|Tesis|ts_blob|ts_bibliteca_index|



## PLANEACIÓN PARA LA CREACION DE LA NUEVA BD
---

|Configuracion|Descripción y/o configuración|
|-------------|-----------------------------|
Número y ubicación de los archivos de control|3 archivos de control, ubicaciones:<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_1/control01.ctl<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_2/control02.ctl<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_3/control03.ctl|
|Propuesta grupos de REDO|3 grupos de REDO con 3 miembros cada uno<br>Grupo 1:<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_1/redo01a.log<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_2/redo01b.log<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_3/redo01c.log<br>Grupo 2:<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_1/redo02a.log<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_2/redo02b.log<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_3/redo02c.log<br>Grupo 3:<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_1/redo03a.log<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_2/redo03b.log<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_3/redo03c.log|
|Propuesta juego de caracteres |Character = AL32UTF8<br>National character = AL32UTF16|
|Tamaño de bloque de datos|db_block_size = default value (8192)<br>Redologs = 512| 
|Lista de parámetros que serán configurados al crear la BD| (Configuracion incial)<br>db_name = hezaproy<br>control_files = (<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_1/control01.ctl<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_2/control02.ctl<br>$ORACLE_BASE/oradata/$ORACLE_SID/disk_3/control03.ctl<br>)<br>memory_target = 768M<br><br>(Configuracion posterior)<br>dispatchers = (dispatchers = 2 )(protocol = tcp)<br>shared_servers = 4<br>log_archive_max_processes = 5<br>log_archive_dest_1 = /u01/app/oracle/oradata/HEZAPROY/disk_1/archivelogs/disk_a MANDATORY<br>log_archive_dest_2 = USE_DB_RECOVERY_FILE_DEST<br>log_archive_format = 'arch_hezaproy_%t_%s_%r.arc'<br>log_archive_min_succeed_dest = 1|
|Archivo de passwords|$ORACLE_HOME/dbs/orapwhezaproy<br>SYS = password<br>SYSBACKUP = password|


## CÁLCULO DE LA FRA
---

|Variable|Tamaño (Mb)|
|--------|-----------|
|Tamaño de una copia de la base de datos|681.09|
|Tamaño de un backup incremental nivel 1|20.67|
|Tamaño de los archive redo logs que se producirán en N+1 días (N = 6)|268.079|
|Tamaño del backup set que contiene el archivo de control|17.83|
|Tamaño de los flashback logs|60|
|Tamaño de uno de los miembors de redo logs * (N+1)|200|
|Total de espacio estimado para la FRA|1361.4359 => 1400 => 1600|

## PLANEACIÓN DEL ESQUEMA DE RESPALDOS
---

|Concepto|Valor|
|--------|-----------|
|Tipos de backups a realizar|Backup incremental nivel 0 y backup incremental nivel 1 diferencial|
|Frecuencia de repetición|Backup incremental nivel 0 cada 7 días y backup incremental nivel 1 diferencial cada día|
|Ubicaciones de respaldo (FRA)|FRA|
|Política de retención de backups|Se necesita mínimo un backup completo nivel 0 (configure retention policy redundancy 1)|
|Tamaño total en espacio en disco para realizar backups|2 Gb|

## COTENIDO DEL REPOSITORIO 
---

En el repositorio se podran encontrar la siguiente lista de scripts:

| Nombre del script | Descripción |
|-------------------|-------------|
| s-01-crear-loop-devices.sh| Creación de los directorios donde se encontraran diferentes archivos de la base de datos y simulacion de puntos demontaje usando loop devices para multiplexar algunos archivos.|
|s-02-crea-pwd-param-oracle.sh| Creación del archivo de password y pfile con parametros inciales de la base de datos|
|s-03-creacion-bd.sql|Creación de la base de datos usando el comando create database|
|s-04-modos-conexion.sql| Configuracion de parametros necesarios para contar con modos de conexion dedicado y compartido|
|s-05-directorios-archivelog.sql|Creacion de los directorios inicales para el modo archivelog|
|s-06-mod-archivelog.sql|Configuracion necesaria para habilitar el modo archivelog|
|s-07-crea-tablespaces.sql| Creación de los tablespaces necesarios para cada modulo asi como un tablespace compartido para campos blob|
|s-08-crea-usarios.sql| Creación de usuarios por modulo y asigancion de privilegios para crear objetos|
|s-09-ddl.sql|Ejecucion de scripts de ddl para cad modulo|
|s-10-ddl-biblioteca.sql| Creación de tablas e indices del modulo biblioteca|
|s-11-ddl-usuario.sql| Creación de tablas e indices del modulo usuario|
|s-12-carga-inicial.sql| Ejecucion de scripts para realizar la carga inicial de cada modulo|
|s-13-carga-biblioteca.sql| Carga inicial de datos para el modulo biblioteca|
|s-14-carga-usuario.sql| Carga inicial de datos para el modulo usuario|
|s-15-genera-redo.sql| Ejecucion de scripts para generar datos de redo en cada modulo|
|s-16-redo-biblioteca.sql| Genereaciòn de datos de redo para modulo biblioteca|
|s-17-redo-usuario.sql| Genereaciòn de datos de redo para modulo usuario|
|s-18-calculo-fra.sh| Creacion de backups para determinar el tamaño de la FRA|
|s-19-full-backup.rman| Instrucciones para realizar full backup en RMAN|
|s-20-backup-0.rman| Instrucciones para realizar backup nivel 0 en RMAN|
|s-21-backup-1.rman| Instrucciones para realizar backup nivel 1 en RMAN|
|s-22-FRA.sh|Configuraciones RMAN|
|s-23-habilita-fra.sql|Configuracion de parametros de la FRA|
|s-25-mueve-grupo-redo.sql|Creacion de nuevos grupps de redo con un miembro dentro de la FRA|
|s-26-instance-recovery.sql|Simulacion de proceso de instance recovery|
|s-28-media-recovery.sql|Simulacion de proceso de media recovery|