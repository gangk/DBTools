set long 999999999
set pagesize 999
set line 999
set verify off;
set feedback on;

accept SQL_ID prompt 'Enter SQL ID :- '

prompt ================
prompt SQL STAT
prompt ================

select sql_id, PLAN_HASH_VALUE "Plan Hash", EXECUTIONS, DISK_READS/EXECUTIONS "Disk Reads/exec", BUFFER_GETS/EXECUTIONS "Buffer Gets/exec", VERSION_COUNT "Version Count", ELAPSED_TIME/(EXECUTIONS*1
000000) "Elapsed Time(sec)/exec", SORTS/EXECUTIONS "Sorts/exec", SHARABLE_MEM "Current Mem used", TOTAL_SHARABLE_MEM "Max Shared Memory"
from v$sqlstats
where sql_id = '&SQL_ID';


prompt ===============
prompt TIME STATS
prompt ===============

col APPLICATION_WAIT_TIME/1000000 heading "App|wait|(sec)"
col CONCURRENCY_WAIT_TIME/1000000 heading "Conc|wait|(sec)"
col USER_IO_WAIT_TIME/1000000 heading "io|wait|(sec)"
col ELAPSED_TIME/(EXECUTIONS*1000000) heading "Elapsed Time|/exec"
col CPU_TIME/(EXECUTIONS*1000000) heading "CPU Time|/exec"


select SQL_ID, PLAN_HASH_VALUE, EXECUTIONS , APPLICATION_WAIT_TIME/1000000, CONCURRENCY_WAIT_TIME/1000000, USER_IO_WAIT_TIME/1000000,  ELAPSED_TIME/(EXECUTIONS*1000000), CPU_TIME/(EXECUTIONS*100000
0), decode(COMMAND_TYPE, 1, 'CREATE', 2, 'INSERT', 3, 'SELECT', 6, 'UPDATE', 7, 'DELETE', 9, 'CREATE IDX', 11, 'ALT IDX', 26, 'LOCK TABLE', 42, 'ALT SESS', 44, 'COMMIT', 45, 'ROLLBACK', 46, 'SAVEPO
INT', 47, 'PLSQL', 48, 'SET TRANS', 50, 'EXPLAIN', 62, 'ANAL TAB', 90, 'SET CONSTRAINT', 170, 'CALL', 189, 'MERGE', 'UNKNOWN' ) COMMAND, SQL_PLAN_BASELINE from v$sqlarea where sql_id = '&SQL_ID';

prompt ===============
prompt PLAN FLIPS
prompt ===============

select distinct sql_id , plan_hash_value , TIME, COST, CPU_COST, IO_COST, TIMESTAMP, sysdate from dba_hist_sql_plan where sql_id = '&SQL_ID' order by timestamp;

prompt ==============
prompt SESS STATS
prompt ==============

col module format a30;
col username format a10;
col pq_status format a10;
col "BLOCKING_SESSION" heading "Blocking|session"
col event format a30
select sid, serial#, module, status, username, ROW_WAIT_OBJ#, PQ_STATUS, EVENT, last_call_et, BLOCKING_SESSION from v$session where sql_id = '&SQL_ID';

prompt ==============
prompt SORT STATS
prompt ==============

select sql_id, CHILD_NUMBER, OPERATION_TYPE, TOTAL_EXECUTIONS, OPTIMAL_EXECUTIONS, ONEPASS_EXECUTIONS, MULTIPASSES_EXECUTIONS, LAST_EXECUTION from v$sql_workarea where sql_id = '&SQL_ID';


select module, child_number, sql_fulltext "SQL Full Text" from v$sql where sql_id = '&SQL_ID' and child_number = (select max(child_number) from v$sql where sql_id = '&SQL_ID');

var v_child_number number;

begin
select max(CHILD_NUMBER) into :v_child_number from v$sql where sql_id = '&SQL_ID';
end;
/



SELECT * FROM TABLE(dbms_xplan.display_cursor('&SQL_ID',:v_child_number));


set line 80
