

select output from table(dbms_workload_repository.ash_report_text( (select dbid from v$database),
                             1,
                             sysdate-180/(24*60),
                             sysdate,
                             0))
/


select output
   from table(dbms_workload_repository.ash_report_text(
                      (select dbid from v$database),
                             1,
                             to_date('245444962040','JSSSSS'),
                             to_date('245444962280','JSSSSS'),
                             0, -- unknown
                             0, -- slot_width 
                             '', -- sid
                             '05s4vdwsf5802',  -- sql_id
                             '',  -- wait class
                             '',  -- server_hash,number
                             '',  -- module
                             '',  -- action 
                             ''  -- client-id 
                              )) 
/
