select wait_class_id, wait_class, count(*) cnt from v$active_session_history where SAMPLE_TIME between to_date ('19-OCT-2011 11:30:00','DD-MON-YYYY HH24:MI:SS') and
     to_date ('19-OCT-2011 12:30:30','DD-MON-YYYY HH24:MI:SS')
    group by  wait_class_id, wait_class
order by 3;