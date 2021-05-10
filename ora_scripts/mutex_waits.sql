col sid format 99999999
col serial# noprint format 99999999
col event format a35
col blocking_sid heading "BLKS" format 9999999
col shared_refcount heading "RFC" format 99
col location_id heading "LOC" format 99
col sleeps  noprint format 99999
col mutex_object format a40

 
SELECT SID,serial#,sql_id,event,p1 idn,
            FLOOR (p2/POWER(2,4*ws)) blocking_sid,MOD (p2,POWER(2,4*ws)) shared_refcount,
            FLOOR (p3/POWER (2,4*ws)) location_id,MOD (p3,POWER(2,4*ws)) sleeps,
            CASE WHEN (event LIKE 'library cache:%' AND p1 <= power(2,17)) THEN  'library cache bucket: '||p1 
                    ELSE  (SELECT kglnaobj FROM x$kglob WHERE kglnahsh=p1 AND (kglhdadr = kglhdpar) and rownum=1) END mutex_object
       FROM (SELECT DECODE (INSTR (banner, '64'), 0, '4', '8') ws FROM v$version WHERE ROWNUM = 1) wordsize, 
                  v$session 
       WHERE p1text='idn' AND state='WAITING';
