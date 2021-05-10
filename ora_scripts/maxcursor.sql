set linesize 200
set pagesize 1000
col max_open_cur format a20

select max(a.value) as highest_open_cur, p.value as max_open_cur from v$sesstat a, v$statname b, v$parameter p where a.statistic# = b.statistic# and b.name = 'opened cursors current' and p.name= 'open_cursors' group by p.value
/
