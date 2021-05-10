select s.sid, 'LATCH', 'Exclusive', 'None', rawtohex(laddr), ' '
    from v$process p, v$session s, v$latchholder h
   where h.pid  = p.pid                       /* 6 = exclusive, 0 = not held */
    and  p.addr = s.paddr
 union all                                         /* procs waiting on latch */
  select sid, 'LATCH', 'None', 'Exclusive', latchwait,' '
     from v$session s, v$process p
    where latchwait is not null
     and  p.addr = s.paddr
 union all                                            /* library cache locks */
  select  s.sid,
    decode(ob.kglhdnsp, 0, 'Cursor', 1, 'Table/Procedure/Type', 2, 'Body',
             3, 'trigger', 4, 'Index', 5, 'Cluster', to_char(ob.kglhdnsp))
          || ' Definition ' || lk.kgllktype,
    decode(lk.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
           to_char(lk.kgllkmod)),
    decode(lk.kgllkreq,  0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
           to_char(lk.kgllkreq)),
    decode(ob.kglnaown, null, '', ob.kglnaown || '.') || ob.kglnaobj ||
    decode(ob.kglnadlk, null, '', '@' || ob.kglnadlk),
    rawtohex(lk.kgllkhdl)
   from v$session s, x$kglob ob, dba_kgllock lk
     where lk.kgllkhdl = ob.kglhdadr
      and  lk.kgllkuse = s.saddr;
