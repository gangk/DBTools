col objn for a28


select
       count(*) cnt,
       CURRENT_OBJ#||' '||o.object_name objn,
       o.object_type otype
from v$active_session_history ash,
      all_objects o
where ( event like 'db file s%' or event like 'direct%' )
   and o.object_id (+)= ash.CURRENT_OBJ#
   and sample_time > sysdate - &1/(60*24)
   and session_state='WAITING'
group by
       CURRENT_OBJ#, o.object_name ,
       o.object_type
Order by count(*)
/