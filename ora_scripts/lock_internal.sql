define __SID = "&1"

col handle format a10
col type format a2

-- enqueue
select
  sid,
  type,
  '('||id1||','||id2||')' as "handle",
  lmode as "mod",
  request as "req"
from v$lock
where sid in (&__SID)
union all
-- library cache lock
select
  (select sid from v$session where saddr = kgllkuse) as sid,
  'LK' as "type", 
  kgllkhdl||'' as "handle",
  kgllkmod as "mod",
  kgllkreq as "req"
from sys.xm$kgllk
where kgllkuse in (select saddr from v$session where sid in (&__SID))
  and (kgllkmod > 0 or kgllkreq > 0)
union all
-- library cache pin
select
 (select sid from v$session where saddr = kglpnuse) as sid,
  'LN' as "type",
 kglpnhdl||'' as "handle", 
  kglpnmod as "mod",
  kglpnreq as "req"
from sys.xm$kglpn
where kglpnuse in (select saddr from v$session where sid in (&__SID))
  and (kglpnmod > 0 or kglpnreq > 0)
;
