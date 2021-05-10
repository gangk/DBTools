REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM Functionality: This script is to print locks in RAC. 
REM **************
REM Use Case: 1. Useful to find print locks in RAC. In RAC, gv$lock is almost useless.
REM              It doesn't provide much information. GV$ges_enqueue is very slow since 
REM              it  includes BL locks and with very large SGAs nowadays, queries against gv$ges_enqueus are
REM              very slow.
REM 
REM Note : 1. Keep window 160 columns for better visibility.
REM
REM Exectution type:  Callled from check_lock.ksh
REM
REM Please send me an email to rshamsud@orainternals.com, if you enhance this script :-)
REM --------------------------------------------------------------------------------------------------
PROMPT 
PROMPT !! Make sure to use correct Parameters in the script !!
with locked_pids as (
select inst_id, kjilkftlkp, kjilkftgl, kjilkftrl, kjilkftrn1, kjilkftrn2, kjilkftpid, kjilkftxid0,
 kjilkftxid1, kjilkftgid, kjilkftoodd, kjilkftoopt, kjilkftoopo, kjilkftoonxid, kjilkftcogv,
kjilkftcopv, kjilkftconv, kjilkftcodv, kjilkftconq, kjilkftcoep, kjilkftconddw, kjilkftconddb,
 kjilkftwq, kjilkftls, kjilkftaste0, kjilkfton, kjilkftblked, kjilkftblker
from x$kjilkft
where kjilkftrl != 'KJUSENL' and ( kjilkftblked=1 or kjilkftblker=1)
) 
select lp.* from locked_pids lp;

with locked_pids as (
select inst_id, kjilkftlkp, kjilkftgl, kjilkftrl, kjilkftrn1, kjilkftrn2, kjilkftpid, kjilkftxid0,
 kjilkftxid1, kjilkftgid, kjilkftoodd, kjilkftoopt, kjilkftoopo, kjilkftoonxid, kjilkftcogv,
kjilkftcopv, kjilkftconv, kjilkftcodv, kjilkftconq, kjilkftcoep, kjilkftconddw, kjilkftconddb,
 kjilkftwq, kjilkftls, kjilkftaste0, kjilkfton, kjilkftblked, kjilkftblker
from x$kjilkft
where kjilkftrl != 'KJUSENL' and ( kjilkftblked=1 or kjilkftblker=1)
) 
select /*+ ORDERED */ lp.*,b.sid , b.username, b.status, b.sql_address, b.sql_hash_value, 
b.PREV_SQL_ADDR, b.PREV_HASH_VALUE, b.module, 
b.module, b.ROW_WAIT_OBJ#,b.ROW_WAIT_FILE#, b.ROW_WAIT_BLOCK#, ROW_WAIT_ROW#
 from locked_pids lp,  gv$process a, gv$session b
where a.addr=b.paddr
and a.inst_id =b.inst_id
and lp.kjilkftpid=a.spid
and lp.inst_id=a.inst_id
;

