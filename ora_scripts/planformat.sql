set feedback on
accept plan_name Prompt 'Enter plan_name:- '
with plan as
(
        select rownum rnum,PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>'&plan_name'))
)
select
        trim(substr(plan_table_output,10))
from
        plan
where
        rnum>=4
and
        rnum < (select min(rnum) from plan where plan_table_output like '---------------------------------------------------%' and rnum>4) ;

undef plan_name

