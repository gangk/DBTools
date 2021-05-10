select to_char(BEGIN_INTERVAL_TIME,'MON YYYY') month, min(snap_id) min_snap, max(snap_id) max_snap
from dba_hist_snapshot
where instance_number=4
group by to_char(BEGIN_INTERVAL_TIME,'MON YYYY');