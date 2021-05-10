col object_name for a20
col object_type for a12
col event for a20

select do.object_name,
      do.object_type,
      ash.event,
      sum(ash.wait_time +
      ash.time_waited) ttl_wait_time
from v$active_session_history ash, dba_objects do
where ash.sample_time between sysdate - 60/2880 and sysdate
and ash.current_obj# = do.object_id
and ash.event like '%enq: TX - index contention%'
group by do.object_name, do.object_type,
ash.event
order by 4
/