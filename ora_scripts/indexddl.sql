undefine tablename
undefine schema
clear 
accept indexname prompt 'enter index name :- '
accept schema prompt 'enter schema ( default BOOKER ) :- ' default BOOKER
set trimspool on
set long 999999 linesize 300
set longchunksize 300
set trimspool on
col THIS_INDEX heading "Definition - &indexname "
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',false);
SELECT  DBMS_METADATA.GET_DDL('INDEX', UPPER('&indexname'),UPPER('&schema')) THIS_INDEX from dual;

prompt Enter to see full definition. Ctlr-C to Exit
pause

EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',true);
SELECT  DBMS_METADATA.GET_DDL('INDEX', UPPER('&indexname'),UPPER('&schema')) THIS_INDEX from dual;


