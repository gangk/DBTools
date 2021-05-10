select inst_id,sample_time,session_id,session_serial#,sql_id from (
select inst_id,sample_time,session_id,session_serial#,sql_id from
gv$active_session_history
where
sql_id is not null
 and session_id=&1 
 order by 1 desc
) where rownum < 15;
