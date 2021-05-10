select sql_id, round(ELAPSED_TIME/(executions*1000000)) from v$sqlstats where sql_id in (select sql_id from v$sql where module = '&mod_name');
