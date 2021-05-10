set verify off
select
   (select sid from v$session where saddr = kglpnuse) as sid,
    'LN' as "type",
   kglpnhdl||'' as "handle", 
    kglpnmod as "mod",
    kglpnreq as "req",
    (select substr(kglnaobj, 1, 60) from sys.x$kglob 
       where kglhdadr = kglpnhdl and rownum = 1) as name
  from sys.x$kglpn
  where kglpnuse in (select saddr from v$session where sid = &sid_number)
;
