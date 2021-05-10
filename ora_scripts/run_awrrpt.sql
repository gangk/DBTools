-- make sure to set line size appropriately
-- set linesize 152
undef dbid
undef bsnap
undef esnap
col dbid new_value id
select dbid from v$database;
@latest_awr_snaps
SELECT output FROM TABLE(
   DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(
     &id,  1, &bsnap, &esnap) ) ;
