undef spid
select sid from v$session where paddr in (select addr from v$process where spid = &spid );
