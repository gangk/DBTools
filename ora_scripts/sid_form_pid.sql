-- -----------------------------------------------------------------------------------
-- Author       : Rohit H. Patil
-- 
-- Call Syntax  : @sid_from_pid
-- -----------------------------------------------------------------------------------
select sid from v$session where paddr in (select addr from v$process where spid=&process_id);