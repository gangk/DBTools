exec DBMS_STATS.FLUSH_DATABASE_MONITORING_INFO

select table_name,inserts,updates,deletes,truncated,timestamp from dba_tab_modifications where table_name=upper('&table_name');