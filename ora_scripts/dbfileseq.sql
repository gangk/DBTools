SELECT sid, total_waits, time_waited
    FROM v$session_event
   WHERE event='db file sequential read'
     and total_waits>0
   ORDER BY 3,2
  
/
