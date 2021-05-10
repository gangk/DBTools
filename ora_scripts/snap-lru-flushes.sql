prompt
prompt
prompt === shared pool LRU flushes (snap-lru-flushes.sql) ===;

col objname     format a32      trunc
col alloctype   format a30      trunc
col objsize     format 99999
col flushes     format 99999
col sid         format 99999
col module      format a30      trunc
col hashvalue   format 999999999999
col orauser     format a08	trunc
col indx        format 99	head 'IX' 
col inst_id     format 9	head 'IN'

col ksmlrsiz    format 99999999
col ksmlrnum    format 999999
col KGHLUFSH	format 9999999	head 'Flushes'
col KGHLUOPS	format 99999999999
col KGHLURCR	format 9999999
col KGHLUTRN	format 9999999
col KGHLUMXA	format 9999999
col KGHLUMES	format 9999999
col KGHLUMER	format 9999999
col KGHLURCN	format 9999999
col KGHLURMI	format 9999999
col KGHLURMZ	format 9999999
col KGHLURMX	format 9999999
col KGHLUNFU	format 99999	head '04031|Errors'
col KGHLUNFS	format 99999	head 'Error|Size'

SELECT   *
FROM     x$kghlu
;

SELECT   a.ksmlrhon             objname
        ,a.ksmlrcom             alloctype
        ,a.ksmlrsiz             objsize
        ,a.ksmlrnum             flushes
        ,b.sid
        ,b.username             orauser
        ,b.module
        ,b.sql_hash_value       hashvalue
FROM     x$ksmlru a
        ,v$session b
WHERE    ksmlrsiz > 0
AND      a.ksmlrses = b.saddr
;
