SELECT a.job "Job",            
       Substr(a.log_user,1,15) "Log User",       
       Substr(a.priv_user,1,15) "Priv User",     
       Substr(a.schema_user,1,15) "Schema User",    
       Substr(To_Char(a.last_date,'DD-Mon-YYYY HH24:MI:SS'),1,20) "Last Date",      
       Substr(To_Char(a.this_date,'DD-Mon-YYYY HH24:MI:SS'),1,20) "This Date",      
       Substr(To_Char(a.next_date,'DD-Mon-YYYY HH24:MI:SS'),1,20) "Next Date",      
       a.total_time "Total Time",     
       a.broken "Broken",         
       a.interval "Interval",       
       a.failures "Failures",       
       a.what "What",
       a.nls_env "NLS Env",        
       a.misc_env "Misc Env"          
FROM   dba_jobs a;

