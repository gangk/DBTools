select dbid from v$database
/

REM
PROMPT aas_on_awr_waits.sql From the output check the higher AAS, waits and graph.................
REM
accept dbid prompt 'Enter dbid:- '
set lines 230
set pages 30000

Def v_secs=3600 --  bucket size
Def v_days=5 --  total time analyze
Def v_bars=5 -- size of one AAS in characters

col aveact format 999.99
col graph format a80
col fpct format 9.99
col spct format 9.99
col tpct format 9.99
col aas1 format 9.99
col aas2 format 9.99
col pct1 format 999
col pct2 format 999
col first format  a15
col second format  a15

Def p_value=4
Def v_graph = 80
--select to_char(start_time,'DD HH:MI:SS'),
select to_char(start_time,'DD-MM HH:MI'),
       --samples,
       --total,
       --waits,
       --cpu,
       (total/&v_secs) aas,
       --round(fpct * (total/&v_secs),2) aas1,
       fpct*100  pct1,
       decode(fpct,null,null,first) first,
       --round(spct * (total/&v_secs),2) aas2,
       spct*100 pct2,
       decode(spct,null,null,second) second,
	-- substr, ie trunc, the whole graph to make sure it doesn't overflow
        substr(
	   -- substr, ie trunc, the graph below the # of CPU cores line
           -- draw the whole graph and trunc at # of cores line
	   substr(
	     rpad('+',round((cpu*&v_bars)/&v_secs),'+') ||
             rpad('o',round((io*&v_bars)/&v_secs),'o')  ||
             rpad('-',round((waits*&v_bars)/&v_secs),'-')  ||
             rpad(' ',&p_value * &v_bars,' '),0,(&p_value * &v_bars)) ||
        &p_value  ||
	   -- draw the whole graph, then cut off the amount we drew before the # of cores
           substr(
	     rpad('+',round((cpu*&v_bars)/&v_secs),'+') ||
             rpad('o',round((io*&v_bars)/&v_secs),'o')  ||
             rpad('-',round((waits*&v_bars)/&v_secs),'-')  ||
             rpad(' ',&p_value * &v_bars,' '),(&p_value * &v_bars),( &v_graph-&v_bars*&p_value) )
        ,0,&v_graph)
        graph
     --  spct,
     --  decode(spct,null,null,second) second,
     --  tpct,
     --  decode(tpct,null,null,third) third
from (
select start_time
     , max(samples) samples
     , sum(top.total) total
     , round(max(decode(top.seq,1,pct,null)),2) fpct
     , substr(max(decode(top.seq,1,decode(top.event,'ON CPU','CPU',event),null)),0,15) first
     , round(max(decode(top.seq,2,pct,null)),2) spct
     , substr(max(decode(top.seq,2,decode(top.event,'ON CPU','CPU',event),null)),0,15) second
     , round(max(decode(top.seq,3,pct,null)),2) tpct
     , substr(max(decode(top.seq,3,decode(top.event,'ON CPU','CPU',event),null)),0,10) third
     , sum(waits) waits
     , sum(io) io
     , sum(cpu) cpu
from (
  select
       to_date(tday||' '||tmod*&v_secs,'YYMMDD SSSSS') start_time
     , event
     , total
     , row_number() over ( partition by id order by total desc ) seq
     , ratio_to_report( sum(total)) over ( partition by id ) pct
     , max(samples) samples
     , sum(decode(event,'ON CPU',total,0))    cpu
     , sum(decode(event,'ON CPU',0,
                        'db file sequential read',0,
                        'db file scattered read',0,
                        'db file parallel read',0,
                        'direct path read',0,
                        'direct path read temp',0,
                        'direct path write',0,
                        'direct path write temp',0, total)) waits
     , sum(decode(event,'db file sequential read',total,
                                  'db file scattered read',total,
                                  'db file parallel read',total,
                                  'direct path read',total,
                                  'direct path read temp',total,
                                  'direct path write',total,
                                  'direct path write temp',total, 0)) io
  from (
    select
         to_char(sample_time,'YYMMDD')                      tday
       , trunc(to_char(sample_time,'SSSSS')/&v_secs)          tmod
       , to_char(sample_time,'YYMMDD')||trunc(to_char(sample_time,'SSSSS')/&v_secs) id
       , decode(ash.session_state,'ON CPU','ON CPU',ash.event)     event
       , sum(decode(session_state,'ON CPU',10,decode(session_type,'BACKGROUND',0,10))) total
       , (max(sample_id)-min(sample_id)+1)                    samples
     from
        dba_hist_active_sess_history ash
     where
           sample_time > sysdate - &v_days and
        -- and sample_time < ( select min(sample_time) from v$active_session_history)
           dbid=&DBID
     group by  trunc(to_char(sample_time,'SSSSS')/&v_secs)
            ,  to_char(sample_time,'YYMMDD')
            ,  decode(ash.session_state,'ON CPU','ON CPU',ash.event)
  )  chunks
  group by id, tday, tmod, event, total
) top
group by start_time
) aveact
order by start_time
/

REM
PROMPT Will give snapshot time, events and avg_ms.....Check for avg_ms.......Enter start and end time in 'DD-MM-YY HH24:mi:SS' format based on the above graph..........
REM

set pagesize 100
col event_name format a30
col avg_ms format 99999.99
col ct format 999,999,999
select
       btime, event_name,
       (time_ms_end-time_ms_beg)/nullif(count_end-count_beg,0) avg_ms,
       (count_end-count_beg) ct
