undef session_id
set head off echo off timing off feed off pages 0 lines 80
col colx newline just left  format a80
col coly newline just left  word_wrapped format a80

SELECT	/*+ ORDERED */
         ' '                                    			colx
        ,'Session id ...........:'||s.sid       			colx
        ,'Serial # .............:'||s.serial#   			colx
        ,'Oracle logon id ......:'||s.username  			colx
        ,'Logon time ...........:'||to_char(logon_time,'YYYY-MM-DD/HH24:MI:SS')	colx
        ,'Current time .........:'||to_char(sysdate,'YYYY-MM-DD/HH24:MI:SS')	colx
        ,'Session status .......:'||s.status    			colx
        ,'Server type ..........:'||s.server    			colx
        ,' '                                    			colx
        ,'Logical reads ........:'||(i.block_gets+i.consistent_gets)    colx
        ,'Physical reads .......:'||i.physical_reads                    colx
        --,'CPU usage ............:'||t.ksusestv                          colx
        ,'Last call elapsed ....:'||s.last_call_et                      colx
        ,' '                                    			colx
        ,'OS logon id ..........:'||s.osuser    			colx
        ,'OS server PID ........:'||p.spid      			colx
        ,'OS parent PID ........:'||s.process   			colx
        ,'OS machine ...........:'||s.machine   			colx
        ,' '                                    			colx
        ,'Module ...............:'||s.module    			colx
        ,'Program ..............:'||s.program   			colx
        ,'Client Info...........:'||s.client_info			colx
        ,'SQL hash value .......:'||s.sql_hash_value    		colx
        ,'Prev SQL hash value ..:'||s.prev_hash_value    		colx
	,'First load time ......:'||sq.first_load_time			colx
        ,' '                                    			colx
        ,'Executions ...........:'||sq.executions       		colx
	,'Parse calls ..........:'||sq.parse_calls			colx
        ,'Sorts ................:'||sq.sorts    			colx
        ,' '                                    			colx
        ,'Waiting for lock .....:'||decode(s.lockwait,null,'NO','YES')  colx
        ,' '                                    			colx
        ,'SQL text .............:'              			colx
        ,sq.sql_text                                    		coly
FROM
         v$session     s
        ,v$process     p
        ,v$sess_io     i
        --,sys.x$ksusesta        t
        ,v$sqlarea     sq
WHERE
         sq.sql_text like '%&sql_pattern%'
AND      p.addr         = s.paddr
AND      i.sid          = s.sid
AND      s.sql_address  = sq.address (+)
AND      decode(sign(s.sql_hash_value),-1,s.sql_hash_value+power(2,32),sql_hash_value) = sq.hash_value (+)
;
@reset
