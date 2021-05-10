col module for a50
set lines 500
accept module prompt 'module like : '
accept days prompt 'go back ( days ) - default 20 : ' default 20
select substr(module,1,37) MODULE, to_char(COLLECTION_DAY,'YYYY-MM-DD'), max(cnt) MAX_SESSIONS, round(avg(cnt)) AVG_SESSIONS, min(cnt) MIN_SESSIONS, max(machine_cnt) MAX_MACHINES, min(machine_cnt) MIN_MACHINES from
 (select module,COLLECTION_DAY, collection_hour, sum(session_count) cnt
 , count(distinct machine) machine_cnt from db_session_log where  module='&module' and
 collection_day >= sysdate-&days and collection_day <= sysdate group by module,COLLECTION_DAY, collection_hour)
  group by module,to_char(COLLECTION_DAY,'YYYY-MM-DD') order by 1,2 desc;
undef days
