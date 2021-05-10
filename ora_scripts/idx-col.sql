REM -----------------------------------------------------
REM $Id: idx-col.sql,v 1.1 2002/03/14 19:59:49 hien Exp $
REM Author      : Kinney Jamie
REM #DESC       : Show indexes and their column positions for a table
REM Usage       : table_name - table name 
REM Description : Show indexes and columns they index on for a given table
REM -----------------------------------------------------
break on index name on report
select index_name, column_name
from dba_ind_columns
where table_name = upper('&table_name')
order by index_name, column_position;
