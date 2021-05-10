select   a.USERNAME,
         DISK_READS,
         EXECUTIONS,
         round(DISK_READS / decode(EXECUTIONS, 0, 1, EXECUTIONS)),
         SQL_TEXT
from     dba_users a, sys.v_$session, sys.v_$sqlarea
where    PARSING_USER_ID=USER_ID 
and      ADDRESS=SQL_ADDRESS(+) 
and      DISK_READS > 10000
order by DISK_READS desc, EXECUTIONS desc;