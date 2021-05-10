set line 999
set pagesize 9999

-- SQL order by buffer_gets/exec

col BUFFER_GETS/EXEC format 999,999,999,999
col module format a40
col BUFFER_GETS/EXEC heading "BUFFER_GETS|/EXEC"
col CPU_TIME/EXEC heading "CPU_TIME|/EXEC"
col "ELAPSED_TIME/EXEC (sec)" heading "ELAPSED_TIME|/EXEC(sec)"
col DISK_READS/EXEC heading "DISK_READS|/EXEC"
select *
from  (select SQL_ID,
              PLAN_HASH_VALUE,
              MODULE,
              EXECUTIONS,
              round(BUFFER_GETS/decode(EXECUTIONS,0,1,EXECUTIONS)) "BUFFER_GETS/EXEC",
              round(CPU_TIME/(decode(EXECUTIONS,0,1,EXECUTIONS)*1000000)) "CPU_TIME/EXEC",
              round(ELAPSED_TIME/(decode(EXECUTIONS,0,1,EXECUTIONS)*1000000)) "ELAPSED_TIME/EXEC (sec)",
              VERSION_COUNT,
              round(DISK_READS/decode(EXECUTIONS,0,1,EXECUTIONS)) "DISK_READS/EXEC"
       from v$sqlarea
       where executions > 100
       order by 5 desc)
where rownum < 51;

prompt Top IO Real Time
prompt ----------------

select *
from  (select a.SQL_ID,
              a.PLAN_HASH_VALUE,
              a.MODULE,
              a.EXECUTIONS,
              round(a.BUFFER_GETS/decode(a.EXECUTIONS,0,1,a.EXECUTIONS)) "BUFFER_GETS/EXEC",
              round(a.CPU_TIME/(decode(a.EXECUTIONS,0,1,a.EXECUTIONS)*1000000)) "CPU_TIME/EXEC",
              round(a.ELAPSED_TIME/(decode(a.EXECUTIONS,0,1,a.EXECUTIONS)*1000000)) "ELAPSED_TIME/EXEC (sec)",
              round(a.DISK_READS/decode(a.EXECUTIONS,0,1,a.EXECUTIONS)) "DISK_READS/EXEC"
       from v$sql a, v$session b
        where a.sql_id = b.sql_id
        and b.status = 'ACTIVE'
       order by 5 desc)
where rownum < 21;

