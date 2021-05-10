accept sid prompt 'enter sid or hit enter for all:- '
SELECT a.sid,a.serial#,a.module,a.sql_id,a.event, a.username, b.xidusn, b.used_urec "records", b.used_ublk "blocks",b.used_ublk*8/1024 "Mb"
  FROM v$session a, v$transaction b
  WHERE a.saddr = b.ses_addr
  and
  a.sid like '%&sid%';
undef sid
