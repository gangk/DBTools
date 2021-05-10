col start_time for a30
col operation for a50
select substr(operation,1,30) operation,
to_char(start_time,'DD-MON-YY HH24:MI:SS.FF') start_time,
to_char(end_time,'DD-MON-YY HH24:MI:SS.FF')  end_time
from DBA_OPTSTAT_OPERATIONS
order by start_time desc
/


