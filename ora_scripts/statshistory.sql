set line 900;
select TABLE_NAME,partition_name,LAST_ANALYZED,STATTYPE_LOCKED,STALE_STATS from dba_tab_statistics where table_name in ('&Table_name');

SELECT OWNER,TABLE_NAME,STATS_UPDATE_TIME FROM DBA_TAB_STATS_HISTORY WHERE TABLE_NAME like '&Table_name' order by STATS_UPDATE_TIME;

SELECT column_name, num_distinct, num_buckets, histogram   FROM dba_TAB_COL_STATISTICS where table_name ='&Table_name';
