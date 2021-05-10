select 	 to_char(LOGON_TIME,'YYYYMMDD HH24:MI')
	,count(*)
	,machine 
from 	 db_logons 
where 	 LOGON_TIME>sysdate-1/24 
group by to_char(LOGON_TIME,'YYYYMMDD HH24:MI')
	,machine 
having 	 count(*)>10
/
