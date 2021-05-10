REM -----------------------------------------------------
REM $Id: tab-fk.sql,v 1.1 2002/03/13 23:44:14 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Display referential integrity info given a table and owner
REM Usage       : 
REM Description : Display referential integrity info given a table and owner
REM -----------------------------------------------------

undefine owner
undefine tabname

accept owner prompt 'Enter owner id: '
accept tabname  prompt 'Enter table name: '
col owner format A14
col table_name format A22
col r_owner format A14
col r_constraint_name format A24
column table_name         format a30
column referenced_table  format a30
column foreign_key_name   format a30
column primary_key_name   format a30
column fk_status          format a8

set linesize 130
set pagesize 0
set tab      off
set space    1
set feedback off verify off
prompt '----- tables referenced by this table -------'
SELECT /*+ RULE */
    A.TABLE_NAME table_name,
    A.CONSTRAINT_NAME foreign_key_name,
    B.TABLE_NAME referenced_table,
    B.CONSTRAINT_NAME primary_key_name,
    A.STATUS fk_status
  FROM DBA_CONSTRAINTS B, DBA_CONSTRAINTS A
  WHERE
    B.CONSTRAINT_TYPE = 'P' and 
    B.CONSTRAINT_NAME =  A.R_CONSTRAINT_NAME and  
    A.OWNER = upper('&&owner') and
    A.OWNER = B.OWNER and
    A.TABLE_NAME like upper('&&tabname%') and 
    A.CONSTRAINT_TYPE = 'R'
  ORDER BY 1, 2, 3, 4;

prompt '------ tables referencing this table ------'
SELECT /*+ RULE */
    B.TABLE_NAME table_name,
    B.CONSTRAINT_NAME foreign_key_name,
    A.TABLE_NAME referenced_table,
    B.R_CONSTRAINT_NAME primary_key_name,
    B.STATUS fk_status
  FROM DBA_CONSTRAINTS B, DBA_CONSTRAINTS A
  WHERE
    B.CONSTRAINT_TYPE = 'R' and
    B.R_CONSTRAINT_NAME = A.CONSTRAINT_NAME and 
    A.OWNER = upper('&owner') and
    A.OWNER = B.OWNER and
    A.TABLE_NAME like upper('&tabname%') and
    A.CONSTRAINT_TYPE = 'P'
  ORDER BY 1, 2, 3, 4;
  
undefine owner
undefine tabname
