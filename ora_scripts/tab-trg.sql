REM -----------------------------------------------------
REM $Id: tab-trg.sql,v 1.1 2002/04/01 22:34:42 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Show triggers on a given table
REM Usage       : tn - table name
REM               usr - table owner
REM Description : Show triggers on a given table (partial name is acceptable)
REM -----------------------------------------------------

undefine tn;
undefine usr;

set linesize 132
set verify off

column column_name format a29


ACCEPT tn prompt 'Please enter table name or fragment: '
ACCEPT usr prompt 'Please enter table owner or fragment: '

select owner,table_name, trigger_name
from dba_triggers
where table_name like UPPER('&tn%')
and   table_owner like UPPER('&usr%');

undefine tn;
undefine usr;

