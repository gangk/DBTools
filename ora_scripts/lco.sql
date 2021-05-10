set serveroutput on
set echo off

begin
  print_table('
select
  kglhdadr,
  kglnaobj,
  kglnaown,
  case when kglhdadr = kglhdpar then ''Parent'' else ''Child'' end as type,
  k.sid as lock_holder,
  k.kgllkmod,
  k.kgllkreq,
  p.sid as pin_holder,
  p.kglpnmod,
  p.kglpnreq
from
  sys.xm$kglob o,
  (select s.sid, k.kgllkhdl, k.kgllkmod, k.kgllkreq
    from v$session s, sys.xm$kgllk k
    where s.saddr = k.kgllkuse) k,
  (select s.sid, p.kglpnhdl, p.kglpnmod, p.kglpnreq
    from v$session s, sys.xm$kglpn p
    where s.saddr = p.kglpnuse) p
where
  o.kglhdadr like ''&1''
  and o.kglnaobj like ''&2''
  and o.kglhdadr = k.kgllkhdl(+)
  and o.kglhdadr = p.kglpnhdl(+)
  ');
end;
/