select owner, table_name, status, last_analyzed,
 num_rows, blocks, degree, cell_flash_cache
 from dba_tables
 where cell_flash_cache like nvl('&cell_flash_cache','KEEP')
 /