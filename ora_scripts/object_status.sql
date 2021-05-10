SET SERVEROUTPUT ON
SET FEEDBACK OFF


SELECT Substr(object_name,1,30) object_name,
       object_type,
       status
FROM   all_objects
WHERE  owner = Upper('&OWNER');

PROMPT
SET FEEDBACK ON

