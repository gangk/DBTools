column sql_id format a15
column elapsed_time_secs format 9,999,999
column Rows_per_exec format 999,999.99
column Sec_per_exec format 9,999,999.999
column Buffgets_per_exec format 99,999,999
column sql_profile format a30
select
        sql_id
	,inst_id
        ,plan_hash_value
        ,executions
        ,(elapsed_time / executions) / 1000000 as Sec_per_exec
        ,(rows_processed / executions) Rows_per_exec
        ,(buffer_gets / executions) Buffgets_per_exec
        ,sql_profile
from
        gv$sql
where
        sql_id = '&&1'
;

