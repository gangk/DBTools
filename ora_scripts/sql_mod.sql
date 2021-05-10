
------------------------------------------------------------------------
-- The SQL finds out SQLs stored in memory for a particular module
------------------------------------------------------------------------
accept module_like prompt 'Enter module_like : '
set linesize 200
set trimspool on
set long 99999
col SQL_TEXT format A40 WORD_WRAP
undefine SearchString
col BUFFER_GETS format 999,999,999,999 noprint
col DISK_READS format 999,999,999,999 noprint
col GETS_PER_EXEC format 999,999,999 heading "Gets|/exec"
col READS_PER_EXEC format 999,999 heading "Disk Reads|/exec"
col ELAPSE_PER_EXEC format 9,999.99 heading "Elapsed|/exec|( sec )"
col ELAPSED_TIME format 999,999 heading "Elap|(secs)" noprint
col FIRST_LOAD_TIME noprint
col SQL_PROFILE format A5 trunc heading "SQL|Prof"
col SQL_PLAN_BASELINE format A5 trunc heading "SQL|Base"
col MODULE format A25 trunc print
col COMMAND_TYPE format 99 heading "Type"
col EXECUTIONS format 999,999 heading "Execs"

select module, LAST_ACTIVE_TIME, SQL_ID, SQL_TEXT, COMMAND_TYPE,
EXECUTIONS, round(BUFFER_GETS/decode(EXECUTIONS,0,1, EXECUTIONS )) GETS_PER_EXEC,  
-- round(DISK_READS/decode(EXECUTIONS,0,1, EXECUTIONS )) READS_PER_EXEC, 
round( round( ELAPSED_TIME / 1000000) / decode(EXECUTIONS,0,1, EXECUTIONS ),2)  ELAPSE_PER_EXEC,
SQL_PROFILE, SQL_PLAN_BASELINE
from gv$SQLAREA where module like '%&module_like%' 
order by EXECUTIONS, LAST_ACTIVE_TIME ;
