SET LINESIZE 200

COLUMN owner FORMAT A20
COLUMN constarint_name  FORMAT A20
col constraint_type for a5
col index_name for a17
col r_constraint_name for a10
COLUMN column_name  FORMAT A30

select owner,CONSTRAINT_NAME,CONSTRAINT_TYPE,index_name,R_OWNER,R_CONSTRAINT_NAME,status from dba_constraints where owner= upper('&owner') and table_name= upper('&table_name');

select owner,table_name,column_name,constraint_name,position from dba_cons_columns where owner=upper('&owner') and table_name=upper('&table_name');

