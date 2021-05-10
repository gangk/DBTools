
col group# 	format 999      heading 'Group'  
col member 	format a50	heading 'Member' justify c 
col status 	format a10	heading 'Status' justify c	 
col archived	format a10	heading 'Archived' 	 
col fsize 	format 99999 	heading 'Size|(MB)'  
 
select  l.group#, 
        member, 
 	archived, 
        l.status, 
        (bytes/1024/1024) fsize 
from    v$log l, 
	v$logfile f 
where f.group# = l.group# 
order by 1 
/
