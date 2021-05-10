select s.inst_id,s.sid,s.serial#,s.status,s.machine,s.program,t.used_ublk,
(sysdate - to_date(t.start_time, 'MM/DD/YY HH24:MI:SS')) * 24 as hours_active,
t.used_urec from gv$session s,gv$transaction t where s.taddr=t.addr;
