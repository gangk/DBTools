set lines 170 echo off
col event	format a26 	head 'Wait Event'	trunc
col mod		format a26	head 'Module'		trunc
col sqlid	format a13	head 'SQL Id'
col oname	format a38	head 'Object Name'
col sname	format a30	head 'SubObject Name'
col otyp	format a10	head 'Object Typ'	trunc
col cnt		format 999999	head 'Wait Cnt'
col twait	format 9999999999	head 'Tot Time|Waited'

select 	 o.owner||'.'||o.object_name		oname
	,o.object_type				otyp
	,o.subobject_name			sname
	,h.event				event
	,h.wcount				cnt
	,h.twait				twait
	,h.sql_id				sqlid
	,h.module				mod
from	(select current_obj#,sql_id,module,event,count(*) wcount,sum(time_waited+wait_time) twait
	 from v$active_session_history		
	 where event not in (
                       'queue messages'
                      ,'rdbms ipc message'
                      ,'rdbms ipc reply'
                      ,'pmon timer'
                      ,'smon timer'
                      ,'jobq slave wait'
                      ,'wait for unread message on broadcast channel'
                      ,'wakeup time manager')
	 and event not like 'SQL*Net%'
	 and event not like 'Backup%'
	 group by current_obj#,sql_id,module,event
	 order by twait desc) 	  h
	,dba_objects		  o
where	 h.current_obj# 	= o.object_id
and	 rownum			< 31
;
