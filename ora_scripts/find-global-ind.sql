REM ------------------------------------------------------------------------------------------------
REM $Id: find-global-ind.sql,v 1.1 2003/10/22 22:10:33 jschafer Exp $
REM Author     : jschafer
REM #DESC      : Show all partitioned tables with global indexes
REM Usage      : Input parameter: none
REM Description: Show all partitioned tables with global indexes
REM ------------------------------------------------------------------------------------------------

@plusenv
col "Owner"        format a15 wrapped
col "Table Name"   format a30 
col "Index Name"   format a30

select I.table_owner "Owner", I.table_name "Table Name", I.index_name "Index Name"
from dba_indexes I,  dba_part_tables PT
where I.table_owner = PT.owner
  and I.table_name = PT.table_name
and not exists
(select 1 
 from dba_part_indexes PI
 where PI.owner = PT.owner
   and PT.table_name = PI.table_name
   and I.index_name = PI.index_name
 )
;

