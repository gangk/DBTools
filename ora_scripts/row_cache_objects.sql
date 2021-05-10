select latch#, child#, sleeps from v$latch_children where name='row cache objects' and sleeps>0 order by sleeps desc;
