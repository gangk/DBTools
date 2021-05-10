COLUMN index_name      FORMAT A30
COLUMN column_name     FORMAT A30
COLUMN column_position FORMAT 99999

SELECT a.index_name,
       a.column_name,
       a.column_position
FROM   all_ind_columns a,
       all_indexes b
WHERE  b.table_name = Upper('&table_name')
AND    b.owner      = Upper('&owner')
AND    b.index_name = a.index_name
AND    b.owner      = a.index_owner
ORDER BY 1,3;

