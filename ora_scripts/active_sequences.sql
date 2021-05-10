set lines 170
col seq			format a40		head 'Sequence'
col limit31    		format 9,999,999,999	head '2^31 value'
col cache		format 9999999
col limit32    		format 9,999,999,999	head '2^32 value'
col last_number 	format 9,999,999,999,999	head 'Last'
col increment_by	format 999		head 'Incr'
col entries_left	format 999,999,999,999
select 	 sequence_owner||'.'||sequence_name	seq
	,cache_size	cache
--,power(2,31)	limit31
--,power(2,32)	limit32
	,last_number
	,increment_by 
--,round((power(2,32)-last_number)/increment_by)	entries_left
from dba_sequences 
where sequence_owner not in ('SYS','SYSTEM')
and	 last_number	> 1999999999
order by sequence_owner||'.'||sequence_name
/
