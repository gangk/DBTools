Prompt REFRESH JOBS DESCRTIPTION
set lines 500
col "Last Date" for a20
col "Next Date" for a20
col command for a60
SELECT job, SUBSTR(log_user,1,5) "User",
  SUBSTR(schema_user,1,5) "Schema",
  SUBSTR(TO_CHAR(last_date,'DD.MM.YYYY HH24:MI'),1,16) "Last Date",
  SUBSTR(TO_CHAR(next_date,'DD.MM.YYYY HH24:MI'),1,16) "Next Date",
  SUBSTR(broken,1,2) "B", SUBSTR(failures,1,6) "Failed",
  SUBSTR(what,1,60) "Command"
   FROM dba_jobs where lower(what) like '%refresh%'
   order  by 1;
  
 
Prompt CURRENTLY RUNNING REFRESH JOBS (THROTTLE NOT INCLUDED) ->Manual not included
set lines 500   
COL OWNER FOR A8
COL "Mat View" FOR A30
COL Username FOR A8
col description for a45 wrap
col "job id" for 9999999
col sid for 9999
col spid for a6
col serial# for 99999
col program for a10
   select 
     o.owner        "Owner",
     o.object_name  "Mat View",
     s.username       "Username",
     s.sid          ,
     s.serial#      ,
     p.spid         ,
     substr(s.program,-10,10) program      ,
     jo.job         "job id",
     substr(jo.what,24,50)        "Description" 
   from
     v$lock         l,
     dba_objects    o,
     v$session      s,
     dba_jobs_running jr,
     dba_jobs jo,
     v$process p
   where
     o.object_id   = l.id1    and
     l.type        ='JI'      and
     l.lmode       = 6        and
     s.sid         = l.sid    and
     o.object_type = 'TABLE'  and
     s.sid         = jr.sid   and
     jr.job        = jo.job   and
     s.paddr      =  p.addr   and
     lower(jo.what) like '%refresh%'
order by jo.job;

Prompt Lock stats
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
  ,block,decode(l.TYPE,'JQ','JOB Q','JI','Mview Lock',l.TYPE) type,
  decode(l.lmode,
  0,'None(0)',
  1,'Null(1)',
  2,'Row Share(2)',
  3,'Row Exclu(3)',
  4,'Share(4)',
  5,'Share Row Ex(5)',
  6,'Exclusive(6)') lmode,l.ctime,l.id1,l.id2,nvl(o.object_name,'NONE') object_name
  from v$lock l,dba_objects o, v$session s  where l.sid in (select sid from v$lock where type='JI') and l.type<>'AE'
  and l.id1=o.object_id(+)
   and l.sid=s.sid
  order by s.sid;

prompt Any Blockers
select l2.sid ||' is blocking '||l1.sid from v$lock l1,v$lock l2 where l1.sid in (select sid from v$lock where type='JI') and l1.id1=l2.id1 and l1.id2=l2.id2 and l1.request>0 and l2.block=1;

prompt Any Waiters
select l2.sid ||' is blocking '||l1.sid from v$lock l1,v$lock l2 where l2.sid  in (select sid from v$lock where type='JI') and l1.id1=l2.id1 and l1.id2=l2.id2 and l1.request>0 and l2.block=1;
prompt Undo Stats
select s.sid,s.serial#,d.object_name,t.used_ublk*8192/1024 "Kb",t.used_ublk*8192/1024/1024 "Mb" from v$lock l,dba_objects d,v$session s,v$transaction t
where l.type='JI' and l.id1=d.object_id(+) and  l.sid=s.sid and t.addr = s.taddr order by 4 desc;
