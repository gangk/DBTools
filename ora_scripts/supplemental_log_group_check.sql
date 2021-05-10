SELECT COUNT (*)
  FROM (SELECT   a.table_name, a.log_group_name, COUNT (*)
            FROM dba_log_group_columns a, dba_objects b
           WHERE                            --a.TABLE_NAME='TCM_CUST_AAA_DATA'
                 a.log_group_name NOT LIKE '%' || b.object_id || '%'
             AND a.table_name = b.object_name
             AND b.object_type = 'TABLE'
             AND a.owner = 'ADMHR'
             AND b.owner = 'ADMHR'
        GROUP BY table_name, log_group_name
        ORDER BY 1);