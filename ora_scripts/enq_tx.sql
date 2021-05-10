
col event for a22
col block_type for a18
col objn for a18
col otype for a10
col fn for 99
col sid for 9999
col bsid for 9999
col lm for 99
col p3 for 99999
col blockn for 99999
select
       to_char(sample_time,'HH:MI') st,
       substr(event,0,20) event,
       ash.session_id sid,
       mod(ash.p1,16)  lm,
       ash.p2,
       ash.p3, 
       nvl(o.object_name,ash.current_obj#) objn,
       substr(o.object_type,0,10) otype,
       CURRENT_FILE# fn,
       CURRENT_BLOCK# blockn, 
       ash.SQL_ID,
       BLOCKING_SESSION bsid
from v$active_session_history ash,
      all_objects o
where event like 'enq: TX%'
   and o.object_id (+)= ash.CURRENT_OBJ#
   and sample_time > sysdate - 40/(60*24)
Order by sample_time
/
