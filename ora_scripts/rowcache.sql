set pages 1000
column cache# format 99999
column name format a33
column latch# format 999999
select distinct s.kqrstcln latch#,r.cache#,r.parameter name,r.type,r.subordinate#
from v$rowcache r,x$kqrst s
where r.cache#=s.kqrstcid
order by 1,4,5;
