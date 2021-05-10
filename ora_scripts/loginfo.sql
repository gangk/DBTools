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
