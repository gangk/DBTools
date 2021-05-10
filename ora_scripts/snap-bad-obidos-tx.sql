set echo off feed off verify off head off lines 140 pages 100
col seq		noprint
col txsec	noprint
col sid		format 9999
col serial#	format 99999
spool ${SQLDIR}/run-kill-bad-obidos-tx.sql
SELECT
	 1	seq
	,trunc((sysdate - to_date(t.start_time,'MM/DD/YY HH24:MI:SS')) * (24*60*60),0) txsec 
	,'-- mod='||substr(decode(s.module,null,'none    ',s.module),1,12)||
	 ' sid,ser'||'='||
	 s.sid||','||s.serial#||
	 ' user='||substr(s.osuser,1,7)||
	 ' mach='||substr(s.machine,1,instr(machine,'.')-1)||
	 ' PID='||s.process||
	 ' hash='||s.sql_hash_value||
	 ' txsec='||
	 trunc((sysdate - to_date(t.start_time,'MM/DD/YY HH24:MI:SS')) * (24*60*60),0)||
	 ' idlem='||trunc(s.last_call_et/60,0)||
	 ' began='||to_char(to_date(t.start_time,'MM/DD/YY HH24:MI:SS'),'MMDD HH24MISS')||
	 ' curr='||to_char(sysdate,'MMDD HH24MISS')
FROM
	 v$session 	s 
	,v$transaction 	t
WHERE 	 t.addr 	= s.taddr 
AND	 t.ses_addr 	= s.saddr
AND	 s.module	= 'obidos.so'
AND	 s.status	not in ('ACTIVE','KILLED')
AND      to_date(t.start_time,'MM/DD/YY HH24:MI:SS')   < (sysdate - &&1/(24*60))
UNION 
SELECT
	 2	seq
	,trunc((sysdate - to_date(t.start_time,'MM/DD/YY HH24:MI:SS')) * (24*60*60),0) txsec
	,'alter system kill session '||''''||
	 s.sid||','||s.serial#||''''||
	 ';'
FROM
	 v$session 	s 
	,v$transaction 	t
WHERE 	 t.addr 	= s.taddr 
AND	 t.ses_addr 	= s.saddr
AND	 s.module	= 'obidos.so'
AND	 s.status	not in ('ACTIVE','KILLED')
AND      to_date(t.start_time,'MM/DD/YY HH24:MI:SS')   < (sysdate - &&1/(24*60))
ORDER BY 1
	,2 desc
;
spool off
