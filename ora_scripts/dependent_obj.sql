REM OBJECT DEPENDENT 

 Select object_id, referenced_object_id, level
  from public_dependency
 start with object_id = (Select object_id
 from sys.DBA_OBJECTS
 WHERE owner = upper ('& owner')
 AND object_name = upper ('& name')
 AND object_type = upper ('& type'))
 connect by prior referenced_object_id = object_id
 /

 Select to_char (object_id) object_id, to_char (referenced_object_id) referenced_object_id, to_char (level) "LEVEL"
  from public_dependency
 connect by prior object_id = referenced_object_id
 start with referenced_object_id = (
    Select object_id from sys.DBA_OBJECTS
 WHERE owner = upper ('& owner')
 AND object_name = upper ('& name')
 AND object_type = upper ('& type'))
 /

 set feedback off
 set ver off
 set pages 10000
 column Owner format "A10"
 column Obj # format "9999999999"
 column Object format "A35"
 rem
 ACCEPT OWN CHAR PROMPT "Enter OWNER pattern:"
 ACCEPT NAM CHAR PROMPT "Enter OBJECT NAME pattern:"
 prompt
 prompt Objects matching & & OWN .. & & NAM
 prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 select o.obj # "Obj #",
        decode (o.linkname, null, u.name ||'.'|| o.name,
         o.remoteowner ||'.'|| o.name ||'@'|| o.linkname) "Object",
        decode (o.type #, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                        4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                        7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                       10, '* Not Exist *',
                       11, 'PKG BODY', 12, 'TRIGGER',
                       13, 'TYPE', 14, 'TYPE BODY',
                       19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                       22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
                       28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                       32, 'INDEXTYPE', 33, 'OPERATOR',
                       34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                       40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
                       42, 'MATERIALIZED VIEW',
                       43, 'DIMENSION',
                       44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
                       48, 'CONSUMER GROUP',
                       51, 'SUBSCRIPTION', 52, 'LOCATION',
                       55, 'XML SCHEMA', 56, 'JAVA DATA',
                       57, 'SECURITY PROFILE', 59, 'RULE',
                       62, 'EVALUATION CONTEXT', 66, 'JOB', 67, 'PROGRAM',
                       68, 'JOB CLASS', 69, 'WINDOW', 72, 'WINDOW GROUP',
                       74, 'SCHEDULE', 'UNDEFINED') "Type",
        decode (o.status, 0, 'N / A', 1, 'VALID', 'INVALID') "Status"
   from sys.obj $ o, sys.user $ u
  where owner # = user #
    and u.name like upper ('& & OWN') and o.name like upper ('& & NAM');
 prompt
 ACCEPT OBJID CHAR PROMPT "Enter Object ID required:"
 prompt
 prompt
 prompt Object & & OBJID is:
 prompt ~~~~~~~~~~~~~~~~~~~
 select o.obj # "Obj #",
        decode (o.linkname, null, u.name ||'.'|| o.name,
         o.remoteowner ||'.'|| o.name ||'@'|| o.linkname) "Object",
        decode (o.type #, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                        4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                        7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                       10, '* Not Exist *',
                       11, 'PKG BODY', 12, 'TRIGGER',
                       13, 'TYPE', 14, 'TYPE BODY',
                       19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                       22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
                       28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                       32, 'INDEXTYPE', 33, 'OPERATOR',
                       34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                       40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
                       42, 'MATERIALIZED VIEW',
                       43, 'DIMENSION',
                       44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
                       48, 'CONSUMER GROUP',
                       51, 'SUBSCRIPTION', 52, 'LOCATION',
                       55, 'XML SCHEMA', 56, 'JAVA DATA',
                       57, 'SECURITY PROFILE', 59, 'RULE',
                       62, 'EVALUATION CONTEXT', 66, 'JOB', 67, 'PROGRAM',
                       68, 'JOB CLASS', 69, 'WINDOW', 72, 'WINDOW GROUP',
                       74, 'SCHEDULE', 'UNDEFINED') "Type",
        decode (o.status, 0, 'N / A', 1, 'VALID', 'INVALID') "Status",
        substr (to_char (stime, 'DD-MON-YYYY HH24: MI: SS'), 1,20) "S-Time"
   from sys.obj $ o, sys.user $ u
  where owner # = user # and o.obj #='&& OBJID ';
 prompt
 prompt Depends on:
 prompt ~~~~~~~~~~~~
 select o.obj # "Obj #",
        decode (o.linkname, null,
         nvl (u.name, 'Unknown')||'.'|| nvl (o.name,' Dropped? '),
         o.remoteowner ||'.'|| nvl (o.name, 'Dropped ?')||'@'|| o.linkname) "Object",
        decode (o.type #, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                        4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                        7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                       10, '* Not Exist *',
                       11, 'PKG BODY', 12, 'TRIGGER',
                       13, 'TYPE', 14, 'TYPE BODY',
                       19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                       22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
                       28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                       32, 'INDEXTYPE', 33, 'OPERATOR',
                       34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                       40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
                       42, 'MATERIALIZED VIEW',
                       43, 'DIMENSION',
                       44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
                       48, 'CONSUMER GROUP',
                       51, 'SUBSCRIPTION', 52, 'LOCATION',
                       55, 'XML SCHEMA', 56, 'JAVA DATA',
                       57, 'SECURITY PROFILE', 59, 'RULE',
                       62, 'EVALUATION CONTEXT', 66, 'JOB', 67, 'PROGRAM',
                       68, 'JOB CLASS', 69, 'WINDOW', 72, 'WINDOW GROUP',
                       74, 'SCHEDULE', 'UNDEFINED') "Type",
         decode (sign (stime-P_TIMESTAMP),
                   1, '* NEWER *', -1, '*? OLDER? *', Null ,'-','- SAME-')
 "TimeStamp",
 decode (o.status, 0, 'N / A', 1, 'VALID', 'INVALID') "Status"
   from sys.dependency $ d, sys.obj $ o, sys.user $ u
  where P_OBJ # = obj # (+) and o.owner # = u.user # (+) and D_OBJ #='&& OBJID '; 