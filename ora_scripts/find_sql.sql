
-------------------------------------------------------
-- Find SQL based on either TEXT / SQL_ID
-------------------------------------------------------
prompt
prompt == Find sql from V$sql.SQL_TEXT which is VARCHAR2(1000). Accuarate find should be from SQL_FULLTEXT ( CLOB ) ==
prompt
undefine sql_id
undefine sql_text
col SQL_TEXT format A80 WORD_WRAP
col child_number format 999 heading "Child"
select 
   sql_id, child_number, plan_hash_value plan_hash, executions execs,
   round( (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions), 2)  avg_etime,
   round( buffer_gets/decode(nvl(executions,0),0,1,executions) ) avg_lio, sql_text
from 
   v$sql s
where 
   upper(sql_text) like upper(nvl('%&sql_text%',sql_text))
   and sql_text not like '%from v$sql where sql_text like nvl(%'
   and sql_id like nvl('&sql_id',sql_id)
order by 
   1, 2, 3 ;

