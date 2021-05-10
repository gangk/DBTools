CREATE DATABASE OIDREP01 
CONTROLFILE REUSE
USER sys IDENTIFIED BY sys_OIDREP01
USER system IDENTIFIED BY system_OIDREP01
MAXLOGFILES 50 
MAXLOGMEMBERS 5 
MAXLOGHISTORY 9999
MAXDATAFILES 100 
MAXINSTANCES 1 
NOARCHIVELOG 
CHARACTER SET WE8ISO8859P1
NATIONAL CHARACTER SET AL16UTF16   
LOGFILE 
  GROUP 1 '/apps/oid-rep/redo01/OIDREP01/redo01.log' SIZE 50M,
  GROUP 2 '/apps/oid-rep/redo01/OIDREP01/redo02.log' SIZE 50M,
  GROUP 3 '/apps/oid-rep/redo01/OIDREP01/redo03.log' SIZE 50M,
  GROUP 4 '/apps/oid-rep/redo01/OIDREP01/redo04.log' SIZE 50M,
  GROUP 5 '/apps/oid-rep/redo01/OIDREP01/redo05.log' SIZE 50M
DATAFILE
  '/apps/oid-rep/data01/OIDREP01/system01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
SYSAUX 
  DATAFILE '/apps/oid-rep/data01/OIDREP01/sysaux01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
UNDO TABLESPACE undotbs 
   DATAFILE '/apps/oid-rep/data01/OIDREP01/undotbs01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
DEFAULT TABLESPACE users
    DATAFILE '/apps/oid-rep/data01/OIDREP01/users01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
DEFAULT TEMPORARY TABLESPACE temp
    TEMPFILE '/apps/oid-rep/data01/OIDREP01/temp01.dbf' SIZE 100M autoextend on next 100M maxsize 2000M
/

conn / as sysdba

-- Creates data dictionary views.
conn / as sysdba
@?/rdbms/admin/catalog.sql

-- Run all sql scripts for the procedural option
conn / as sysdba
@?/rdbms/admin/catproc.sql

-- Catalog Views for locks
conn / as sysdba
@?/rdbms/admin/catblock.sql

-- catoctk.sql - CATalog - Oracle Cryptographic ToolKit
conn / as sysdba
@?/rdbms/admin/catoctk.sql


conn system/manager
-- Script to install the SQL*Plus PRODUCT_USER_PROFILE tables
@?/sqlplus/admin/pupbld.sql
-- SQL*Plus Help
@?/sqlplus/admin/help/hlpbld.sql helpus.sql


--Install Java Option
conn / as sysdba
@?/javavm/install/initjvm.sql;
@?/xdk/admin/initxml.sql;
@?/xdk/admin/xmlja.sql;
@?/rdbms/admin/catjava.sql;
@?/rdbms/admin/catexf.sql;


-- Data Mining Option
conn / as sysdba
@?/rdbms/admin/dminst.sql SYSAUX TEMP;


-- Oracle Context
conn / as sysdba
@?/ctx/admin/catctx change_on_install SYSAUX TEMP NOLOCK;
connect "CTXSYS"/"change_on_install"
@?/ctx/admin/defaults/dr0defin.sql "AMERICAN";


-- XML DB
conn / as sysdba
@?/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
@?/rdbms/admin/catxdbj.sql;
@?/rdbms/admin/catrul.sql;


-- interMedia
conn / as sysdba
-- ORD components (Creates the schemas and grants the privs needed to run interMedia and Spatial)
@?/ord/admin/ordinst.sql SYSAUX SYSAUX;
@?/ord/im/admin/iminst.sql;

-- OLAP
conn / as sysdba
@?/olap/admin/olap.sql SYSAUX TEMP;


-- Spatial
conn / as sysdba
-- ORD components (Creates the schemas and grants the privs needed to run interMedia and Spatial)
@?/ord/admin/ordinst.sql SYSAUX SYSAUX;
@?/md/admin/mdinst.sql;


