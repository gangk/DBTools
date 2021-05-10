REM  Investigate trends in the SGA
REM   It is safe to run this query as often as you like.
REM   
REM   You can change "and bytes > 10000000" higher
REM    or lower to fit your needs.  10.2.x redesigned
REM    the v$sgastat view and it will contain hundreds
REM    of rows and it is usually not necessary to see
REM    them all.

set lines 100
set pages 9999
col mb format 999,999
col name heading "Name"

select to_char(sysdate, 'dd-MON-yyyy hh24:mi:ss') "Script Run TimeStamp" from dual;

select to_char(startup_time, 'dd-MON-yyyy hh24:mi:ss') "Startup Time" from v$instance;

select name, round((bytes/1024/1024),0) MB 
from v$sgastat where pool='shared pool' 
and bytes > 10000000
order by bytes desc
/
