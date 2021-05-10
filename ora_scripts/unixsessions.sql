col logon_time for a30
col program for a20
col module for a20
col machine for a20
col logon_time for a20
col unix_id for a7
col process for a6
col event for a25

SELECT  /*+ ORDERED */
         s.sid                               
        ,s.serial#                           
	,p.spid    unix_id
	,s.process
        ,p.pid                                       
        ,s.username                          
        ,substr(s.event,1,25) event
        ,s.status                                    
        ,substr(p.program,instr(p.program,'('),12)   program                                                                                              
        ,substr(s.machine,1,20) machine                                                                      
	,substr(s.module,1,20) module                            
FROM
         v$session     s
        ,v$process     p
        ,v$sess_io     i
        ,v$sqlarea     sq
WHERE         
	 s.paddr        = p.addr (+)
AND      s.sid          = i.sid (+)
AND      s.sql_address  = sq.address (+)
AND      decode(sign(s.sql_hash_value),-1,s.sql_hash_value+power(2,32),sql_hash_value) = sq.hash_value (+)
AND      s.event not like '%SQL*Net message%' 
AND      s.event not like '%rdbms ipc message%'
AND      s.event not like '%Space Manager:%'
AND      s.event not like '%DIAG idle wait%'
AND      s.event not like '%jobq slave wait%'
AND      s.event not like '%VKTM Logical%'
AND      s.event not like '%pmon timer%'
AND      s.event not like '%smon timer%'
AND      s.event not like '%Streams AQ:%'
order by p.spid
;
