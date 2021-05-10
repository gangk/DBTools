-- -----------------------------------------------------------------------------------
-- Author       : Rohit H. Patil
-- 
-- Call Syntax  : @sql_text.sql
-- -----------------------------------------------------------------------------------
select sql_text from v$sqltext where hash_value =&hashvalue order by piece;