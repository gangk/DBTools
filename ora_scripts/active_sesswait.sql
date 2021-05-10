col username for a25
col spid for a10
col osuser a15
col event a30

select distinct last_call_et,s.username,spid,sw.sid,osuser,event,sql_text from v$session_wait sw,v$sql q,v$session s ,v$process p
where sw.sid=s.sid
--and s.sid=364
and s.paddr=p.addr
and s.sql_address=q.address(+)
and s.status='ACTIVE'
and s.username is not null
order by 1 desc
/