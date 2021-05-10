Def v_days=1 -- amount of time
Def v_secs=60 -- size of bucket
Def v_bars=5 -- size of one AAS
Def v_graph=30 -- width of graph

col graph format a&v_graph
col aas format 999.99
col total format 99999
col npts format 99999
col waits for 9999
col cpu for 9999

/*
      dba_hist_active_sess_history
*/

select
        to_char(to_date(tday||' '||tmod*&v_secs,'YYMMDD SSSSS'),'DD-MON  HH24:MI:SS') tm,
        samples npts,
        total/&v_secs aas,
        substr(
        substr(substr(rpad('+',round((cpu*&v_bars)/&v_secs),'+') ||
        rpad('-',round((waits*&v_bars)/&v_secs),'-')  ||
        rpad(' ',p.value * &v_bars,' '),0,(p.value * &v_bars)) ||
        p.value  ||
        substr(rpad('+',round((cpu*&v_bars)/&v_secs),'+') ||
        rpad('-',round((waits*&v_bars)/&v_secs),'-')  ||
        rpad(' ',p.value * &v_bars,' '),(p.value * &v_bars),10) ,0,30)
        ,0,&v_graph)
        graph,
        -- total,
        cpu,
        waits
from (
   select
       to_char(sample_time,'YYMMDD')                   tday
     , trunc(to_char(sample_time,'SSSSS')/&v_secs) tmod
     , sum(decode(session_state,'ON CPU',1,decode(session_type,'BACKGROUND',0,1)))  total
     , (max(sample_id) - min(sample_id) + 1 )      samples
     , sum(decode(session_state,'ON CPU' ,1,0))    cpu
     , sum(decode(session_state,'WAITING',1,0)) -
       sum(decode(session_type,'BACKGROUND',decode(session_state,'WAITING',1,0)))    waits
       /* for waits I want to subtract out the BACKGROUND
          but for CPU I want to count everyon */
   from
      v$active_session_history
   where sample_time > sysdate - &v_days
   group by  trunc(to_char(sample_time,'SSSSS')/&v_secs),
             to_char(sample_time,'YYMMDD')
union all
   select
       to_char(sample_time,'YYMMDD')                   tday
     , trunc(to_char(sample_time,'SSSSS')/&v_secs) tmod
     , sum(decode(session_state,'ON CPU',1,decode(session_type,'BACKGROUND',0,1)))  total
     , (max(sample_id) - min(sample_id) + 1 )      samples
     , sum(decode(session_state,'ON CPU' ,10,0))    cpu
     , sum(decode(session_state,'WAITING',10,0)) -
       sum(decode(session_type,'BACKGROUND',decode(session_state,'WAITING',10,0)))    waits
       /* for waits I want to subtract out the BACKGROUND
          but for CPU I want to count everyon */
   from
      dba_hist_active_sess_history
   where sample_time > sysdate - &v_days
   and sample_time < (select min(sample_time) from v$active_session_history)
   group by  trunc(to_char(sample_time,'SSSSS')/&v_secs),
             to_char(sample_time,'YYMMDD')
) ash,
  v$parameter p
where p.name='cpu_count'
order by to_date(tday||' '||tmod*&v_secs,'YYMMDD SSSSS')
/

