select
   snap_id,
   to_char(begin_interval_time,'YYYY-MM-DD HH24:MI') as begin_hour,
   module,
   sql_id,
   executions_total,
   executions_delta
from
   dba_hist_snapshot natural join dba_hist_sqlstat
where
   module = '&mod_name'
and
   begin_interval_time > sysdate-&num_days
order by
   snap_id
;
