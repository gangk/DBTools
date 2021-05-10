col module for a70
col status for a10
select module,status,count(1) from v$session group by module,status order by module,status;
