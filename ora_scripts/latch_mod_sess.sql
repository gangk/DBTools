col module for a25
select a.sid,b.module,a.p1raw,a.p2,a.p3,a.seconds_in_wait,a.wait_time,a.state from v$session_Wait a , v$session b where a.sid=b.sid and 
a.event='latch free' and
a.state='WAITING' order by p2,p1raw
/