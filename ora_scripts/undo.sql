select a.sid,b.USED_UBLK,b.USED_UREC from v$session a,v$transaction b where a.taddr=b.addr;

select s.sid,t.USED_UBLK*8192/1024  KBytes from v$transaction t,v$session s where t.addr = s.taddr ;

