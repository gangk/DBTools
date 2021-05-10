select substr(d.host_name,1,8) machine_name,
substr(d.instance_name,1,8) instance_name,
rpad(nvl(program,machine),30,' ') program_name,
round(avg((a.value/b.value)*100),2) ?avg_parse_%?,
round(max((a.value/b.value)*100),2) ?max_parse_%?,
count(*) program_session_count
from v$session s,v$sesstat a,v$sesstat b, v$instance d
where b.value>0 and s.sid=a.sid and a.sid=b.sid and
a.statistic#=(select statistic# from v$statname
where name='parse count (hard)') and b
.statistic#=(select statistic# from v$statname
where name='parse count (total)')
group by substr(d.host_name,1,8),
substr(d.instance_name,1,8),
rpad(nvl(program,machine),30,' ')
order by round(avg((a.value/b.value)*100),2) ;
