prompt check Start;

set serveroutput on size 1000000
set termout off
set lines 1000
set pages 0
set head off
set timing off
set feedback off
col bytes for 999999999999999.99
col value for 999999999999999.99
break on grantee
col filename new_value fname
col spoolfile new_value spf

select 'D:\clover\cloverdba\check\' filename from dual;
select '&fname' || 'CHECK_' || name || '_' || trunc(sysdate) || '.html' spoolfile from dual,V$database;
spool &spf

select '<body bgcolor="f7f7d7"><BR><CENTER><FONT FACE="VERDANA" SIZE=4>DATABASE HEALTH CHECKUP REPORT</FONT>
<BR><BR><B><FONT FACE="VERDANA" SIZE=1>PREPARED BY</FONT></B>
<BR><BR><FONT FACE="VERDANA" SIZE=4>CLOVER TECHNOLOGIES PVT. LTD.</FONT></CENTER><br><hr>' from dual;

select '<br><FONT FACE="VERDANA" SIZE=2  color="#0000FF">Created on : ' || 
to_char(sysdate,'DD-MON-YYYY:HH24:MI:SS') || ' </font> <BR>' from dual;


select '<BR><FONT FACE="VERDANA" SIZE=4>Database Information : <BR><BR></FONT>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">ID
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">CREATED
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">LOG MODE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">OPEN MODE' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || dbid ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || created ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || log_mode ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || open_mode from v$database;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Instance Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">INSTANCE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">HOST NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">VERSION
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || instance_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || host_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || version ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || status from v$instance;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Control File Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">NAME' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || name from v$controlfile;
select '</table><br>' from dual;
select '<FONT FACE="VERDANA" SIZE=4>Redo Logs Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">GROUP
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">THREAD
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SEQUENCE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">BYTES (in KB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MEMBERS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">ARCHIVED
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || group# ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || thread# ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || sequence# ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || bytes/1024 ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || members ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || archived ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || status from v$log;
select '</table><br>' from dual;

select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">GROUP
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MEMBER
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || group# ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || member ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || status from v$logfile;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>User Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">USER NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">ACCOUNT STATUS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">DEFAULT TABLESPACE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TEMPORARY TABLESPACE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">USER CREATED ON
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">PROFILE' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || username ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || account_status ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || default_tablespace ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || temporary_tablespace ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || created ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || profile from dba_users order by username;
select '</table>' from dual;
select '<BR><FONT FACE="VERDANA" SIZE=4>Password File Users Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">USERNAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SYSDBA
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SYSOPER' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || username ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || sysdba ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || sysoper from v$pwfile_users;
select '</table>' from dual;
select '<BR><FONT FACE="VERDANA" SIZE=4>Profile Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">PROFILE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">RESOURCE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">RESOURCE TYPE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">LIMIT' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || profile ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || resource_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || resource_type ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || limit from dba_profiles order by profile,resource_type;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Tablespace Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TABLESPACE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">INITIAL EXTENT
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">NEXT EXTENT
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MIN EXTENTS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MAX EXTENTS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">CONTENTS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">EXTENT MANAGEMENT' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || tablespace_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || initial_extent ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || next_extent ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || min_extents ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || max_extents ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || status ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || contents ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || extent_management from dba_tablespaces order by tablespace_name;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Tablespace Free Space Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TABLESPACE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TOTAL SPACE (in MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">USED SPACE (in MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">FREE SPACE (in MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MAX FREE SPACE (in MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">USED SPACE(%)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">FREE SPACE(%)' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || f.tablespace_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || a.total ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || u.used ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || f.free ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || f.maxfree ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round((u.used/a.total)*100) ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round((f.free/a.total)*100) 
from
(select tablespace_name, sum(bytes/(1024*1024)) total from dba_data_files group by tablespace_name) a,
(select tablespace_name, round(sum(bytes/(1024*1024))) used from dba_extents group by tablespace_name) u,
(select tablespace_name, round(sum(bytes/(1024*1024))) free,round(max(bytes)/1024/1024) maxfree from dba_free_space group by tablespace_name) f
WHERE a.tablespace_name = f.tablespace_name
and a.tablespace_name = u.tablespace_name
order by f.free;
select '</table>' from dual;


select '<BR><FONT FACE="VERDANA" SIZE=4>Data File Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TABLESPACE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">FILE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">BYTES (in MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">BLOCKS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">AUTO EXTENSIBLE' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || tablespace_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || file_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || bytes/1024/1024 ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || blocks ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || status ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || autoextensible from dba_data_files order by tablespace_name;
select '</table>' from dual;
select '<BR><FONT FACE="VERDANA" SIZE=4>Temporary File Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TABLESPACE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">FILE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">BYTES (in MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">BLOCKS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">AUTO EXTENSIBLE' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || tablespace_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || file_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || bytes/1024/1024 ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || blocks ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || status ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || autoextensible from dba_temp_files order by tablespace_name;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Objects which can grow : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">OWNER
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SEGMENT NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SEGMENT TYPE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TABLESPACE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">INITIAL EXTENT
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">NEXT EXTENT
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MIN EXTENTS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MAX EXTENTS' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.OWNER ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.SEGMENT_NAME ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.SEGMENT_TYPE ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.TABLESPACE_NAME ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.INITIAL_EXTENT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.NEXT_EXTENT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.MIN_EXTENTS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || S.MAX_EXTENTS FROM DBA_SEGMENTS  S 
WHERE next_extent > (select MAX(f.bytes) from dba_free_space f where f.tablespace_name = s.tablespace_name);
select '</table>' from dual;


