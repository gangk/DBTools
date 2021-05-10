set lines 170 

--SELECT (UR * (UPS * DBS)) + (DBS * 24) AS "Bytes" 
--FROM (SELECT value AS UR FROM v$parameter WHERE name = 'undo_retention'), 
--(SELECT (SUM(undoblks)/SUM(((end_time - begin_time)*86400))) AS UPS FROM v$undostat), 
--(SELECT value AS DBS FROM v$parameter WHERE name = 'db_block_size') ;

col spid	format a5
col sid_serial	format a12
col orauser	format a18
col osuser	format a08
col sql_id	format a13
col module	format a30	trunc
col rbs		format a25

SELECT r.name rbs, 
NVL(s.username, 'None') orauser, 
s.osuser, 
TO_CHAR(s.sid)||','||TO_CHAR(s.serial#) as sid_serial, 
p.spid spid, 
s.sql_id,
s.module,
t.used_ublk * TO_NUMBER(x.value)/1024 as undo_kb 
FROM v$process p, 
v$rollname r, 
v$session s, 
v$transaction t, 
v$parameter x 
WHERE s.taddr = t.addr 
AND s.paddr = p.addr(+) 
AND r.usn = t.xidusn(+) 
AND x.name = 'db_block_size' 
ORDER 
BY r.name ; 

select l.sid, s.segment_name from dba_rollback_segs s, v$transaction t, v$lock l 
where t.xidusn=s.segment_id and t.addr=l.addr ;

col machine format A55
col username format A20
col xidusn format 9999
col xidslot format 999
col sid		format 9999
col spid	format a5
col status	format a06

select xidusn, xidslot, trans.status, start_time, ses.sid, proc.spid, ses.username, ses.machine , used_ublk 
from v$transaction trans, v$session ses , v$process proc 
where trans.ses_addr =ses.saddr and ses.paddr=proc.addr 
order by start_time ;

select to_char(begin_time,'hh24:mi:ss'),to_char(end_time,'hh24:mi:ss') 
, maxquerylen,ssolderrcnt,nospaceerrcnt,undoblks,txncount from v$undostat 
order by begin_time ;

col owner format a08
col segment_name format a25 heading 'Segment Name' 
col segment_type format a15 heading 'Segment Type' 
col tablespace_name format a15 heading 'Tablespace Name' 
col extents format 99999999 heading 'Extent' 
col mb	format 99,999.9

col stype	format a10
col tsname	format a08
col pctincr	format 999
select 	 segment_name
	,segment_type		stype
	,tablespace_name	tsname
	,initial_extent		iniext
	,next_extent		nextext
	,pct_increase		pctincr
	,(bytes / 1048576) mb
	,max_size		maxsize
	,extents 
	,max_extents 
from 	 sys.dba_segments 
where 	 tablespace_name in (select tablespace_name from dba_tablespaces where contents='UNDO')
order by segment_name
;
select segment_name,  nvl(sum(act),0) "ACT BYTES",    nvl(sum(unexp),0) "UNEXP BYTES", nvl(sum(exp),0) "EXP BYTES"
from ( select segment_name,          nvl(sum(bytes),0) act,00 unexp, 00 exp
       from    DBA_UNDO_EXTENTS
       where status='ACTIVE'  and tablespace_name in   (select tablespace_name from dba_tablespaces where contents='UNDO')
       group by segment_name
       union
       select segment_name,00 act, nvl(sum(bytes),0) unexp, 00 exp from    DBA_UNDO_EXTENTS
       where status='UNEXPIRED'  and tablespace_name in   (select tablespace_name from dba_tablespaces where contents='UNDO')
       group by segment_name
       union
       select segment_name,            00 act, 00 unexp, nvl(sum(bytes),0) exp
       from    DBA_UNDO_EXTENTS
       where status='EXPIRED'  and tablespace_name in   (select tablespace_name from dba_tablespaces where contents='UNDO')
       group by segment_name
      ) group by segment_name;

