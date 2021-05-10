select  BEGIN_INTERVAL_TIME,
	sql_id,
	plan_hash_value,
	MODULE,
	sum(EXECUTIONS_DELTA) "Executions"
	from 	dba_hist_sqlstat, dba_hist_snapshot
where 	module = '&module_name'
and 	dba_hist_sqlstat.snap_id=dba_hist_snapshot.snap_id
and     BEGIN_INTERVAL_TIME > to_date ('&start_time','DD-MM-YY HH24:MI')
and     END_INTERVAL_TIME < to_date ('&start_time','DD-MM-YY HH24:MI')
group by BEGIN_INTERVAL_TIME, sql_id, plan_hash_value, MODULE order by 1;
