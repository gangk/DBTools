REM -----------------------------------------------------
REM $Id: idx-comp.sql,v 1.1 2002/03/14 19:52:38 hien Exp $
REM Author      : Murray Ed
REM #DESC       : Compare index between two databases
REM Usage       : suepr_set_db - database with a "superset" of indexes
REM               super_set_usr - table owner on superset db
REM               sbu_set_usr - table woner of the current db
REM Description : Generate a list of index differences
REM               between two databases
REM -----------------------------------------------------

undefine super_set_db
undefine super_set_usr
undefine sub_set_usr

column owner format a30
column table_name format a30

accept super_set_db prompt 'Enter database with a "superset" of indexes: '
accept super_set_usr prompt 'Enter table owner on superset db: '
accept sub_set_usr prompt 'Enter table owner on this db: '

set verify off


PROMPT 'INDEX DIFFERENCES'

set heading off;

select LOWER('&&super_set_usr') || ' -@- ' || LOWER('&&super_set_db') 
       || ' minus ' || LOWER('&&sub_set_usr') || ' -@- ' || LOWER(name) Difference
from v$database;

set heading on;

select table_name,index_name,tablespace_name 
from dba_indexes@&&super_set_db
where owner = UPPER('&&super_set_usr')
and index_name in
(
select index_name
from dba_indexes@&&super_set_db
where table_name not like 'USLOG$%'
and table_name not like 'SYS_IOT%'
and table_name not like 'AQ$%'
and table_name not like 'MLOG$%'
and (table_name not like 'SNAP$%'
     or table_name in (select table_name from dba_tables where table_name like 'SNAP$%'))
and table_name not in (select queue_table from dba_queues@&&super_set_db)
and owner = UPPER('&&super_set_usr')
MINUS
select index_name
from dba_indexes
where owner = UPPER('&&sub_set_usr')
and table_name not like 'USLOG$%'
and table_name not like 'SYS_IOT%'
and table_name not like 'AQ$%'
and table_name not like 'MLOG$%'
and table_name not like 'SNAP$%'
and table_name not in (select queue_table from dba_queues)
and owner = UPPER('&&sub_set_usr')
)
order by 1
/

set verify on

undefine super_set_db;
undefine super_set_usr;
undefine sub_set_usr;
