REM -----------------------------------------------------
REM $Id: ses-stat-by-sid.sql,v 1.2 2003/03/21 23:26:06 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Get session statistic with the sid set by set-sid.sql
REM Usage       : No parameters
REM Description : Get session statistic with the sid that is
REM               set by set-id.sql
REM -----------------------------------------------------

set pages 60
col name format a50
col value format 99999999999999

select 	n.name, t.value
from 	v$session s,
	v$sesstat t,
	v$statname n
where	s.sid = t.sid
and     s.sid = nvl(&vsid,s.sid)
and	t.statistic# = n.statistic#
and	(name like 'redo%' 
	or name like 'table%'
	or name like 'cons%'
	or name like 'roll%'
	or name like 'CPU%'
	or name like 'def%')
order by n.name;
