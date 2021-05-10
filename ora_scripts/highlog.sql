set pagesize 60
set linesize 500
col sql_id for a13
col buffer_gets_per_exec for 9999999999
col buffer_gets for 999999999999
col executions for 9999999
col module for a30
col sql_text for a80
select * from (select sql_id,cast(buffer_gets/(executions+1) as integer) as buffer_gets_per_exec,buffer_gets,executions,module,substr(sql_text,1,80)
from V$SQLAREA where buffer_gets/(executions+1) > 1 and executions > 1 order by buffer_gets/(executions+1) desc ) where rownum <21;

