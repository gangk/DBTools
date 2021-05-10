rem librarycache_blked_sess.sql  
rem  
remfind the blocked sessions waiting for library cache lock  
reminput the SID of the bocking session  
remrun as sysdba  
rem ref: ML122793.1  
  
col saddr new_val SADDR_OF_BLKING_SESS  
select saddr  from v$session where sid= &sid;  
 
set linesize 120  
col sid format 9999  
col username format a15  
col terminal format a10  
col program format a15  
 
SELECT SID,USERNAME,TERMINAL,PROGRAM FROM V$SESSION  
WHERE SADDR in  
(SELECT KGLLKSES FROM X$KGLLK LOCK_A  
WHERE KGLLKREQ > 0  
AND EXISTS (SELECT LOCK_B.KGLLKHDL FROM X$KGLLK LOCK_B  
WHERE KGLLKSES = '&SADDR_OF_BLKING_SESS'  
AND LOCK_A.KGLLKHDL = LOCK_B.KGLLKHDL  
AND KGLLKREQ = 0)  
);  