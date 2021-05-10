REM ------------------------------------------------------------------------------------------------
REM $Id: trace-sid-off.sql,v 1.1 2002/04/01 22:38:04 hien Exp $
REM Author     : hien
REM #DESC      : Turn off tracing for a given sid
REM Usage      : Input parameter: session_id
REM Description: 
 ------------------------------------------------------------------------------------------------

@plusenv
undef session_id
undef xserial

set lines 120 pages 0
col colx newline just left  format a120
col coly newline just left  word_wrapped format a120
col ser	noprint	new_value xserial

SELECT	/*+ ORDERED */
         ' '                                    			colx
        ,'Session id ...........:'||s.sid       			colx
        ,'Serial # .............:'||s.serial#   			colx
        ,'Oracle PID ...........:'||p.pid   				colx
        ,'Oracle logon id ......:'||s.username  			colx
        ,'Server type ..........:'||s.server    			colx
        ,'Process type .........:'||substr(p.program,instr(p.program,'('),12) 	colx
        ,' '                                    			colx
        ,'OS logon id ..........:'||s.osuser    			colx
        ,'OS server PID ........:'||p.spid      			colx
        ,'OS parent PID ........:'||s.process   			colx
        ,'OS machine ...........:'||s.machine   			colx
        ,' '                                    			colx
        ,'Module ...............:'||s.module    			colx
        ,'Program ..............:'||s.program   			colx
	,s.serial#							ser
FROM
         v$session     s
        ,v$process     p
WHERE
         s.sid          = &&session_id
AND      s.paddr	= p.addr (+)
;

set echo on feed on 
exec sys.dbms_system.set_ev(&&session_id, &&xserial, 10046, 0, '');
set echo off feed off 

undef session_id
undef xserial
