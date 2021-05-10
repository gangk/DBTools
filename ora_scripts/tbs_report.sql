column a format a18        heading "TABLESPACE"    justify c
column b format 99,999,999 heading "TOTAL|MBYTES"  justify c
column c format 999.99     heading "PERCENT|USED"  justify c
column d format 99,999,999 heading "USED|MBYTES"   justify c
column e format 99,999,999 heading "FREE|MBYTES"   justify c
column g format 999999     heading "FRAGS"         justify c

compute sum of b on report
compute avg of c on report
compute sum of d on report
compute sum of e on report

select dfs.tablespace_name                           a,
       ts.bytes/1024/1024                            b,
       ((ts.bytes-sum(dfs.bytes))/ts.bytes)*100      c,
       (ts.bytes-sum(dfs.bytes))/1024/1024           d,
       sum(dfs.bytes)/1024/1024                      e,
       count(*)                                      g
  from dba_free_space dfs, (select tablespace_name name, sum(bytes) bytes
                            from dba_data_files
                            group by tablespace_name ) ts
 where dfs.tablespace_name = ts.name
 group by dfs.tablespace_name,ts.bytes
 order by c desc
/
