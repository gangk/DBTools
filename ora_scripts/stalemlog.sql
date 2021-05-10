Set lines 500
col owner format A10
col snapshot_id for 999999
col snapshot_site for a20
select * from 
(select 
site.SNAPSHOT_ID,site.name,site.owner,site.SNAPSHOT_SITE,logs.CURRENT_SNAPSHOTS,sysdate, 
round( (sysdate-logs.CURRENT_SNAPSHOTS)*1441 ) "Minutes behind" 
from dba_registered_snapshots site,dba_snapshot_logs logs 
where site.snapshot_id=logs.snapshot_id 
order by 7 desc ) where rownum <21;