from (
select
       e.event_name,
       to_char(s.BEGIN_INTERVAL_TIME,'DD-MON-YY HH24:MI')  btime,
       total_waits count_end,
       time_waited_micro/1000 time_ms_end,
       Lag (e.time_waited_micro/1000)
              OVER( PARTITION BY e.event_name ORDER BY s.snap_id) time_ms_beg,
       Lag (e.total_waits)
              OVER( PARTITION BY e.event_name ORDER BY s.snap_id) count_beg
from
       DBA_HIST_SYSTEM_EVENT e,
       DBA_HIST_SNAPSHOT s
where
       s.snap_id=e.snap_id
   --and e.wait_class in ( 'User I/O', 'System I/O')
   -- and e.event_name in (  'db file sequential read',
   --                      'db file scattered read',
   --                      'db file parallel read',
   --                      'direct path read',
   --                      'direct path read temp',
   --                      'direct path write',
   --                     'direct path write temp')
   and e.event_name in (  'db file sequential read')
   and e.dbid=&DBID
   and e.dbid=s.dbid
order by e.event_name, begin_interval_time
)
where (count_end-count_beg) > 0
order by event_name,btime
/

REM
PROMPT Gives sql_id,event,plan_hash_value  cpu for sql_id run in the time interval...............
REM

col type for a16
col "CPU" for 9999999999.9
col "IO" for 9999999999.9
select * from (
select
     ash.SQL_ID , ash.SQL_PLAN_HASH_VALUE Plan_hash, aud.name type,
     ash.module,
     sum(decode(ash.session_state,'ON CPU',1,0))     "CPU",
     sum(decode(ash.session_state,'WAITING',1,0))    -
     sum(decode(ash.session_state,'WAITING', decode(wait_class, 'User I/O',1,0),0))    "WAIT" ,
     sum(decode(ash.session_state,'WAITING', decode(wait_class, 'User I/O',1,0),0))    "IO" ,
     sum(decode(ash.session_state,'ON CPU',1,1))     "TOTAL"
from dba_hist_active_sess_history ash,
     audit_actions aud
where SQL_ID is not NULL
   and ash.SAMPLE_TIME between  to_date ('&start_time','DD-MM-YY HH24:MI:SS') and to_date ('&end_time','DD-MM-YY HH24:MI:SS')
   and ash.dbid=&DBID
   and ash.sql_opcode=aud.action
group by sql_id, SQL_PLAN_HASH_VALUE, aud.name,ash.module
order by sum(decode(session_state,'ON CPU',1,1))   desc
) where  rownum < 20
/


REM
PROMPT Gives sql_id ordered by snap_time and buffer gets.....................
REM

col avg_elapsed_sec for 9,999,999,999.9
col disk for 9,999,999.99
col lio for 9,999,99999.99
col cpu_sec for 99,999,999.9
col io_time_sec for 9,999,999.9
col ap_time_sec for 9,999,999.9
col cc_time_sec for 9,999,999.9
select
 to_char(snap.begin_interval_time,'DD-MON-YYYY HH24:MI') ,
 sql.sql_id,
 (sum(ELAPSED_TIME_DELTA)/nullif(sum(EXECUTIONS_DELTA),0))/1000000  avg_elapsed_sec,
 sum(EXECUTIONS_DELTA)  execs,
 sum(DISK_READS_DELTA)/nullif(sum(EXECUTIONS_DELTA),0)  disk,
 sum(BUFFER_GETS_DELTA)/nullif(sum(EXECUTIONS_DELTA),0) lio,
 sum(ROWS_PROCESSED_DELTA)/nullif(sum(EXECUTIONS_DELTA),0) rws,
 (sum(CPU_TIME_DELTA)/nullif(sum(EXECUTIONS_DELTA),0))/1000000       cpu_sec,
 (sum(IOWAIT_DELTA)/nullif(sum(EXECUTIONS_DELTA),0))/1000000         io_time_sec,
 (sum(APWAIT_DELTA)/nullif(sum(EXECUTIONS_DELTA),0))/1000000         ap_time_sec,
 (sum(CCWAIT_DELTA)/nullif(sum(EXECUTIONS_DELTA),0))/1000000         cc_time_sec,
 sum(DIRECT_WRITES_DELTA)/nullif(sum(EXECUTIONS_DELTA),0)  dio,
 sum(PHYSICAL_READ_REQUESTS_DELTA)/nullif(sum(EXECUTIONS_DELTA),0) reads,
 sum(PHYSICAL_WRITE_REQUESTS_DELTA)/nullif(sum(EXECUTIONS_DELTA),0) write
 from dba_hist_sqlstat sql,
     dba_hist_snapshot snap
where
snap.begin_interval_time between  to_date ('&start_time','DD-MM-YY HH24:MI:SS') and to_date ('&end_time','DD-MM-YY HH24:MI:SS')
and sql.dbid=&dbid
and sql.dbid=snap.dbid
and snap.snap_id=sql.snap_id
group by to_char(snap.begin_interval_time,'DD-MON-YYYY HH24:MI'),sql.sql_id
order by 1,6
/

REM
PROMPT sql full text..........enter sql_id.............
REM

set long 10000
select sql_text from dba_hist_sqltext where sql_id = '&1' and rownum < 2
/

@sqlhist
