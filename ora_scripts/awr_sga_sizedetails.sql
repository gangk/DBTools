SELECT TO_CHAR(A.END_INTERVAL_TIME,'DD-Mon-YY HH24:MI:SS') "Time"
     , ROUND(sum(bytes)/1024/1024) total
     , ROUND(sum(DECODE(pool,null, DECODE(name,'buffer_cache',bytes,0),0))/1024/1024) buffercache
     , ROUND(sum(DECODE(pool,'shared pool', bytes,0))/1024/1024) sharedpooltotal
     , ROUND(sum(DECODE(name,'free memory',bytes,0))/1024/1024) sharedpoolfree
     , ROUND(sum(DECODE(pool,'java pool', bytes,0))/1024/1024)   javapool
     , ROUND(sum(DECODE(pool,'large pool', bytes,0))/1024/1024)  largepool
     , ROUND(sum(DECODE(pool,'streams pool', bytes,0))/1024/1024) streamspool
     , ROUND(sum(DECODE(pool,null, DECODE(name,'fixed_sga',bytes,0),0))/1024/1024) fixedsga
     , ROUND(sum(DECODE(pool,null, DECODE(name,'log_buffer',bytes,0),0))/1024/1024) logbuffer
FROM DBA_HIST_SGAstat B, DBA_HIST_SNAPSHOT A
WHERE A.DBID = B.DBID
AND A.INSTANCE_NUMBER = B.INSTANCE_NUMBER
AND A.SNAP_ID = B.SNAP_ID
group by a.end_interval_time
ORDER BY a.end_interval_time ASC;