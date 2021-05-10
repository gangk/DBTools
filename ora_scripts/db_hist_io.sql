select * from 
(
SELECT /*+LEADING(x h) USE_NL(h)*/ 
       h.sql_id
,       h.sql_plan_hash_value
,      SUM(20) ash_secs
FROM   dba_hist_snapshot x
,      dba_hist_active_sess_history h
WHERE   x.begin_interval_time > sysdate -1
AND    h.SNAP_id = X.SNAP_id
AND    h.dbid = x.dbid
AND    h.instance_number = x.instance_number
AND    h.event in  ('db file sequential read','db file scattered read', 'direct path read' )
GROUP BY h.sql_id, h.sql_plan_hash_value
ORDER BY ash_secs desc )
where rownum<20;
