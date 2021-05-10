col module	format a60
break on logonpdt
select 	 to_char(new_time(LOGON_TIME,'GMT','PST'),'YY/MM/DD HH24:MI') logonpdt
	,count(*) 
	,nvl(module,'-- <'||osuser||'/'||username||'@'||substr(machine,1,instr(machine,'.')-1)||'>')  module
from 	 db_logons 
where 	 logon_time between 	new_time(to_date('12/02/07 20:45','YY/MM/DD HH24:MI'),'PST','GMT') 
	 and 			new_time(to_date('12/02/07 21:15','YY/MM/DD HH24:MI'),'PST','GMT') 
group by to_char(new_time(LOGON_TIME,'GMT','PST'),'YY/MM/DD HH24:MI') 
	,nvl(module,'-- <'||osuser||'/'||username||'@'||substr(machine,1,instr(machine,'.')-1)||'>') 
order by 1,2
/
