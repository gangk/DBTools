col mb format 999,999,999
select to_char(first_time,'mm/dd/yyyy HH24') dt, sum( blocks * block_size) / (1024 * 1024 ) MB
from v$archived_log
where first_time > = sysdate - 3
and   dest_id = 1
group by to_char(first_time,'mm/dd/yyyy HH24')
order by 1;
