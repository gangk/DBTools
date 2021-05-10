col service_name for a70
col status for a10
select service_name,status,count(1) from v$session group by service_name,status order by service_name,status;
