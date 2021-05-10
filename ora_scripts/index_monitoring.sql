--Since index monitoring is very low cost, it makes sense to turn it on for all candidate indexes. 
--Indexes on FKs and unique indexes are doing work even if not used in execution plans, so they are not candidates to drop. 
--Here's the query to get all non-unique, non-FK indexes (assumes no concatenated PK's - if you have that, the query gets more complicated):

SELECT 'ALTER INDEX '||ic.index_name||' MONITORING USAGE;'
  FROM all_ind_columns ic, all_indexes i
 WHERE i.uniqueness = 'NONUNIQUE' --don't monitor unique indexes
   AND i.table_owner = upper('&SCHEMA_OWNER_HERE')
   AND ic.index_owner = i.owner
   AND ic.index_name = i.index_name
   AND ic.position = 1
   AND NOT EXISTS (SELECT 'x' --Don't monitor indexes on FK's
                     FROM all_cons_columns cc, all_constraints c
                    WHERE ic.table_name = cc.table_name
                      AND ic.column_name = cc.column_name
                      AND c.constraint_name = cc.constraint_name
                      AND c.constraint_type IN ('R'));
                      

Here's the query to look at monitored objects if you're not logged in as the schema owner:

select d.username, io.name, t.name,
       decode(bitand(i.flags, 65536), 0, 'NO', 'YES'),
       decode(bitand(ou.flags, 1), 0, 'NO', 'YES'),
       ou.start_monitoring,
       ou.end_monitoring
from sys.obj$ io, sys.obj$ t, sys.ind$ i, sys.object_usage ou,
     dba_users d
where io.owner# = d.user_id
  AND d.username = upper('&SCHEMA_OWNER_HERE')
  and i.obj# = ou.obj#
  and io.obj# = ou.obj#
  and t.obj# = i.bo#;