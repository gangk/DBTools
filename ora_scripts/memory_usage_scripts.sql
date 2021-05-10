set echo off;
set feedback off;
set heading off;
set linesize 128;
set show off;
set pagesize 55;
set trimspool on;
set verify off;
column "SID AND SERIAL#" FORMAT A19
col SNAP_COLUMN new_value SNAP_TIME
col SNAP_EOF_NAME new_value EOF_NAME
col SNAP_HOST_NAME new_value THE_HOST_NAME
col SNAP_INSTANCE_NAME new_value THE_NAME_OF_THE_INSTANCE
col SNAP_RDBMS_VERSION new_value THE_RDBMS_VERSION
set term off;
select to_char(sysdate,'YYYYMMDD_HH24MISS') "SNAP_COLUMN" from dual;
select trim(host_name) "SNAP_HOST_NAME" from v$instance;
select trim(instance_name) "SNAP_INSTANCE_NAME" from v$instance;
select trim(version) "SNAP_RDBMS_VERSION" from v$instance;
select '&THE_NAME_OF_THE_INSTANCE'||'_'||'&SNAP_TIME'||'.LST' "SNAP_EOF_NAME" from dual;
drop table maxpgauga;
create table maxpgauga as select s.sid,
s2.serial#,
n.name,
s.value,
decode(s2.username,null,s2.program,s2.username) "USERNAME",
s2.logon_time
from v$statname n,
v$sesstat s,
v$session s2
where n.statistic# = s.statistic# and
(s.sid = s2.sid) and
name like 'session%memory max%';
drop table curpgauga;
create table curpgauga as select s.sid,
s2.serial#,
n.name,
s.value,
decode(s2.username,null,s2.program,s2.username) "USERNAME",
s2.logon_time
from v$statname n,
v$sesstat s,
v$session s2
where n.statistic# = s.statistic# and
(s.sid = s2.sid) and
name like 'session%memory' and
name not like 'session%memory max%';

set term on;

spool ORACLE_MEMORY_USAGE_SNAPSHOT_ & EOF_NAME

select 'Oracle Memory Usage Report: PGA And UGA Memory Usage Per Session' from dual;
select 'Host ........:'||'& THE_HOST_NAME' from dual;
select 'Name ........:'||'& THE_NAME_OF_THE_INSTANCE' from dual;
select 'Version .....:'||'& THE_RDBMS_VERSION' from dual;
select 'Startup Time:' | | to_char (min (logon_time), 'YYYY-MM-DD HH24: MI: SS') from curpgauga;
select 'Current Time:' | | to_char (sysdate, 'YYYY.MM.DD-HH24: MI: SS') from dual;
select 'Worst possible value of concurrent PGA + UGA memory usage per session:' from dual;
set heading on
select trim (to_char (sid ))||','|| trim (to_char (serial#)) "SID AND SERIAL#",
username "USERNAME OR PROGRAM",
sum (value),
to_char (logon_time, 'YYYY-MM-DD HH24: MI: SS') "SESSION START TIME"
from maxpgauga
group by sid,
serial#,
username,
logon_time
order by sum (value) desc;
set heading off
select 'Worst possible total and average values of concurrent PGA + UGA memory usage:' from dual;
select sum (value) | | 'bytes (total) and ~' | | trunc (avg (value ))||' bytes (average), for ~ '| | trunc (count (*) / 2) | |' sessions . 'from maxpgauga;
select 'Approximate value of current PGA + UGA memory usage per session:' from dual;
set heading on
select trim (to_char (sid ))||','|| trim (to_char (serial#)) "SID AND SERIAL#",
username "USERNAME OR PROGRAM",
sum (value),
to_char (logon_time, 'YYYY-MM-DD HH24: MI: SS') "SESSION START TIME"
from curpgauga
group by sid,
serial#,
username,
logon_time
order by sum (value) desc;
set heading off
select 'Current total and average values of concurrent PGA + UGA memory usage:' from dual;
select sum (value) | | 'bytes (total) and ~' | | trunc (avg (value ))||' bytes (average), for ~ '| | trunc (count (*) / 2) | |' sessions . 'from curpgauga;
select 'Maximum value of PGA memory usage per session:' from dual;
set heading on
select trim (to_char (sid ))||','|| trim (to_char (serial#)) "SID AND SERIAL#",
username "USERNAME OR PROGRAM",
value,
to_char (logon_time, 'YYYY-MM-DD HH24: MI: SS') "SESSION START TIME"
from maxpgauga
where name like 'session pga memory max%'
order by value desc, sid desc;
set heading off
select 'Worst possible total and average values of concurrent PGA memory usage:' from dual;
select sum (value) | | 'bytes (total) and ~' | | trunc (avg (value ))||' bytes (average), for ~ '| | count (*)||' sessions.' from maxpgauga where name like 'session pga memory max%';
select 'Maximum value of UGA memory usage per session:' from dual;
set heading on
select trim (to_char (sid ))||','|| trim (to_char (serial#)) "SID AND SERIAL#",
username "USERNAME OR PROGRAM",
value,
to_char (logon_time, 'YYYY-MM-DD HH24: MI: SS') "SESSION START TIME"
from maxpgauga
where name like 'session uga memory max%'
order by value desc, sid desc;
set heading off
select 'Worst possible total and average values of concurrent UGA memory usage:' from dual;
select sum (value) | | 'bytes (total) and ~' | | trunc (avg (value ))||' bytes (average), for ~ '| | count (*)||' sessions.' from maxpgauga where name like 'session uga memory max%';
select 'Current value of PGA memory usage per session:' from dual;
set heading on
select trim (to_char (sid ))||','|| trim (to_char (serial#)) "SID AND SERIAL#",
username "USERNAME OR PROGRAM",
value,
to_char (logon_time, 'YYYY-MM-DD HH24: MI: SS') "SESSION START TIME"
from curpgauga
where name like 'session pga memory%'
order by value desc, sid desc;
set heading off
select 'Current total and average values of concurrent PGA memory usage:' from dual;
select sum (value) | | 'bytes (total) and ~' | | trunc (avg (value ))||' bytes (average), for ~ '| | count (*)||' sessions.' from curpgauga where name like 'session pga memory%';
select 'Current value of UGA memory usage per session:' from dual;
set heading on
select trim (to_char (sid ))||','|| trim (to_char (serial#)) "SID AND SERIAL#",
username "USERNAME OR PROGRAM",
value,
to_char (logon_time, 'YYYY-MM-DD HH24: MI: SS') "SESSION START TIME"
from curpgauga
where name like 'session uga memory%'
order by value desc, sid desc;
set heading off
select 'Current total and average values of concurrent UGA memory usage:' from dual;
select sum (value) | | 'bytes (total) and ~' | | trunc (avg (value ))||' bytes (average), for ~ '| | count (*)||' sessions.' from curpgauga where name like 'session uga memory%';
select 'Current SGA structure sizings:' from dual;
show sga
select 'Some initialization parameter values at instance startup:' from dual;
select trim (name )||'='|| value
from v$parameter
where name in ('__shared_pool_size',
'Large_pool_size',
'Pga_aggregate_target',
'Sga_target',
'Shared_pool_size',
'Sort_area_size',
'Streams_pool_size') order by name;
select 'Current Time:' | | TO_CHAR (sysdate, 'YYYY.MM.DD-HH24: MI: SS') from dual;
spool off
set feedback on;
set heading on;
set linesize 80;
set pagesize 14;
set verify on;
set echo on; 