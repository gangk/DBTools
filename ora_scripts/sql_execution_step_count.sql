select sql_plan_line_id , count(*)
from dba_hist_active_sess_history
where 
    sql_id = '36cqamjv9p9nu'
and sample_time
        between to_date('05/20/2013:22:00:00','MM/DD/YYYY:HH24:MI:SS')
        and to_date('05/15/2013:10:00:00','MM/DD/YYYY:HH24:MI:SS')
group by sql_plan_line_id
order by 1
/
