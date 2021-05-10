undef last_x_mins
@plusenv

col tcnt for 9999
col aas for 999.99
-- col sql_id for
col cnt for 999
col pct for 999
col obj for a20
col sub_obj for a10
col otype for a15
col event for a15
col file# for 9999
col tablespace_name for a15

break on sql_id on aas on tcnt

select
       --sum(cnt) over ( partition by io.sql_id order by sql_id ) tcnt,
       round(sum(cnt) over ( partition by io.sql_id order by sql_id ) / (&v_minutes*60),2) aas,
       io.sql_id,
       --io.cnt cnt,
       100*cnt/sum(cnt) over ( partition by io.sql_id order by sql_id ) pct,
       --CURRENT_OBJ#  obj#,
       o.object_name obj,
       o.subobject_name sub_obj,
       o.object_type otype,
       substr(io.event,8,10) event,
       io.p1 file#,
       f.tablespace_name tablespace_name,
       tbs.contents
from
(
  select
        sql_id,
  event,
        count(*) cnt,
        count(*) / (&v_minutes*60) aas,
        CURRENT_OBJ# ,
        ash.p1
   from v$active_session_history ash
   where ( event like 'db file s%' or event like 'direct%' )
      and sample_time > sysdate - &&last_x_mins/(60*24)
   group by
       CURRENT_OBJ#,
       event,
       --o.object_name ,
       --o.object_type ,
       ash.p1,
       sql_id
) io,
   dba_data_files f
   ,all_objects o
   , dba_tablespaces tbs
where
   f.file_id = io.p1
   and o.object_id (+)= io.CURRENT_OBJ#
   and tbs.tablespace_name= f.tablespace_name
Order by 
        --tcnt, 
          sql_id, cnt
/
clear breaks
