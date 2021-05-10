accept mview prompt'Enter mview name:- '
set lines 500
col owner for a20
col NAME for a30
col TABLE_NAME for a30
col MASTER for a30
col MASTER_LINK for a15
col LAST_REFRESH for a20
col TYPE for a10
col STATUS for a10
col prebuilt for a4
col SNAPSHOT_ID for 999999
col SNAPSHOT_SITE for a20
col VERSION for a25

PROMPT UPSTREAM INFO->Its a table if no rows selected
select OWNER,NAME,TABLE_NAME,MASTER,MASTER_LINK,LAST_REFRESH,TYPE,status,prebuilt from dba_snapshots where name=upper('&mview');

prompt MLOG INFO->It wont have any downstream if no rows selected
select  owner,segment_name,bytes/1024/1024 "MB",bytes/1024/1024/1024 "GB" from dba_segments,dba_snapshot_logs where segment_name=LOG_TABLE and master=upper('&mview') and rownum<2;

PROMPT DELAY FROM UPSTREAM->Its a table if no rows selected
select LAST_REFRESH_DATE,SYSDATE,(SYSDATE-LAST_REFRESH_DATE)*1440 "Delay In Minutes" FROM dba_mviews where mview_name=upper('&mview');


PROMPT DOWNSTREAM INFORMATION->It wont have any downstream if no rows selected
select site.SNAPSHOT_ID,site.SNAPSHOT_SITE,site.VERSION,logs.CURRENT_SNAPSHOTS,sysdate,(sysdate-logs.CURRENT_SNAPSHOTS)*1441 "Minutes behind" from dba_registered_snapshots site,dba_snapshot_logs logs where site.snapshot_id=logs.snapshot_id and MASTER=upper('&mview') order by 6 desc;

prompt CHECK IF PART OF ANY REFRESH GROUP
select REFRESH_GROUP,OWNER,MVIEW_NAME from mview_refresh_groups where MVIEW_NAME=upper('&mview');

prompt current operation
select * from (select OPERATION#,SQL_TXT from  sys.SNAP_REFOP$ where VNAME='&mview' order by OPERATION# desc) where rownum=1;

prompt size
select sum(bytes)/1024/1024 "MB",sum(bytes)/1024/1024/1024 "GB" from dba_segments where segment_name='&mview';

Prompt Check if currently Refreshing
col object_name for a30
col request for a9
col type for a10
col lmode for a12
col username for a8
col program for a47
col block for 9
select s.sid,
s.serial#,
s.username,
s.program,
decode(l.request,
  0,'None(0)',
  1,'Null(1)',
  2,'Row Share(2)',
  3,'Row Exclu(3)',
  4,'Share(4)',
  5,'Share Row Ex(5)',
  6,'Exclusive(6)') request
  ,block,l.type,
  decode(l.lmode,
  0,'None(0)',
  1,'Null(1)',
  2,'Row Share(2)',
  3,'Row Exclu(3)',
  4,'Share(4)',
  5,'Share Row Ex(5)',
  6,'Exclusive(6)') lmode,l.ctime,o.object_name,t.used_ublk*8192/1024"Kb",t.used_ublk*8192/1024/1024 "Mb"
  from v$lock l,dba_objects o, v$session s ,v$transaction t
  where l.type='JI'
  and l.id1=o.object_id
   and l.sid=s.sid
  AND O.OBJECT_NAME='&mview'
  and s.taddr=t.addr
  order by s.sid;

column mvowner format a10
Column mvname format a30
column refmode format a8
column refstate format a12
column inserts format 99999999
column updates format 999999999
column deletes format 999999999
column event format a30
column spid format a6
select  currmvowner_knstmvr mvowner,
currmvname_knstmvr mvname,
decode( reftype_knstmvr, 0, 'FAST', 1, 'FAST', 2, 'COMPLETE', REFTYPE_KNSTMVR ) refmode,
decode(groupstate_knstmvr, 1, 'SETUP', 2, 'INSTANTIATE',3, 'WRAPUP', 'UNKNOWN' ) refstate,
total_inserts_knstmvr inserts,
total_updates_knstmvr updates,
total_deletes_knstmvr deletes,
b.spid,c.event
from x$knstmvr X, v$session a, v$process b, v$session_wait c
WHERE type_knst=6
and a.paddr = b.addr
and a.sid = c.sid
and x.SID_KNST = a.sid
and x.SERIAL_KNST = a.serial#
and currmvname_knstmvr='&mview';

prompt Any Blockers
select l2.sid ||' is blocking '||l1.sid from v$lock l1,v$lock l2,dba_objects d where d.object_name='&mview' and d.object_id=l1.id1 and l1.id1=l2.id1 and l1.id2=l2.id2  and l1.request>0 and l2.block=1 and l1.type='JI';

prompt Any Waiters
select l2.sid ||' is blocking '||l1.sid from v$lock l1,v$lock l2,dba_objects d where d.object_name='&mview' and d.object_id=l1.id1 and l1.id1=l2.id1 and l1.id2=l2.id2 and l1.request>0 and l2.block=1 and l2.type='JI';

prompt Undo Stats
select s.sid,s.serial#,d.object_name,t.used_ublk*8192/1024 "Kb",t.used_ublk*8192/1024/1024 "Mb" from v$lock l,dba_objects d,v$session s,v$transaction t
where l.type='JI' and l.id1=d.object_id(+) and  l.sid=s.sid and t.addr = s.taddr and d.object_name like upper('%&mview%') order by 4 desc;

undef mview
