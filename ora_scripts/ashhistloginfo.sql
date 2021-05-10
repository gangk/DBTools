col snap_id for 99999
col begin_interval_time for a25
col end_interval_time for a25
col sql_id for a13
col plan for 9999999999
col execs for 999999
col Buf for 999999999
col IO for 999999999
col cpu for 9999
col elap for 9999
col iowait for 9999
col module for a20
select * from
(select
	ss.snap_id,ss.begin_interval_time,ss.end_interval_time,sql_id,plan_hash_value plan,sum(nvl(executions_delta,0)) execs,sum(buffer_gets_delta) "Buf",sum(disk_reads_delta) "IO",sum(cpu_time_delta)/1000000 "cpu",sum(elapsed_time_delta)/1000000 "elap",sum(iowait_delta)/1000000 "iowait" ,sum(buffer_gets_delta)/sum(executions_delta) "Avg log",sum(disk_reads_delta)/sum(executions_delta) "avg IO",substr(module,1,20) module
from
	dba_hist_sqlstat s,dba_hist_snapshot ss
where
	s.snap_id=ss.snap_id
and
	s.snap_id between &begin_snap and &end_snap
and
	module is not null
group by 
	ss.snap_id,ss.begin_interval_time,ss.end_interval_time,sql_id,plan_hash_value,module
having
	sum(executions_delta)>=1
order by 
	sum(buffer_gets_delta) desc
) where rownum <41;
