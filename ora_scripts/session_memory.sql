SET ECHO off 
REM NAME: session_memory.SQL 
REM USAGE:"@path/session_memory" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM Select privilege on sys.v$sesstat and sys.v$statname. 
REM ------------------------------------------------------------------------ 
REM AUTHOR:
REM Jay Caviness 
REM 
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM This script provides a listing of the uga and pga memory for every session 
REM in the current instance from smallest to largest. 
REM
REM ------------------------------------------------------------------------ 
REM DISCLAIMER: 
REM This script is provided for educational purposes only. It is NOT 
REM supported by Oracle World Wide Technical Support. 
REM The script has been tested and appears to work as intended. 
REMYou should always run new scripts on a test instance initially. 
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 

column name format a25 heading 'Name'
column sid format 999999 heading 'SID'
column maxmem format 9999,999,999 heading 'Max Bytes'
ttitle 'PGA = dedicated server processes - UGA = Client machine process'


compute sum of maxmem on report
break on report

select se.sid,n.name, 
max(se.value) maxmem
from v$sesstat se,
v$statname n
where n.statistic# = se.statistic#
and n.name in ('session pga memory','session pga memory max',
'session uga memory','session uga memory max')
group by n.name,se.sid
order by 3
/

