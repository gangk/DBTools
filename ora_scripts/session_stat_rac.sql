SELECT sn.inst_id,sn.name,ss.value
FROM   gv$sesstat ss,
       gv$statname sn,
       gv$session s
WHERE  ss.statistic# = sn.statistic#
AND    s.sid = ss.sid
AND    s.sid=&sid
AND    sn.inst_id=&inst_id
AND    sn.inst_id=s.inst_id
AND    sn.name LIKE '%' || DECODE(LOWER('&stat_name'), 'all', '', LOWER('&stat_name')) || '%';