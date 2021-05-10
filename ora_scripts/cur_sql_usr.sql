-- to find out current query info by user
set lin 200
col UNAME for a32
col PROG for a35
col SID for a20
col SPID for a20
col SQLTEXT for A35

SELECT S.USERNAME || '(' || s.sid || ')-' || s.osuser UNAME,
         s.program || '-' || s.terminal || '(' || s.machine || ')' PROG,
         s.sid || '/' || s.serial# sid,
         s.status "Status",
         p.spid,
         sql_text sqltext
    FROM v$sqltext_with_newlines t, V$SESSION s, v$process p
   WHERE     t.address = s.sql_address
         AND p.addr = s.paddr(+)
         AND t.hash_value = s.sql_hash_value
         AND s.username = upper('&username')
ORDER BY s.sid, t.piece;
