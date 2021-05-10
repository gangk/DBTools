select s.sid, s.username, lc.addr, lc.latch#, lc.child#, lc.level#, 
lc.name, lc.gets,
decode(gets,0,0,round(100*(gets-misses)/gets,2)) hitratio, 
decode(immediate_gets, 0,0, 
round(100*(immediate_gets-immediate_misses)/immediate_gets,2)) 
immed_hitratio,
decode(gets,0,0,round(100*sleeps/gets,2)) pct_sleeps, 
waiters_woken, waits_holding_latch, spin_gets,
sleep1, sleep2, sleep3, sleep4, sleep5
from v$latch_children lc, v$session_wait w, v$session s
where latch#=w.p2 and lc.addr=w.p1raw
and s.sid=w.sid
;
