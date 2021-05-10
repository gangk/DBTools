REM -----------------------------------------------------
REM $Id: find-sql-by-phrase.sql,v 1.1 2002/03/14 00:01:51 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : find info about given sql (partial statement is acceptable)
REM Usage       : stmt - sql statement (partial is acceptable)
REM Description :
REM -----------------------------------------------------

undefine stmt;

accept stmt prompt 'Enter string to search for: ';

set lines 200

col module format a15
col osuser format a8
col machine format a10
col program format a40
col sql_text format a80
set trunc off
break on machine skip 1 on osuser on process


-- order by s.machine, s.osuser, s.process;

select t.module, t.sql_text
from v$sqlarea t
where UPPER(t.sql_text) like UPPER('%&&stmt%')
/

undefine stmt;
