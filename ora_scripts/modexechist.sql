accept num_days prompt 'Enter number of days:- '
col BEGIN_INTERVAL_TIME format a30
col module format a50;
set line 999
set pagesize 999
set verify off;

prompt ========
prompt History
prompt ========

select  BEGIN_INTERVAL_TIME,
	module,
        sql_id,
	sum(EXECUTIONS_DELTA) "Executions",
	sum(ELAPSED_TIME_DELTA)/decode(nvl(sum(EXECUTIONS_DELTA),0),0,1,nvl(sum(EXECUTIONS_DELTA),0)) "Elapsed_time/exec"
from 	dba_hist_sqlstat, dba_hist_snapshot
where   dba_hist_sqlstat.snap_id=dba_hist_snapshot.snap_id
and     BEGIN_INTERVAL_TIME > (sysdate - &num_days)
and     sql_id in ('3rn0xa1v9hmhr','3sn86ay9zg7n3','8a586zukdfgsm','anr1na1m9fb9x')
group by BEGIN_INTERVAL_TIME,  MODULE, sql_id order by 1,2,3;
