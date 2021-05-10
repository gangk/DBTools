set echo on feed on
select last_analyzed from dba_tables where table_name = 'ASIN_ENCUMBRANCES' and owner = 'BOOKER';
select * from (select stats_update_time from dba_tab_stats_history where table_name = 'ASIN_ENCUMBRANCES' and owner='BOOKER' order by 1 desc) where rownum <=10 ;

exec dbms_stats.restore_table_stats ('BOOKER', 'ASIN_ENCUMBRANCES', '26-AUG-11 10.02.10.436474 PM +00:00');

select last_analyzed from dba_tables where table_name = 'ASIN_ENCUMBRANCES' and owner = 'BOOKER';
