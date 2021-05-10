select 
    'alter '||decode(object_type, 'PACKAGE BODY', 'PACKAGE', object_type)||' '
    ||owner||'.'||object_name||' compile'||
    decode(object_type, 'PACKAGE BODY', ' BODY;', ';') 
from 
    dba_objects 
where 
    object_type in ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER','VIEW','MATERIALIZED VIEW') and status != 'VALID';
