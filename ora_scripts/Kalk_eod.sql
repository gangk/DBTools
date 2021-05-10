col time for a20

select a.process_code,b.process,TO_CHAR(a.process_date,'dd-mm-yy HH24:mi:ss') TIME
from kalkulus.process_log a, kalkulus.codes_process b 
where a.process_code<160
and a.process_code=b.process_code
order by a.process_date;

