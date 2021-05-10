SELECT a.ownerid "Owner",
       Substr(name,1,40) "Name",
       type "Type",
       pipe_size "Size"
FROM   v$db_pipes a
ORDER BY 1,2;

