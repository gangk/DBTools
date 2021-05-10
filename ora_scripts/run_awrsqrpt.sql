-- make sure to set line size appropriately
-- set linesize 180
undef dbid
undef bsnap
undef esnap
undef sqlid
col dbid new_value id
select dbid from v$database;
@latest_awr_snaps
SELECT output FROM TABLE(
   DBMS_WORKLOAD_REPOSITORY.AWR_SQL_REPORT_TEXT(&id,  1, &bsnap, &esnap, '&sqlid') ) ;
