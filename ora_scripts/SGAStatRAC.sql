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
col inst_id heading "Instance"
col instance_number heading "Instance"
col name heading "Allocations"
col mb format 999,999 heading "MBytes"

spool allocations.out

select to_char(sysdate, 'dd-MON-yyyy hh24:mi:ss') "Script Run TimeStamp" from dual;

select instance_number, to_char(startup_time, 'dd-mon-yyyy hh24:mi:ss') "Started On" 
from GV$instance;

break on inst_id skip 2

select inst_id, name, round((bytes/1024/1024),0) MB 
from gv$sgastat where pool='shared pool' 
and bytes > 10000000
order by inst_id asc, bytes desc
/

spool off
clear breaks


/* -----------------------------

Sample Output:

free memory                                              23,273,108                                                         
sql area                                                 12,810,916                                                         
library cache                                             7,691,788                                                         
ASH buffers                                               4,194,304                                                         
KCB Table Scan Buffer                                     3,981,204                                                         
KSFD SGA I/O b                                            3,977,128                                                         
row cache                                                 3,741,868                                                         
KQR M SO                                                  3,621,804                                                         
CCursor                                                   3,308,648                                                         
.
.
.
kscdnfyinitflags                                                           4                                                         
osp pool handles                                                        4                                                         
plwda:PLW_STR_NEW_LEN_VEC                       4                                                         
kga sga                                                                       4                                                         
kolfsgi: KOLF's SGA initi                                          4                                                         
KEWS sesstat seg tbl                                               4                                                         
listener addresses                                                     4                                                         
                                                                     ----------------                                                         
Tot                                                            114,520,848

*/