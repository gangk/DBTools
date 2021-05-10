@plusenv
col module	format a60
col machine	format a60 trunc
break on logontime
select 	 to_char(new_time(logon_time,'GMT','PST'),'YY/MM/DD HH24:MI') logontime
	,count(*) 
	,MODULE
	,machine
from 	 db_logons 
where 	 logon_time between 	new_time(to_date('12/01/01 00:00','YY/MM/DD HH24:MI'),'PST','GMT') 
	 and 			new_time(to_date('12/02/16 14:00','YY/MM/DD HH24:MI'),'PST','GMT') 
and	 module in ('index.cgi')
group by to_char(new_time(logon_time,'GMT','PST'),'YY/MM/DD HH24:MI')
	,MODULE 
	,machine
order by 1,2
/