select '<BR><FONT FACE="VERDANA" SIZE=4>Database Size Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">PHYSICAL SIZE (IN MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">ACTUAL SIZE (IN MB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SGA SIZE (IN MB)' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || PHY.SZ ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || ACT.SZ ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || SGA.SZ FROM 
(SELECT TO_CHAR(SUM(BYTES)/1024/1024,9999999.99) "SZ" FROM DBA_DATA_FILES) PHY,
(SELECT TO_CHAR(SUM(BYTES)/1024/1024,9999999.99) "SZ" FROM DBA_SEGMENTS) ACT,
(SELECT TO_CHAR(SUM(VALUE)/1024/1024,9999999.99) "SZ" FROM V$SGA) SGA;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Memory Information (SGA): <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">VALUE (in KB)' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>DB BUFFER
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || 
decode (((select value from v$parameter where name='db_block_size')*(select value from v$parameter where name='db_block_buffers')/1024),0,
(select value/1024 from v$parameter where name='db_cache_size')) from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>LOG BUFFER
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round(value/1024,2) from v$parameter where name='log_buffer';
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>JAVA POOL SIZE
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round(value/1024,2) from v$parameter where name='java_pool_size';
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>LARGE POOL SIZE
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round(value/1024,2) from v$parameter where name='large_pool_size';
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>SHARED POOL SIZE
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round(value/1024,2) from v$parameter where name='shared_pool_size';
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>SORT AREA SIZE
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round(value/1024,2) from v$parameter where name='sort_area_size';
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>PGA AGGREGATE TARGET
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || round(value/1024,2) from v$parameter where name='pga_aggregate_target';
select '</table>' from dual;


select '<BR><FONT FACE="VERDANA" SIZE=4>Hit Ratios : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SORT 
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">INDEX LOOKUP
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">LIBRARY CACHE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">DATA DICTIONARY
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">BUFFER CACHE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">REDO LOG
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">LRU
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">PIN HIT' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || SO.HIT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || IND.HIT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || LI.HIT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || DA.HIT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || BU.HIT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || RE.HIT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || LR.HIT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || PI.HIT FROM 
(SELECT TO_CHAR((1-d.VALUE/m.value)*100,999.99) "HIT" FROM V$SYSsTAT d,v$sysstat m  WHERE d.name ='sorts (disk)' and m.name='sorts (memory)') SO,
(SELECT TO_CHAR((1-l.VALUE/(l.value+s.value))*100,999.99) "HIT" FROM V$SYSsTAT l,v$sysstat s WHERE s.name ='table scans (short tables)' and l.name= 'table scans (long tables)') IND,
(SELECT TO_CHAR(sum(gethitratio)/count(*) *100,999.99) "HIT" from v$librarycache) LI,
(select TO_CHAR((1-(sum(getmisses)/sum(gets)))*100,999.99) "HIT" from v$rowcache) DA,
(SELECT TO_CHAR((1-PHY.VALUE/(cur.value+con.value))*100,999.99) "HIT" from v$sysstat phy,v$sysstat con,v$sysstat cur where cur.name='db block gets' and con.name='consistent gets' and phy.name='physical reads') BU,
(SELECT TO_CHAR((1-(re.value/r.value ))*100,999.99)  "HIT" from v$sysstat re ,v$sysstat r where re.name ='redo buffer allocation retries' and r.name='redo entries') RE,
(SELECT TO_CHAR((1-sleeps/gets)*100,999.99) "HIT" from v$latch where name ='cache buffers lru chain') LR,
(SELECT TO_CHAR((1- SUM(RELOADS)/SUM(PINS))*100,999.99) "HIT" FROM V$LIBRARYCACHE) PI;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Library Cache Details : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">GETS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">GET HITS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">GETHIT RATIO
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">PINS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">PIN HITS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">PIN HIT RATIO
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">RELOADS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">INVALIDATIONS' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || GETS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || GETHITS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || TO_CHAR(GETHITRATIO,999.99) ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || PINS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || PINHITS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || TO_CHAR(PINHITRATIO,999.99) ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || RELOADS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || INVALIDATIONS from v$librarycache;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Wait Statistics : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">CLASS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">COUNT
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TIME' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || CLASS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || COUNT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || TIME from v$WAITSTAT;
select '</table><BR><BR>' from dual;

select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">VALUE' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || NAME ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || VALUE from V$SYSSTAT WHERE NAME IN
('redo buffer allocation retries','redo entries','redo log space requests');
select '</table><BR><BR>' from dual;

