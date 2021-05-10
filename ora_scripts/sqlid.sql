--------------------------------------------------------------------------------
--
-- File name:   sqlid.sql
-- Purpose:     Display available statistics in memory for given sqlid 
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @sqlid <sql_id>
--------------------------------------------------------------------------------


col sql_sql_text head SQL_TEXT format a150 word_wrap
col sql_child_number head CH# for 999
col opt_cost for 99999999999999

select  
	sql_id,
	hash_value,
	---child_number	sql_child_number,    
	sql_text sql_sql_text
from 
	v$sql 
where 
	sql_id = ('&1')
	and rownum<2 -- added to avoid too much output because of multiple cursors
order by
	sql_id,
	hash_value,
	child_number
/

select 
	child_number	sql_child_number,
	address		parent_handle,
	child_address   object_handle,
	plan_hash_value plan_hash,
	OPTIMIZER_COST opt_cost,
	parse_calls parses,
	loads h_parses,
	executions,
	fetches,
	rows_processed,
	cpu_time/1000 cpu_ms,
	elapsed_time/1000 ela_ms,
	(elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_ela,
	buffer_gets LIOS,
	disk_reads PIOS,
	sorts, 
--	address,
--	sharable_mem,
--	persistent_mem,
--	runtime_mem,
	users_executing
from 
	v$sql 
where 
	sql_id = ('&1')
order by
	sql_id,
	hash_value,
	child_number
/

