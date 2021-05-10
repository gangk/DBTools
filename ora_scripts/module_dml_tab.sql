col module for a30
select sql_id, plan_hash_value,command_type, module, round(buffer_gets/decode(nvl(executions,0),0,1,executions)) "Buff_gets/exce", round(disk_reads/decode(nvl(executions,0),0,1,executions)) "disk_reads/exec",round(ELAPSED_TIME/(decode(nvl(executions,0),0,1,executions) * 1000000)) "Elapsed_time/exec", round(CPU_TIME/(decode(nvl(executions,0),0,1,executions) * 1000000)) "CPU_time/exec", executions,LAST_LOAD_TIME from v$sqlarea where module ='&module_name' and command_type in (2,6,7) and sql_text like '%&tab_name%';
