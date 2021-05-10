REM -----------------------------------------------------
REM $Id: trc-on.sql,v 1.1 2002/04/01 21:48:34 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Generate commands to set sql trace on for a given sid
REM Usage       : sid - SID
REM Description : Generate commands to set sql trace on for a given sid
REM -----------------------------------------------------

undefine sid

accept sid prompt 'Enter sid :'
set head off
set lines 140
set veri off
set feed off

prompt
prompt **** SQL generated into to.sql ****
prompt

spool to.sql

select 'exec dbms_system.set_sql_trace_in_session('||to_char(s.sid)||','||to_char(s.serial#)||
	',TRUE );' sqlt
from v$session s
where sid  IN (&sid)
/

spool off

set head on
set feed on

undefine sid

