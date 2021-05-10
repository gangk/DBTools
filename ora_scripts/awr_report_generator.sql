define _interval=1   --1 for half hour 2 for 1 hour 
define _database_name='DBNAME'
define _begin_interval_date='141111 23:00:00'
define _end_interval_date='151111 05:00:00'
define _folder='/dbadmin/dinesh/anand'


SET termout OFF 
host mkdir &_folder
SET termout ON
host dir &_folder

SET heading off

spool gen_awr.sql
SELECT 'set veri off;' FROM dual;
SELECT 'set feedback off;' FROM dual;
SELECT 'set linesize 1500;' FROM dual;
SELECT 'set termout on;'||CHR(10) FROM dual;
SELECT  'spool &_folder\awrrptto_&_database_name'||CHR(95)||TO_CHAR(instance_number)||'_'||TO_CHAR(previous_snap_id)||'_'||TO_CHAR(snap_id)||'.html'||CHR(10)|| CHR(10)|| 
'SELECT * FROM TABLE(dbms_workload_repository.awr_report_html('||TO_CHAR(dbid)||','||TO_CHAR(instance_number)||','||TO_CHAR(previous_snap_id)||','||TO_CHAR(snap_id)||',8));'||CHR(10)
||CHR(10)||'spool off' 
FROM (
select instance_number,dbid,snap_id,
LEAD(snap_id, &_interval, 0) OVER (PARTITION BY instance_number ORDER BY snap_id DESC NULLS LAST) previous_snap_id,
LAG(snap_id, &_interval, 0) OVER (PARTITION BY instance_number ORDER BY snap_id DESC NULLS LAST) next_snap_id,
begin_interval_time 
from dba_hist_snapshot 
where dbid=(select dbid from v$database where name='&_database_name')
AND instance_number in (select DISTINCT inst_id from gv$database  )
AND begin_interval_time>=TO_DATE('&_begin_interval_date','DDMMYY HH24:MI:SS')-1/24
AND begin_interval_time<TO_DATE('&_end_interval_date','DDMMYY HH24:MI:SS')+1/24
) WHERE next_snap_id<>0 AND previous_snap_id<>0
order by instance_number,begin_interval_time asc;

spool off;