set ver off
set echo off


select trunc(
            (1- (sum(decode(name,'physical reads',value,0))/
                 (sum(decode(name,'db block gets',value,0))
               + (sum(decode(name,'consistent gets',value,0))
            )))
            )*100
            ) "Buffer Hit Ratio"
from v$sysstat;

select a.value+b.value "Logical reads"
       ,c.value         "Physical Reads"
       ,d.value         "Physical Writes",
       round (100*((a.value+b.value)-c.value) 
                         / (a.value+b.value)) "Buffer Hit Ratio" ,
       round(c.value*100/(a.value+b.value)) "% Missed"
from v$sysstat a,v$sysstat b,v$sysstat c, v$sysstat d
where a.name = 'consistent gets'
and   b.name = 'db block gets'
and   c.name = 'physical reads'
and   d.name = 'physical writes'
;

prompt
prompt Data Dictionary Hit Ratio
prompt

select sum(gets) "Data Dict. Gets",
       sum(getmisses) "Data Dict. Cache Misses",
       round((1-(sum(getmisses)/sum(gets)))*100) "DATA DICT CACHE HIT RATIO",
       round(sum(getmisses)*100/sum(gets)) "% MISSED"
from v$rowcache;

prompt
prompt Library Cache Miss Ratio
prompt

select sum(pins) "executions",
       sum(reloads) "Cache Misses",
       round((1-(sum(reloads)/sum(pins)))*100) "LIBRARY CACHE HIT RATIO",
       round(sum(reloads)*100/sum(pins)) "% Missed"        
from v$librarycache;

select namespace,
       trunc(gethitratio*100) "Hit Ratio",
       trunc(pinhitratio*100) "Pin Hit Ratio",
       reloads "Reloads"
from v$librarycache;

prompt
prompt Redo Log Buffer
prompt

select substr(name,1,30),value 
from v$sysstat where name ='redo log space requests';

select pool,name,bytes from v$sgastat where name ='free memory';

select sum(executions) "Tot SQL since startup",
       sum(users_executing) "SQL executing now"
from v$sqlarea;

col c0 newline
set pages 0

select 
  'Instance No : ' ||INSTANCE_NUMBER c0
, 'Instance Name: '|| INSTANCE_NAME       c0
, 'Host Name: '|| HOST_NAME          c0
, 'Version: '|| VERSION           c0
, 'Startup Time: '|| STARTUP_TIME     c0
, 'Status: ' || STATUS          c0
, 'Parallel: ' ||PARALLEL       c0
, 'Thread: ' || THREAD#       c0
, 'Archiver: ' || ARCHIVER          c0
, 'Logins : ' || LOGINS            c0
, 'Shutdown Pending : ' || SHUTDOWN_PENDING    c0
, 'Status : ' || DATABASE_STATUS    c0
, 'Instance Role : ' || INSTANCE_ROLE          c0
from v$instance;

set pages 200

prompt
prompt if miss_ratio or immediate_miss_ratio > 1 then latch
prompt contention exists, (decrease LOG_SMALL_ENTRY_MAX_SIZE

select substr(l.name,1,30) name,
       (misses/(gets+.001))*100 mis_ratio,
       (immediate_misses/(immediate_gets+.001))*100 miss_ratio
from v$latch l
where 
  (misses/(gets+.001))*100 > .2
or
  (immediate_misses/(immediate_gets+.001))*100 > .2
order by l.name;       


prompt If these are < 1% of Total Number of Requests for Data
prompt then extra rollback segments may be needed.
select class,count
from v$waitstat 
where class in ('free list','system undo header',
                'system undo block','undo header',
                'undo block') 
group by class,count;

prompt Total Number of Requests for Data
select sum(value) from v$sysstat 
where name in ('db block gets','consistent gets');


