column sid for 999999
column spid for 999999
column client_info for a30
column event for a40

SELECT s.SID,s.SERIAL#,p.SPID,s.CLIENT_INFO,s.event,s.seconds_in_wait secs,s.p1,s.p2,s.p3
  FROM GV$PROCESS p, GV$SESSION s
  WHERE p.ADDR = s.PADDR
  and CLIENT_INFO like 'rman channel=%';
