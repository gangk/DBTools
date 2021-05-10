REM -----------------------------------------------------
REM $Id: trc-off.sql,v 1.1 2002/04/01 21:48:32 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Generate commands to set sql trace off for a given sid
REM Usage       : 
REM Description : Generate commands to set sql trace off for a given sid
REM 
REM 
REM 
REM -----------------------------------------------------

undefine sid

accept sid   prompt 'Enter Oraclesid  :'

set head off
set lines 140
set veri off
set feed off

prompt 
prompt **** SQL generated into to.sql ****
prompt

spool to.sql

select 'exec dbms_system.set_sql_trace_in_session('||to_char(s.sid)||','||to_char(s.serial#)||
	',FALSE );' sqlt
from v$session s
where sid  IN (&sid)
/

spool off

set head on
set feed on

undefine sid

