select hladdr,  file#, dbablk, decode(state,1,'cur ',3,'CR',state) ST, tch
 from x$bh where hladdr in
  (select addr from  (select addr from v$latch_children  where addr='00000004A0A51780'
 order by sleeps, misses,immediate_misses desc )where rownum <2)
;
