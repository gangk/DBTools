select snap_interval,retention from dba_hist_wr_control;

select SNAP_INTERVAL, RETENTION 
from 
	DBA_HIST_WR_CONTROL c, V$DATABASE d
where 
	c.DBID = d.DBID;
