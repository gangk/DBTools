set linesize 200;
set pagesize 10000;
col event format a35;
col osuser format a10;
col machine format a35 trunc;
col program format a45;
col module format a30;
set trimspool on
select /*+ RULE */ w.sid, s.sql_id, w.event, s.machine, s.osuser, s.module, s.LAST_CALL_ET
from 
	v$session_wait w, v$session s
where
	s.sid = w.sid and 
	w.event != 'SQL*Net message from client' and 
	w.event != 'rdbms ipc message' and 
	w.event != 'jobq slave wait';
