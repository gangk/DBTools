REM -----------------------------------------------------
REM $Id: tab-comp.sql,v 1.1 2002/03/14 19:52:41 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Compare tables across two databases
REM Usage       : super_set_db - database name with a superset of tables
REM               super_set_usr - owner on the superset database
REM               sub_set_usr - owner on the current table
REM Description : Compare tables across two databases
REM -----------------------------------------------------

undefine super_set_db
undefine super_set_usr
undefine sub_set_usr

column owner format a30
column table_name format a30

accept super_set_db prompt 'Enter database with a "superset" of tables: '
accept super_set_usr prompt 'Enter table owner on superset db: '
accept sub_set_usr prompt 'Enter table owner on this db: '



set verify off


PROMPT 'TABLE DIFFERENCES'

set heading off;

select LOWER('&&super_set_usr') || ' -@- ' || LOWER('&&super_set_db') 
       || ' minus ' || LOWER('&&sub_set_usr') || ' -@- ' || LOWER(name) Difference
from v$database;

set heading on;

select owner
      ,table_name
from dba_tables@&&super_set_db
where table_name not like 'USLOG$%'
and table_name not like 'SYS_IOT%'
and table_name not like 'AQ$%'
and table_name not like 'MLOG$%'
and table_name not like 'SNAP$%'
and table_name not in (select queue_table from dba_queues@&&super_set_db)
and  owner = UPPER('&&super_set_usr')
MINUS
select owner
     , table_name
from dba_tables
where table_name not like 'USLOG$%'
and table_name not like 'SYS_IOT%'
and table_name not like 'AQ$%'
and table_name not like 'MLOG$%'
and table_name not like 'SNAP$%'
and table_name not in (select queue_table from dba_queues)
and  owner = UPPER('&&sub_set_usr')
/


set verify oni

undefine super_set_db
undefine super_set_usr
undefine sub_set_usr

