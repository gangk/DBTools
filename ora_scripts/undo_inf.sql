@plusenv
col spid	format a5
col sid_serial	format a12
col orauser	format a18
col osuser	format a08
col sql_id	format a13
col lce_s	format 99999	head 'LCall|Elaps'
col tsec        format a06      head '   Tx|  Sec'
col starttm     format a09      trunc head 'StartTime'
col module	format a30	trunc
col rbs		format a23
col undo_mb	format 99,999.99
col actmb	format 999,999.9
col unexmb	format 999,999.9
col exmb	format 999,999.9

--with 	undo_spc as
--(
--select segment_name,  nvl(sum(act),0) actmb,    nvl(sum(unexp),0) unexmb, nvl(sum(exp),0) exmb
--from ( select segment_name,          nvl(sum(bytes/(1024*1024)),0) act,00 unexp, 00 exp from    DBA_UNDO_EXTENTS
--       where status='ACTIVE'  and tablespace_name in   (select tablespace_name from dba_tablespaces where contents='UNDO')
--       group by segment_name
--       union
--       select segment_name,00 act, nvl(sum(bytes/(1024*1024)),0) unexp, 00 exp from    DBA_UNDO_EXTENTS
--       where status='UNEXPIRED'  and tablespace_name in   (select tablespace_name from dba_tablespaces where contents='UNDO')
--       group by segment_name
--       union
--       select segment_name,            00 act, 00 unexp, nvl(sum(bytes/(1024*1024)),0) exp from    DBA_UNDO_EXTENTS
--       where status='EXPIRED'  and tablespace_name in   (select tablespace_name from dba_tablespaces where contents='UNDO')
--       group by segment_name
--      ) group by segment_name
--)
SELECT 	 r.name rbs
	--,actmb
	,NVL(s.username, 'None') orauser
	,TO_CHAR(s.sid)||','||TO_CHAR(s.serial#) as sid_serial
	,t.used_ublk * TO_NUMBER(x.value)/1024/1024 as undo_mb 
	,s.osuser
	,p.spid spid
	,s.last_call_et	lce_s
	,to_char(to_date(t.start_time,'MM/DD/YY HH24:MI:SS'),'MMDD-HH24MI')     starttm
	,lpad(round((sysdate - to_date(t.start_time,'MM/DD/YY HH24:MI:SS'))*24*60*60,1),6) tsec
	,s.sql_id
	,s.module
FROM 	 v$process 	p
	,v$rollname 	r
	,v$session 	s
	,v$transaction 	t
	--,undo_spc	u
	,v$parameter 	x 
WHERE 	 s.taddr 	= t.addr 
AND 	 s.paddr 	= p.addr(+) 
AND 	 r.usn 		= t.xidusn(+) 
AND 	 x.name 	= 'db_block_size' 
--AND	 r.name		= u.segment_name
--ORDER BY actmb
ORDER BY undo_mb
; 
