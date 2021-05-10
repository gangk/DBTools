col block_type for a18
col objn for a25
col otype for a15
col cache for a20
select
       ash.p1,
       ash.p2,
       ash.p3,
       CURRENT_OBJ#||' '||o.object_name objn,
       o.object_type otype,
       CURRENT_FILE# filen,
       CURRENT_BLOCK# blockn,
       ash.SQL_ID,
       rc.parameter ||' '||to_char(ash.p1) cache
from v$active_session_history ash,
     ( select cache#, parameter from v$rowcache ) rc,
      all_objects o
where event='row cache lock'
   and rc.cache#(+)=ash.p1
   and o.object_id (+)= ash.CURRENT_OBJ#
Order by sample_time
/