@plusenv
col name 	format a80
col mb		format 99,999
select 	 name
	,log#
	,sequence#
	,(bytes)/(1024*1024) mb
	,first_time 
from 	 V$FLASHBACK_DATABASE_LOGFILE 
order by sequence#
/
