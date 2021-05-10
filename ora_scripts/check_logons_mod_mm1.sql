col module	format a60
break on logonpdt
select 	 to_char(new_time(LOGON_TIME,'GMT','PDT'),'YY/MM/DD HH24:MI') logonpdt
	,count(*) 
	,nvl(module,'-- <'||osuser||'/'||username||'@'||substr(machine,1,instr(machine,'.')-1)||'>')  module
from 	 db_logons 
where 	 logon_time between 	new_time(to_date('11/07/12 18:55','YY/MM/DD HH24:MI'),'PDT','GMT') 
	 and 			new_time(to_date('11/07/12 19:10','YY/MM/DD HH24:MI'),'PDT','GMT') 
and 	 module in ('InventoryPlanningService','InventoryAllocationService','InventoryPlanningComputationService')
group by to_char(new_time(LOGON_TIME,'GMT','PDT'),'YY/MM/DD HH24:MI') 
	,nvl(module,'-- <'||osuser||'/'||username||'@'||substr(machine,1,instr(machine,'.')-1)||'>') 
having	 count(*) >= 10
order by 1,2
/
