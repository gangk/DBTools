SELECT
c.BEGIN_INTERVAL_TIME,
b.OBJECT_NAME,
(a.PHYSICAL_WRITES_DELTA+PHYSICAL_WRITES_DIRECT_DELTA)/30 writes_per_min,
(a.LOGICAL_READS_DELTA)/30 reads_per_min
from 
DBA_HIST_SEG_STAT a,
DBA_OBJECTS b,
DBA_HIST_SNAPSHOT c
where
a.obj#=b.object_id and
a.snap_id = c.snap_id and
b.object_name in ('COMP_STATIONS','COMP_EMPLOYEES','COMP_ROUTES') and 
b.object_type='TABLE' and
c.BEGIN_INTERVAL_TIME > sysdate - 5
order by 1,2;

