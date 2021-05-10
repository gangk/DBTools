col name format a20
col db_name format a20
col log_mode format a12
col  open_mode format a12

col version for a10
col HOST_NAME for a15
set lines 200
colu db_name format a15
colu StartTime format a20
colu SysDateTime format a20
select to_char(startup_time,'DD-MM-YYYY HH24:MI:SS') StartTime, to_char(sysdate,'DD-MM-YYYY HH24:MI:SS') SysDateTime, name db_name,log_mode, open_mode,HOST_NAME , VERSION from dual, v$database, v$instance
/