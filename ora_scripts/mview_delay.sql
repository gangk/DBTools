select a.master, b.name, b.snapshot_site, (sysdate - a.CURRENT_SNAPSHOTS)*24*60 "delay Mins"
from dba_snapshot_logs a, dba_registered_snapshots b
where a.snapshot_id = b.snapshot_id
and (sysdate - a.CURRENT_SNAPSHOTS)*24*60 > &delay;

