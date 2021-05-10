accept mod_name prompt 'Enter Module_name:- '
accept num_days prompt 'Enter num_days:- '
set verify off;
select module, max(SUM_SESS) "Max Sessions" 
from (select module , COLLECTION_DAY, COLLECTION_HOUR, count(machine) mac , sum(SESSION_COUNT) "SUM_SESS"
	  from db_session_log where COLLECTION_DAY > (sysdate - 10)
	  and module = '&mod_name'
	  group by module, COLLECTION_DAY, COLLECTION_HOUR)
group by module;
