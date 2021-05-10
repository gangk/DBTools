col mach	format a60

break on logonpdt
select 	 to_char(new_time(LOGON_TIME,'GMT','PDT'),'YY/MM/DD HH24:MI') logonpdt
	,count(*) 
	,substr(machine,1,instr(machine,'.',1)-1)	mach
from 	 db_logons 
where 	 logon_time between 	new_time(to_date('11/06/26 21:00','YY/MM/DD HH24:MI'),'PDT','GMT') 
	 and 			new_time(to_date('11/06/26 21:10','YY/MM/DD HH24:MI'),'PDT','GMT') 
and	 module	= 'JDBC Thin Client'
group by to_char(new_time(LOGON_TIME,'GMT','PDT'),'YY/MM/DD HH24:MI')
	,substr(machine,1,instr(machine,'.',1)-1)	
order by 1,2
/