select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">EVENT
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TOTAL WAITS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TIME WAITED
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">AVERAGE WAIT' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || EVENT ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || TOTAL_WAITS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || TIME_WAITED ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || AVERAGE_WAIT from v$SYSTEM_EVENT;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Rollback Segment Details : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">USN
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SEGMENT NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TABLESPACE NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">WRITES
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">GETS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">WAITS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">OPTIMAL (IN KB)
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">HWM SIZE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">SHRINKS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">WRAPS
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.USN ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || B.SEGMENT_NAME ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || B.TABLESPACE_NAME ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.WRITES ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.GETS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.WAITS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || NVL(A.OPTSIZE/1024,0) ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.HWMSIZE ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.SHRINKS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.WRAPS ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || A.STATUS from V$ROLLSTAT A,DBA_ROLLBACK_SEGS B WHERE A.USN=B.SEGMENT_ID;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Resource Limit Details : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">RESOURCE LIMIT
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">CURRENT UTILIZATION
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">MAX UTILIZATION
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">INITIAL ALLOCATION
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">LIMIT VALUE' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || RESOURCE_NAME ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || CURRENT_UTILIZATION ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || MAX_UTILIZATION ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || INITIAL_ALLOCATION ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || LIMIT_VALUE from v$resource_limit;
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Invalid Objects Information : <BR><BR>' from dual;
select '<table border=1 cellpadding=2 cellspacing=1>' from dual;
select 
'<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">OWNER
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">NAME
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">TYPE
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">CREATED
<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">STATUS' from dual;
select '<tr>
<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || owner ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || object_name ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || object_type ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || created ||
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || status from dba_objects where status<>'VALID';
select '</table>' from dual;

select '<BR><FONT FACE="VERDANA" SIZE=4>Users Number of Objects Information : <BR><BR>' from dual;
declare
cnt number(5);
begin
	dbms_output.put_line('<table border=1 cellpadding=2 cellspacing=1><th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">USERNAME');
		for z in (select distinct object_type from dba_objects) loop
			dbms_output.put_line('<th bgcolor="#000951"><FONT FACE="VERDANA" SIZE=1 COLOR="#FFFFFF">' || z.object_type || '</td>');
		end loop;
	for x in (select username from dba_users) loop
		dbms_output.put_line('<tr><td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || x.username);
		for y in (select distinct object_type from dba_objects) loop
			select count(object_name) into cnt from dba_objects where owner=x.username and object_type=y.object_type;
			dbms_output.put_line('<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>' || cnt);
		end loop;
		dbms_output.put('</tr>');
		end loop;
	dbms_output.put_line('</table>');
end;
/
select '<BR><FONT FACE="VERDANA" SIZE=4>REDO LOG SWITCH HISTORY:<BR><BR>' from dual;
select '<RIGHT><table border=1 > <tr>' from dual;
	select '<B><th bgcolor="gray"><tr bgcolor="gray">
		<TD>DAY</TD>
		<TD>00-hrs</TD>
		<TD>01-hrs</TD>
		<TD>02-hrs</TD>
		<TD>03-hrs</TD>
		<TD>04-hrs</TD>
		<TD>05-hrs</TD>
		<TD>06-hrs</TD>
		<TD>07-hrs</TD>
		<TD>08-hrs</TD>
		<TD bgcolor="green">09-hrs</TD>
		<TD bgcolor="green">10-hrs</TD>
		<TD bgcolor="green">11-hrs</TD>
		<TD bgcolor="green">12-hrs</TD>
		<TD bgcolor="green">13-hrs</TD>
		<TD bgcolor="green">14-hrs</TD>
		<TD bgcolor="green">15-hrs</TD>
		<TD bgcolor="green">16-hrs</TD>
		<TD bgcolor="green">17-hrs</TD>
		<TD>18-hrs</TD>
		<TD>19-hrs</TD>
		<TD>20-hrs</TD>
		<TD>21-hrs</TD>
		<TD>22-hrs</TD>
		<TD>23-hrs</TD>
		</tr></th></B>' 
	from dual;
	SELECT 	'<tr><td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'||substr(to_char(FIRST_TIME,'DY, YYYY/MM/DD'),1,15) ||'</td>' dat,
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'||decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'||decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0)))||'</td>',
'<td bgcolor="#ccccff"><FONT FACE="VERDANA" SIZE=2>'|| decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0)))||'</td>'
from     v$log_history
where first_time between (sysdate -16 ) and (sysdate - 1)
group by substr(to_char(FIRST_TIME,'DY, YYYY/MM/DD'),1,15)
order by substr(dat,14,15);
	
select  '</tr></table></RIGHT>' from dual;
select '<br>
	<CENTER>
	<FONT COLOR="RED">
	<BIG>
	<B>***********END OF REPORT**********</B>
	</BIG>
	</FONT>
	</CENTER>
	</br>' from dual;

set termout on;
set heading on;
set feedback on;
spool off;

prompt check Stop;

