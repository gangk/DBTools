SELECT occupant_name,  round( space_usage_kbytes/1024) "Space (M)",  
schema_name, move_procedure
    FROM v$sysaux_occupants  
   ORDER BY 1  
   /
   
   
 SELECT 
       snap_id, begin_interval_time, end_interval_time 
     FROM 
       SYS.WRM$_SNAPSHOT 
     WHERE 
       snap_id = ( SELECT MIN (snap_id) FROM SYS.WRM$_SNAPSHOT)
     UNION 
     SELECT 
      snap_id, begin_interval_time, end_interval_time 
   FROM 
      SYS.WRM$_SNAPSHOT 
    WHERE 
     snap_id = ( SELECT MAX (snap_id) FROM SYS.WRM$_SNAPSHOT)
  /