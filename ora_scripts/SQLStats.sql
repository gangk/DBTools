set lines 500
set pages 500 feedback on
set long 999999999
col "io wait" for 999999999999999
col sql_text for a500
col Operation for a30
col options for a40
col Optimal/onepass/Multipass for a15
accept mysql prompt 'enter sql_id :- '

select
        sum(disk_reads)"phy_io",
        sum(buffer_gets) "logical_io",
        sum(executions) "executions",
        round( sum(disk_reads)/sum(executions), 1) "phy/exe",
        round( sum(buffer_gets)/sum(executions), 1) "log/exec",
        round( sum(APPLICATION_WAIT_TIME)/sum(executions)/1000000, 1) "appwait/exec",
	round( sum(CONCURRENCY_WAIT_TIME)/sum(executions)/1000000, 1) "concurr_wait/exec",
	round( sum(USER_IO_WAIT_TIME)/sum(executions)/1000000, 1) "iowait/exec Secs",
	round( sum(CPU_TIME)/sum(executions)/1000000, 1) "cpu/exec",
        round( sum(ELAPSED_TIME)/sum(executions)/1000000, 1) "elap/exec"
from
        v$sql
where
        sql_id='&mysql';

undef mysql
