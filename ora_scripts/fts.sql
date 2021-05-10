set lines 600
col module for a40 wrap
col sql_id for a15
col sum(disk_reads) for 9999999999
col sum(buffer_gets) for 9999999999
col sum(executions) for 99999999
col sum(buffer_gets)/sum(executions) for 99999999
col sum(disk_reads)/sum(executions) for 999999999
select * from
(
        select sql_id,module,sum(disk_reads),sum(buffer_gets),sum(executions),sum(disk_reads)/sum(executions),sum(buffer_gets)/sum(executions) from v$sql where sql_id in
(
	select distinct sql_id from v$sql where sql_id in  (select /*+ no_merge no_unnest */ sql_id from v$sql_plan where other_xml  like '%CDATA[FULL%') and (module is not null and module not in ('DBMS_SCHEDULER','MMON_SLAVE'))
) group by sql_id,module having sum(executions) >30 order by 6 desc, 7 desc,5 desc
) where rownum <21 order by 6 desc, 7 desc,5 desc;

