select i.table_owner, i.table_name, i.owner, i.index_name
            from dba_indexes i, 
            dba_part_tables t
                  where i.table_owner = t.owner
                  and i.table_name = t.table_name
                  and i.partitioned = 'NO'
                  and t.table_name in (select distinct table_name from db_rolling_partitions where owner='BOOKER');


