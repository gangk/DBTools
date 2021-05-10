 set pages 999
            clear col
            select to_char(sysdate,'DD-MON-YY HH:MI:SS') from dual;
    
            PROMPT
            PROMPT V$SESSSTAT MEMORY INFO
            PROMPT -------------------------
    
            select p.spid, s.sid, substr(n.name,1,25) memory, s.value
            from v$sesstat s ,  v$statname n,v$process p,v$session vs
            where s.statistic# = n.statistic#
            and n.name like '%pga memory%' and s.sid=vs.sid
            and vs.paddr=p.addr  order by s.value asc;
    
    
            PROMPT
            PROMPT LARGEST PGA_ALLOC_MEM PROCESS NOT LIKE LGWR
            PROMPT -------------------------
    
            select pid,spid,substr(username,1,20) "USER" ,program,
            PGA_USED_MEM,PGA_ALLOC_MEM,PGA_FREEABLE_MEM,PGA_MAX_MEM
            from v$process where pga_alloc_mem=
            (select max(pga_alloc_mem) from v$process
             where program not like '%LGWR%');
    
            PROMPT
            PROMPT SELECT SUM(PGA_ALLOC_MEM) FROM V$PROCESS
            PROMPT -------------------------
    
            select sum(pga_alloc_mem) from v$process;
    
            PROMPT
            PROMPT SELECT FROM V$PROCESS
            PROMPT -------------------------
    
            select spid, program,pga_alloc_mem from v$process
               order by pga_alloc_mem desc;
    
            PROMPT
            PROMPT SELECT * FROM V$PGASTAT
            PROMPT -------------------------
    
            select substr(name,1,30), value, unit from v$pgastat;
            
