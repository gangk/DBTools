break on object_name skip 0
compute sum of exec on object_name
compute sum of cpu_time_per_exec_ms on object_name
compute sum of elap_time_per_exec_ms on object_name
compute sum of disk_read_per_exec on object_name
compute sum of bg_per_exec on object_name
compute sum of pr_per_exec on object_name
select distinct b.object_name,
                a.sql_id, 
                decode(command_type,3,'SEL',6,'UPD',7,'DEL','UNKNOWN') "cmd_type", 
                round(CPU_TIME/decode(nvl(executions,1),0,1,executions)/1000) "cpu_per_exec_ms", 
                round(ELAPSED_TIME/decode(nvl(executions,1),0,1,executions)/1000) "elap_per_exec_ms",
                round(DISK_READS/decode(nvl(executions,1),0,1,executions)) "disk_read_per_exec", 
                round(BUFFER_GETS/decode(nvl(executions,1),0,1,executions)) "bg_per_exec", 
                round(PHYSICAL_READ_BYTES/decode(nvl(executions,1),0,1,executions)) "pr_per_exec", 
                decode(nvl(executions,1),0,1,executions) exec
from    v$sql a, v$sql_plan b
where   a.sql_id = b.sql_id
and     a.PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER'
and     a.executions > 10
order by 1, round(BUFFER_GETS/decode(nvl(executions,1),0,1,executions))*decode(nvl(executions,1),0,1,executions);

-- CPU utilization by Inbound Dock Services

COLUMN DUMMY NOPRINT
with total_cpu as
(select sum(round(CPU_TIME)) sum_cpu
from v$sqlstats
where sql_id in (select distinct sql_id from v$sql_plan where sql_id in (select sql_id from v$sql where PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER'))
)
select 	' ' DUMMY, a.sql_id,
		c.object_name,
		round(CPU_TIME) "cpu_per_exec",
		sum_cpu,
		round(CPU_TIME)*100/sum_cpu pct_cpu
from 	v$sqlstats a, total_cpu b, v$sql_plan c
where 	a.sql_id in (select distinct sql_id from v$sql where PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER')
and 	a.sql_id = c.sql_id
and 	c.object_name is not null
order by 6 desc;

-- IO utilization by Inbound Dock Services

COLUMN DUMMY NOPRINT
compute sum of pct_io on DUMMY
break on SQL_ID
with total_cpu as
(select sum(round(PHYSICAL_READ_BYTES)) sum_io
from v$sqlstats
where sql_id in (select distinct sql_id from v$sql_plan where sql_id in (select sql_id from v$sql where PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER'))
)
select  ' ' DUMMY, a.sql_id,
                c.object_name,
                round(PHYSICAL_READ_BYTES) "IO_exec",
                sum_io,
                round(PHYSICAL_READ_BYTES)*100/sum_io pct_io
from    v$sqlstats a, total_cpu b, v$sql_plan c
where   a.sql_id in (select distinct sql_id from v$sql where PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER')
and     a.sql_id = c.sql_id
and     c.object_name is not null
order by 6 desc;

-- Cyber Monday 2015 - CPU

break on SQL_ID
with total_cpu as
(select sum(round(CPU_TIME_DELTA)) sum_cpu
from dba_hist_sqlstat
where PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER'
and snap_id >= 175862
and snap_id <= 175892
)
select 	a.sql_id,
		sum(CPU_TIME_DELTA) "cpu_per_exec",
		c.object_name, 
		sum(CPU_TIME_DELTA)*100/sum_cpu pct_cpu
from 	awr_2015.dba_hist_sqlstat a, total_cpu b, v$sql_plan c
where 	a.PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER'
and 	a.snap_id >= 175862
and 	a.snap_id <= 175892
and 	a.sql_id = c.sql_id
and 	c.object_name is not null
group by a.sql_id, c.object_name, sum_cpu
order by 4 desc;


-- Cyber Monday 2015 - IOPS

break on SQL_ID
with total_iops as
(select sum(round(PHYSICAL_READ_BYTES_DELTA+PHYSICAL_WRITE_BYTES_DELTA)) sum_iops
from dba_hist_sqlstat
where PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER'
and snap_id >= 175386
and snap_id <= 175422
)
select 	a.sql_id,
		sum(PHYSICAL_READ_BYTES_DELTA+PHYSICAL_WRITE_BYTES_DELTA) "iops_per_exec",
		c.object_name, 
		sum(PHYSICAL_READ_BYTES_DELTA+PHYSICAL_WRITE_BYTES_DELTA)*100/sum_iops pct_iops
from 	awr_2015.dba_hist_sqlstat a, total_iops b, v$sql_plan c
where 	a.PARSING_SCHEMA_NAME = 'AFT_INBOUNDDOCK_USER'
and 	a.snap_id >= 175386
and 	a.snap_id <= 175422
and 	a.sql_id = c.sql_id
and 	c.object_name is not null
group by a.sql_id, c.object_name, sum_iops
order by 4 desc;
