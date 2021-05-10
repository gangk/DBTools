CREATE DATABASE "10202" 
CONTROLFILE REUSE
USER sys IDENTIFIED BY syspass 
USER system IDENTIFIED BY syspass 
MAXLOGFILES 50 
MAXLOGMEMBERS 5 
MAXLOGHISTORY 9999
MAXDATAFILES 100 
MAXINSTANCES 1 
NOARCHIVELOG 
CHARACTER SET WE8ISO8859P1
NATIONAL CHARACTER SET AL16UTF16   
LOGFILE 
  GROUP 1 '/opt/oracle/oradata/10202/redo01.log' SIZE 30M,
  GROUP 2 '/opt/oracle/oradata/10202/redo02.log' SIZE 30M,
  GROUP 3 '/opt/oracle/oradata/10202/redo03.log' SIZE 30M,
  GROUP 4 '/opt/oracle/oradata/10202/redo04.log' SIZE 30M,
  GROUP 5 '/opt/oracle/oradata/10202/redo05.log' SIZE 30M
DATAFILE
  '/opt/oracle/oradata/10202/system01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
SYSAUX 
  DATAFILE '/opt/oracle/oradata/10202/sysaux01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
UNDO TABLESPACE undotbs 
   DATAFILE '/opt/oracle/oradata/10202/undotbs01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
DEFAULT TABLESPACE users
    DATAFILE '/opt/oracle/oradata/10202/users01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
DEFAULT TEMPORARY TABLESPACE temp
    TEMPFILE '/opt/oracle/oradata/10202/temp01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
/