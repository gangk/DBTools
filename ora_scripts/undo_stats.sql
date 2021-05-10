col "Program" format a40
col "Username" format a40
col "Current Date" format a50
col "RBS Name" format a40

col "OS User" format a15
col "DB User" format a15
col "SID" format a5
col "Schema" format a10
col "Object Name" format a20
col "Type" format a10
col "RBS" format a10
col "Used RBS Blocks" format a16
col "# of Records" format a18

col nm format a12 heading 'Name' trunc
col ex format 999 headin 'NrEx'
col rs format 999,999,999,999 heading 'Size'
col init format 999999999 heading 'Init'
col next format 999999999 heading 'Next'
col op format 999999999 heading 'Opt size'
col pct format 990 heading 'PctI'
col st format a4 heading 'Stat'
col sn format a15 heading 'Segm Name'
col ts format a12 heading 'In TabSpace'
col fn format a45 heading 'File containing header of rbs'
col ow format a4  heading 'Ownr'
col size format 999,999,999,999 heading 'Size'

prompt
prompt Undo Stats for Automatic Undo Management for Last 3 Hours

set lines 200
col begin_time format a18
col end_time format a18

select begin_time,end_time,activeblks,unexpiredblks,expiredblks,tuned_undoretention,txncount,maxquerylen,nospaceerrcnt
from v$undostat
where end_time > sysdate - 180/1440
order by end_time;

prompt
prompt
prompt Transactions Using Rolback:

select   substr(c.segment_name,1,10)    "RBS"
       , substr(a.os_user_name,1,15)    "OS User"
       , substr(a.oracle_username,1,15) "DB User"
       , substr(e.sid,1,5)              "SID"
       , substr(b.owner,1,10)           "Schema"
       , substr(b.object_name,1,20)     "Object Name"
       , substr(b.object_type,1,10)     "Type"
       , substr(d.used_ublk,1,16)       "Used RBS Blocks"
       , substr(d.used_urec,1,18)       "# of Records"
from     v$locked_object    a
       , dba_objects        b
       , dba_rollback_segs  c
       , v$transaction      d
       , v$session          e
where   a.object_id =  b.object_id
    and a.xidusn    =  c.segment_id
    and a.xidusn    =  d.xidusn
    and a.xidslot   =  d.xidslot
    and d.addr      =  e.taddr
order by "RBS"
;

