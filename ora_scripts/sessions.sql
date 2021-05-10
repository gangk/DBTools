set linesize 150;
set pagesize 10000;
col event format a25;
col osuser format a10;
col machine format a30;
col program format a45;
col module format a25;
select /*+ RULE */ w.sid, w.event, s.machine, s.osuser, s.module, w.p1, w.p2, w.p3, w.seq#  from v$session_wait w, v$session s
where
s.sid = w.sid and w.event != 'SQL*Net message from client' and w.event != 'rdbms ipc message' and w.event != 'jobq slave wait';
