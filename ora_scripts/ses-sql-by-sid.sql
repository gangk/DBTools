REM -----------------------------------------------------
REM $Id: ses-sql-by-sid.sql,v 1.1 2002/03/14 00:27:45 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Get the last sql stmt executed by the sid set by set-sid.sql
REM Usage       : No parameters
REM Description : Get the last sql statement executed by the sid that is set 
REM               by running set-sid.sql
REM -----------------------------------------------------

set lines 130
col username format a10
col schemaname format a10
col osuser format a8
col machine format a10
col program format a40
col last_command format a10 heading 'Last|Command'
col sql_text format a80
set trunc off
break on machine skip 1 on osuser on process

select t.disk_reads, t.buffer_gets, t.sorts, t.executions, t.sql_text
from 	v$session s,
	v$sqlarea t
where	s.sql_hash_value = t.hash_value
and     s.sid = to_number(nvl(:vsid,s.sid))
order by s.machine, s.osuser, s.process;
