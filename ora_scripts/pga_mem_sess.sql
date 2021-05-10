set linesize 300

column PGA_ALLOC_MEM format 99,990
column PGA_USED_MEM format 99,990
column inst_id format 99
column username format a15
column program format a25
column logon_time format a10
column MODULE for a35
select s.inst_id, s.sid, s.username, s.logon_time, s.module, s.program,  PGA_USED_MEM/1024/1024 PGA_USED_MEM, PGA_ALLOC_MEM/1024/1024 PGA_ALLOC_MEM
from gv$session s
, gv$process p
Where s.paddr = p.addr
and s.inst_id = p.inst_id
and PGA_USED_MEM/1024/1024 > 20  -- pga_used memory over 20mb
order by PGA_USED_MEM;
