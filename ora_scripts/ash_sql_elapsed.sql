col mx for 999999
col mn for 999999
col av for 999999.9
 
select
       sql_id,
       count(*),
       max(tm) mx,
       avg(tm) av,
       min(tm) min
from (
   select
        sql_id,
        sql_exec_id,
        max(tm) tm
   from ( select
              sql_id,
              sql_exec_id,
              ((cast(sample_time as date)) -
              (cast(sql_exec_start as date))) * (3600*24) tm
           from
              dba_hist_active_sess_history
           where sql_exec_id is not null
    )
   group by sql_id,sql_exec_id
   )
group by sql_id
having count(*) > 10
order by mx,av
/

