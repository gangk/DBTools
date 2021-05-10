col username for a10



SELECT a.sid, a.username, b.used_urec, b.used_ublk    FROM v$session a, v$transaction b 
WHERE a.saddr = b.ses_addr  ORDER BY b.used_ublk DESC;
