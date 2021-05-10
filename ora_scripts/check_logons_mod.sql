-- input is PDT time
set lines 170
col module	format a60
break on logontime
select 	 to_char(LOGON_TIME,'YY/MM/DD HH24:MI:SS') logontime
	,to_char(new_time(LOGON_TIME,'GMT','PDT'),'YY/MM/DD HH24:MI:SS') pdt
	,count(*) 
	,MODULE
from 	 db_logons 
where 	 logon_time between 	new_time(to_date('11/10/29 07:00:00','YY/MM/DD HH24:MI:SS'),'PDT','GMT') 
	 and 			new_time(to_date('11/10/29 07:10:00','YY/MM/DD HH24:MI:SS'),'PDT','GMT') 
group by to_char(LOGON_TIME,'YY/MM/DD HH24:MI:SS')
	,to_char(new_time(LOGON_TIME,'GMT','PDT'),'YY/MM/DD HH24:MI:SS')
	,MODULE 
having	 count(*)	>1
order by 1,2
/
