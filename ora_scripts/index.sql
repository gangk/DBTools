SET VERIFY OFF
SET LINESIZE 200

COLUMN table_owner FORMAT A20
COLUMN index_owner FORMAT A20
COLUMN index_type FORMAT A12
COLUMN tablespace_name FORMAT A20

SELECT table_owner,
       table_name,
       owner AS index_owner,
       index_name,
       tablespace_name,
       last_analyzed lad,
       num_rows,
       clustering_factor clust,
       status,
       index_type
FROM   dba_indexes
WHERE  table_owner = UPPER('&owner')
AND    table_name = UPPER('&table_name')
ORDER BY table_owner, table_name, index_owner, index_name;


select index_name,UNIQUENESS,COMPRESSION,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,NUM_ROWS from dba_indexes where index_name = upper('&index_name');
