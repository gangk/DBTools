COLUMN object_name FORMAT A30



SELECT owner,
       object_type,
       object_name,
       status
FROM   dba_objects
WHERE  status = 'INVALID'
ORDER BY owner, object_type, object_name;






select 'ALTER ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME || ' COMPILE;' from dba_objects where status = 'INVALID'  and object_type in (select distinct(object_type) from dba_objects);

