select sid,p1raw,p2,p3,seconds_in_wait,wait_time,state from v$session_Wait where event='latch free' and 
state='WAITING' order by p2,p1raw;