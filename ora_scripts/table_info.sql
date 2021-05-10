col  table_name for a30


SELECT table_name,owner,
       tablespace_name,
       num_rows,
       last_analyzed,
       avg_row_len,
       blocks,
       empty_blocks
FROM   dba_tables
WHERE  table_name  like UPPER('%&table_name%');

