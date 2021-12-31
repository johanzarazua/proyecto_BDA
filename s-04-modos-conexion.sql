--@Autor Hernández Gómez Alejandro, Zarazúa Ramírez Johan
--@Fecha 27/12/2021
--@Descripcion Configuración del modo compartido

whenever sqlerror exit rollback;

--Autenticación con el usuario sys 
connect sys/system as sysdba

Prompt Modificando paramtros dispatchers y shared_servers
alter system set dispatchers='(dispatchers=2)(protocol=tcp)';
alter system set shared_servers=4;

alter system register;

Prompt Listo !!!
disconnect

--Configuración tnsnames.ora
/*
HEZAPROY =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = pc-ahg.fi.unam)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = hezaproy)
      (SERVER = DEDICATED)
    )
  )

HEZAPROY_SHARED =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = pc-ahg.fi.unam)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = hezaproy)
      (SERVER = SHARED)
    )
  )
*/
