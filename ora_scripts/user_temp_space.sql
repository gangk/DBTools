COLUMN tablespace FORMAT A20
COLUMN temp_size FORMAT A20
COLUMN sid_serial FORMAT A20
COLUMN username FORMAT A20
COLUMN program FORMAT A40
SET LINESIZE 200

SELECT b.tablespace,
       ROUND(((b.blocks*p.value)/1024/1024),2)||'M' AS temp_size,
       a.sid||','||a.serial# AS sid_serial,
       NVL(a.username, '(oracle)') AS username,
       a.program
FROM   v$session a,
       v$sort_usage b,
       v$parameter p
WHERE  p.name  = 'db_block_size'
AND    a.saddr = b.session_addr
ORDER BY b.tablespace, b.blocks;
