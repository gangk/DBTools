col # for a10
col Name for a50

select 
substr(a.file#,1,2) "#", 
substr(a.name,1,30) "Name", 
a.status, 
a.bytes/1024/1024 MB, 
b.phyrds, 
b.phywrts 
from v$datafile a, v$filestat b 
where a.file# = b.file#;
