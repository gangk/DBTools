set linesize 180 pagesize 1000
col pu for a8 heading 'O/S|Login' justify left
col su for a20 heading 'Oracle User ID' justify left
col stat for a8 heading 'Session|Status' justify left
col ssid for 999999 heading 'Oracle|Session|ID' justify right
col sser for 999999 heading 'Oracle|Serial|No' justify right
col spid for 999999 heading 'UNIX|PID' justify right
col txt for a60 trunc
--col txt for a60 trunc heading 'Current Statment' justify center word
--spool pid_sid.lst
SELECT p.username pu,s.username su,s.status stat,s.sid ssid,s.serial# sser,
lpad(p.spid,7) spid,substr(sa.sql_text,1,540) txt 
FROM V$PROCESS p, V$SESSION s, V$SQLAREA sa 
WHERE p.addr=s.paddr AND s.username is not null 
AND s.sql_address=sa.address(+) 
and s.sid=&mysid
AND s.sql_hash_value=sa.hash_value(+) 
ORDER BY 1,2,7;
