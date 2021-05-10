rem librarycache_blkng_sess.sql  
rem--  find the blocking session holding library cache lock  
rem  input the SID of the session waiting for libary cache lock  
rem  
  
col saddr new_val SADDR_OF_BLOCKED_SESSION  
select saddr  from v$session where sid= &sid;  
  
col sid format 9999  
col username format a15  
col terminal format a10  
col program format a15  
 
SELECT SID,USERNAME,TERMINAL,PROGRAM FROM V$SESSION  
WHERE SADDR in  
(SELECT KGLLKSES FROM X$KGLLK LOCK_A  
WHERE KGLLKREQ = 0  
AND EXISTS (SELECT LOCK_B.KGLLKHDL FROM X$KGLLK LOCK_B  
WHERE KGLLKSES = '&SADDR_OF_BLOCKED_SESSION'  
AND LOCK_A.KGLLKHDL = LOCK_B.KGLLKHDL  
AND KGLLKREQ > 0)  
);  