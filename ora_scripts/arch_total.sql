col Month for a30
select to_char(trunc(first_time), 'Month') "Month" ,
to_char(trunc(first_time), 'Day : DD-Mon-YYYY HH24:MI:SS') "Archive Date" ,
count(*) "Switches"
from v$log_history
where trunc(first_time) > last_day(sysdate-100) +1
group by trunc(first_time)
/