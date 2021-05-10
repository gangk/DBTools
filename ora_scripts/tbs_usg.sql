set pages 200

col Mb form 9,999,9999

break on report on owner skip 1
compute sum of Mb on report 
compute sum of Mb on owner 

select rownum as rank, a.*
from (
   select owner, tablespace_name, sum(bytes)/1024/1024 Mb
   from dba_segments
   where owner not in ('SYS','SYSTEM')
   group by owner,tablespace_name
   order by 3 desc ) a
where rownum < 11
/

clear breaks
clear computes

break on report on tablespace_name skip 1

compute sum of Mb on report 
compute sum of Mb on tablespace_name

select rownum as rank, a.*
from (
   select tablespace_name, owner, sum(bytes)/1024/1024 Mb
   from dba_segments
   where owner not in ('SYS','SYSTEM')
   group by tablespace_name, owner
   order by 3) a
where rownum < 11
/
