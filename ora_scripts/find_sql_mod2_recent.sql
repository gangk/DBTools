
-------------------------------------------------------
-- Find SQL based on either TEXT / SQL_ID
-------------------------------------------------------
undefine sql_id
undefine sql_text
undefine module
accept look_back_min prompt 'Look back minutes ( default 1 ) : ' default 1
accept module prompt 'enter module like :- '
accept sql_text prompt '(optional) enter sql text like :- '
accept sql_id prompt '(optional) enter sql_id :- '
col module format A40 word_wrap print
col SQL_TEXT format A60 WORD_WRAP
col child_number format 999 heading "Child"
col total_executions format 999,999,999,999

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
   and last_active_time >= sysdate - ( &&look_back_min / 1440 )
group by
   module 
order by 5 ;

prompt NOTE : overall_avg_etime is in seconds.
prompt 
prompt Enter to see details of the sqls for the above modules; <Ctrol-C> to Cancel
prompt 
pause
break on module skip 1 duplicate
col last_active_since format A16
select 
   sql_id, executions, child_number, plan_hash_value, module, 
   round( (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions), 2)  avg_etime,
        trunc( SYSDATE - last_active_time ) || 'd, ' ||
        trunc( ( ( SYSDATE - last_active_time ) - trunc( SYSDATE - last_active_time ) ) * 24 ) || 'h, ' ||
        trunc( (( SYSDATE - last_active_time )* 24 -  trunc(( SYSDATE - last_active_time )* 24) ) * 60) || 'm, '  ||
        trunc(MOD((SYSDATE - last_active_time)*24*60*60, 60)) || 's' last_active_since,
   round( buffer_gets/decode(nvl(executions,0),0,1,executions) ) avg_lio, SQL_PLAN_BASELINE
from 
   v$sql s
where 
   upper(sql_text) like upper(nvl('%&sql_text%',sql_text))
   and sql_text not like '%from v$sql where sql_text like nvl(%'
   and upper(module) like upper( nvl('%&module%',module) )
   and sql_id like nvl('&sql_id',sql_id)
   and last_active_time >= sysdate - ( &&look_back_min / 1440 )
order by 
   5,8 ;

clear breaks

