column value format 999,999,999

select 'INIT.ORA sort_area_size: '||value
from v$parameter
where name like 'sort_area_size'
/

select a.name, value
from v$statname a, v$sysstat
where a.statistic# = v$sysstat.statistic#
and a.name in ('sorts (disk)', 'sorts (memory)', 'sorts (rows)')
/ 
