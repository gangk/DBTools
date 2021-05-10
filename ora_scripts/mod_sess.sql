set line 999
set verify off;
accept mod_name prompt 'Enter module name:- '
accept num_days prompt 'Enter number of days:- '
select module, COLLECTION_DAY, max(SUM_SESS) "Max Sessions" , round(avg(SUM_SESS)) "Avg Sessions", min(SUM_SESS) "Min Sessions",
       max(mac) "Max Machines" , min(mac) "Min Machines"
from (select module , COLLECTION_DAY, COLLECTION_HOUR, count(machine) mac , sum(SESSION_COUNT) "SUM_SESS"
     from db_session_log where COLLECTION_DAY > (sysdate - &num_days)
     and module = '&mod_name'
     group by module, COLLECTION_DAY, COLLECTION_HOUR)
group by module, COLLECTION_DAY order by COLLECTION_DAY;

