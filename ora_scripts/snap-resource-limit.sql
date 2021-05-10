prompt
prompt
prompt === resource limit (snap-resource-limit.sql) ===;

col rname	format	a30	head 'Resource Name'
col curr	format 9999999	head 'Current|Value'
col hwm		format 9999999	head 'HWM|Value'
col init	format 9999999	head 'Init|Value'
col limit	format 9999999	head 'Limit|Value'

SELECT	 resource_name		rname
	,current_utilization	curr
	,max_utilization	hwm
	,initial_allocation	init
	,limit_value		limit
FROM	 v$resource_limit
WHERE	 resource_name		not like '%lm_%'
ORDER BY resource_name
;
