SELECT a.sid, a.username, a.osuser, a.program, a.tablespace_name, 
a.bytes "BYTES_USED", round(a.blocks / b.total_blocks,3) "PERC_USED" 
from (select sor.tablespace_name, ses.sid, ses.username, 
ses.osuser, ses.program, sor.blocks, sor.bytes 
from (select /*+ optimizer rule */ u.tablespace "TABLESPACE_NAME", u.session_addr,
sum(u.blocks) blocks, sum(u.blocks) * &blksize bytes 
FROM v$sort_usage u GROUP BY u.session_addr, u.tablespace) sor, 
(select /*+ optimizer rule */ saddr, sid, username, osuser, program from v$session) ses 
where ses.saddr=sor.session_addr) a, (select tablespace_name, sum(decode(maxblocks,0,blocks,maxblocks)) "TOTAL_BLOCKS"
 from dba_temp_files group by tablespace_name) b 
where a.tablespace_name=b.tablespace_name order by a.bytes;

