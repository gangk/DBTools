prompt
prompt
prompt === mts queues (snap-mts-queues.sql) ===;

col dstat	format a8	trunc
col downed	format 9999
col avgwait	format 0.999999
SELECT   q.type                         qtype
        ,d.name                         dname
        ,d.status			dstat
        ,d.accept			dacc
        ,d.owned			downed
        ,sum(q.queued)                  queued
        ,sum(q.wait)                    totwait
        ,sum(q.totalq)                  tottime
        ,sum(q.wait)/sum(q.totalq)      avgwait
FROM     v$queue        q
        ,v$dispatcher   d
WHERE    q.paddr = d.paddr (+)
GROUP BY q.type
	,d.name
	,d.status
	,d.accept
	,d.owned
HAVING   sum(q.totalq) > 0
;
