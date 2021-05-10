-- -----------------------------------------------------------------------------------
-- Author       : Rohit H. Patil
-- 
-- Call Syntax  : @sql_hash_from_sid.sql
-- -----------------------------------------------------------------------------------
set lines 300
set pages 100
column username format a15 wrap
column SCHEMANAME format a10 wrap
column OSUSER format a15 wrap
column MACHINE format a15 wrap
column TERMINAL format a15 wrap
column PROGRAM format a30 wrap
select username,HASH_VALUE,SCHEMANAME,OSUSER,MACHINE,TERMINAL,PROGRAM,MODULE
from v$sqltext, v$session  where address=sql_address and hash_value = sql_hash_value 
and sid=&sid order by piece;