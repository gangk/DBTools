{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}}
{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20 set linesize 180\par
set pagesize 9999\par
column sql_id format a15\par
column num_versions format 999999\par
column sql_text format a70\par
column cpu_seconds format 999999999.99\par
column cpus_taken format 999.99\par
column pct_db_cpu alias "% DB CPU" format 99.99\par
column executions format 999999\par
 \par
 \par
with btime as (select begin_interval_time time from dba_hist_snapshot where snap_id = &&bsnap),\par
 etime as (select end_interval_time time from dba_hist_snapshot where snap_id = &&esnap),\par
 diff as (select (select time from etime) - (select time from btime) diff from dual),\par
 elapsed as (select 24*60*60*extract(day from diff) + 60*60*extract(hour from diff)+60*extract(minute from diff)+extract(second from diff) seconds from diff),\par
 osstat as (select value num_cpus from DBA_HIST_OSSTAT where snap_id = &&esnap and stat_name= 'NUM_CPUS')\par
select i2.*\par
from\par
(\par
    select inline.sql_id,\par
             num_versions,\par
             inline.cpu/1e6 cpu_seconds,\par
             (100*(case total.cpu when 0 then null else inline.cpu/total.cpu end)) pct_db_cpu,\par
             executions,\par
             inline.cpu/1e6/elapsed.seconds cpus_taken,\par
             dbms_lob.substr(replace(replace(sql_text, chr(10), ' '), chr(13)), 200) sql_text            \par
    from\par
        elapsed,\par
        osstat,\par
    (\par
            select decode(force_matching_signature, 0, dbms_lob.substr(replace(replace(sql_text, chr(10), ' '), chr(13)), 100), force_matching_signature) signature, min(st.sql_id) sql_id, sum(cpu_time_delta) cpu, count(distinct st.sql_id) num_versions, sum(executions_delta) executions\par
            from dba_hist_sqlstat st,\par
                    dba_hist_sqltext txt\par
            where st.sql_id = txt.sql_id\par
            and snap_id between &&bsnap and &&esnap\par
            group by decode(force_matching_signature, 0, dbms_lob.substr(replace(replace(sql_text, chr(10), ' '), chr(13)), 100), force_matching_signature)           \par
    ) inline,\par
    (select sum(cpu) cpu from (select snap_id, (value-lag(value) over (partition by stat_name order by snap_id)) cpu from dba_hist_SYS_TIME_MODEL where stat_name = 'DB CPU' ) where snap_id between &&bsnap and &&esnap) total,\par
    dba_hist_sqltext txt\par
    where inline.sql_id = txt.sql_id\par
) i2 \par
order by cpu_seconds desc;\par
}
 