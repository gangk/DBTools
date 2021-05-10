col stale_stats format a10
col stattype_locked format a15
col table_name format a30
select owner,table_name,stale_stats,stattype_locked,last_analyzed from dba_tab_statistics
where stale_stats = 'YES'
and owner =upper('&owner')
order by stale_stats,stattype_locked,last_analyzed;
