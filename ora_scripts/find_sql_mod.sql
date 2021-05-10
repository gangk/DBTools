
-------------------------------------------------------
-- Find SQL based on either TEXT / SQL_ID
-------------------------------------------------------
undefine sql_id
undefine sql_text
undefine module
accept module prompt 'enter module like :- '
accept sql_text prompt '(optional) enter sql text like :- '
accept sql_id prompt '(optional) enter sql_id :- '
col module format A40 word_wrap print
col SQL_TEXT format A60 WORD_WRAP
col child_number format 999 heading "Child"
col total_executions format 999,999,999,999

prompt 
prompt  Summary by module
prompt
select 
   module, count(distinct sql_id) distinct_sql, sum(executions) total_executions, 
   avg( round( (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions), 2))  overall_avg_etime,
   avg( round( buffer_gets/decode(nvl(executions,0),0,1,executions) ) ) overall_avg_lio
from 
   v$sql s
where 
   upper(sql_text) like upper(nvl('%&sql_text%',sql_text))
   and sql_text not like '%from v$sql where sql_text like nvl(%'
   and upper(module) like upper( nvl('%&module%',module) )
   and sql_id like nvl('&sql_id',sql_id)
group by
   module ;

prompt NOTE : overall_avg_etime is in seconds.
prompt 
prompt Enter to see details of the sqls for the above modules; <Ctrol-C> to Cancel
prompt 
pause
select 
   sql_id, child_number, module, executions execs,
   round( (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions), 2)  avg_etime,
   round( buffer_gets/decode(nvl(executions,0),0,1,executions) ) avg_lio, sql_text
from 
   v$sql s
where 
   upper(sql_text) like upper(nvl('%&sql_text%',sql_text))
   and sql_text not like '%from v$sql where sql_text like nvl(%'
   and upper(module) like upper( nvl('%&module%',module) )
   and sql_id like nvl('&sql_id',sql_id)
order by 
   3,6 ;

