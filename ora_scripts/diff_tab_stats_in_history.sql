col owner for a14
col table_name for a18
col partition_name for a25

select * from dba_tab_stats_history where owner=upper('&owner') and table_name=upper('&tabname');

set longchunksize 9999999
select * from table(dbms_stats.diff_table_stats_in_history(
                    ownname => upper('&owner'),
                    tabname => upper('&tabname'),
                    time1 => systimestamp,
                    time2 => to_timestamp('&time2','yyyy-mm-dd:hh24:mi:ss'),
                    pctthreshold => 0)); 


