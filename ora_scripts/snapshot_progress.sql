column mvowner format a10 
Column mvname format a30 
column refmode format a8 
column refstate format a12 
column inserts format 99999999 
column updates format 9999999 
column deletes format 9999999 
column total format 9999999
column event format a30 
column spid format a8 heading "OS|Process"
select  currmvowner_knstmvr mvowner, 
currmvname_knstmvr mvname, 
decode( reftype_knstmvr, 0, 'FAST', 1, 'FAST', 2, 'COMPLETE', REFTYPE_KNSTMVR ) refmode, 
decode(groupstate_knstmvr, 1, 'SETUP', 2, 'INSTANTIATE',3, 'WRAPUP', 'UNKNOWN' ) refstate, 
total_inserts_knstmvr inserts, 
total_updates_knstmvr updates, 
total_deletes_knstmvr deletes, 
total_inserts_knstmvr + total_updates_knstmvr + total_deletes_knstmvr total,
a.sid,b.spid,c.event 
from x$knstmvr X, v$session a, v$process b, v$session_wait c 
WHERE type_knst=6 
and a.paddr = b.addr 
and a.sid = c.sid 
and x.SID_KNST = a.sid 
and x.SERIAL_KNST = a.serial#; 



