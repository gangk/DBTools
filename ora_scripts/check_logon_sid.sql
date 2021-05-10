col mach	format a60

break on logonpdt
select 	 to_char(new_time(LOGON_TIME,'GMT','PDT'),'YY/MM/DD HH24:MI') logonpdt
	,sid
	,substr(machine,1,instr(machine,'.',1)-1)	mach
from 	 db_logons 
where 	 logon_time between 	new_time(to_date('11/08/14 01:00','YY/MM/DD HH24:MI'),'PDT','GMT') 
	 and 			new_time(to_date('11/08/14 20:10','YY/MM/DD HH24:MI'),'PDT','GMT') 
and 	 machine = 'scos-oih-gamma-13002.dub3.amazon.com'
/
