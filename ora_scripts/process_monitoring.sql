/************

execute the following command

prstat -a

Get the pid of the process consuming more cpu or executing for a long time.
Pass the obtained pid to the below query when prompted to get query currently being executed

USE ANY OF THE FOLLOWING ACCORDING TO YOUR DB VERSION

*************/

-- 10g

COLUMN sql_fulltext format a100

SET lines 350
set pagesize 10000
SET long 10000

SELECT sql_fulltext
  FROM v$sqlarea
 WHERE sql_id = (SELECT sql_id
                   FROM v$session
                  WHERE paddr = (SELECT addr
                                   FROM v$process
                                  WHERE spid = &pid));
==========================================================================================

-- 9i

col username format a10
col osuser format a10
col program format a10
SET lines 350
set pagesize 10000
SET long 10000

select SID,USERNAME,COMMAND,STATUS,OSUSER,PROCESS,PROGRAM,to_char(LOGON_TIME,'DD-MON-YY HH24:MI:SS') logon_time,LAST_CALL_ET from gv$session WHERE paddr = (SELECT addr FROM v$process WHERE spid = &pid);



COLUMN sql_text format a100

SET lines 350
set pagesize 10000
SET long 10000

SELECT sql_text
  FROM v$sqlarea
 WHERE address = (SELECT SQL_ADDRESS 
                   FROM v$session
                  WHERE paddr = (SELECT addr
                                   FROM v$process
                                  WHERE spid = &pid));