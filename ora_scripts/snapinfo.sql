col begin_interval_time for a30
col end_interval_time for a30
accept date prompt 'Enter date (dd/mm) :- '

select 
	SNAP_ID,BEGIN_INTERVAL_TIME,END_INTERVAL_TIME
from
	dba_hist_snapshot 
where
	to_char(begin_interval_time,'dd/mm')='&date'
order by 2;
