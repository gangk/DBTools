SELECT to_char(begin_interval_time,'YYYY_MM_DD HH24:MI') WHEN,
       dbms_lob.substr(sql_text,4000,1) SQL,
       dhss.instance_number INST_ID,
       dhss.sql_id,
       executions_delta exec_delta,
       rows_processed_delta rows_proc_delta
  FROM dba_hist_sqlstat dhss,
       dba_hist_snapshot dhs,
       dba_hist_sqltext dhst
  WHERE upper(dhst.sql_text) LIKE upper('%&segment_name%')
    AND ltrim(upper(dhst.sql_text)) NOT LIKE 'SELECT%'
    AND dhss.snap_id=dhs.snap_id
    AND dhss.instance_number=dhs.instance_number
    AND dhss.sql_id=dhst.sql_id
    AND begin_interval_time BETWEEN to_date('&start_date_time','YY-MM-DD HH24:MI')
                                AND to_date('&end_date_time','YY-MM-DD HH24:MI')
/