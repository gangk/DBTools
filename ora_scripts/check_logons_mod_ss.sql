col module	format a60
break on logontime
select 	 to_char(LOGON_TIME,'YY/MM/DD HH24:MI:SS') logontime
	,count(*) 
	,MODULE
from 	 db_logons 
where 	 logon_time between 	new_time(to_date('11/06/26 21:00','YY/MM/DD HH24:MI:SS'),'PDT','GMT') 
	 and 			new_time(to_date('11/06/26 21:08','YY/MM/DD HH24:MI:SS'),'PDT','GMT') 
group by to_char(LOGON_TIME,'YY/MM/DD HH24:MI:SS')
	,MODULE 
having	 count(*)	>2
order by 1,2
/
