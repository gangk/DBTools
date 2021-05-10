select s.username "Oracle User",s.osuser "OS User",i.consistent_gets "Consistent Gets",
i.physical_reads "Physical Reads",s.status "Status",s.sid "SID",s.serial# "Serial#",
s.machine "Machine",s.program "Program",to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') "Logon Time",
w.seconds_in_wait "Idle Time", P.SPID "PROC",
name "Stat CPU", value
from v$session s, v$sess_io i, v$session_wait w, V$PROCESS P, v$statname n, v$sesstat t
where s.sid = i.sid
and s.sid = w.sid (+)
and 'SQL*Net message from client' = w.event(+)
and s.osuser is not null
and s.username is not null
and s.paddr=p.addr
and n.statistic# = t.statistic#
and n.name like '%cpu%'
and t.SID = s.sid
order by 6 asc, 3 desc, 4 desc
/
