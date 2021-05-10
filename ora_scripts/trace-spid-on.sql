REM ------------------------------------------------------------------------------------------------
REM $Id: trace-spid-on.sql,v 1.1 2002/04/01 22:38:07 hien Exp $
REM Author     : hien
REM #DESC      : Turn on event 10046 level 12 for a session given its OS server PID
REM Usage      : Input parameter: server_pid
REM Description: Level 12: show bind variables & wait events
REM ------------------------------------------------------------------------------------------------

@plusenv
undef server_pid
undef xsession_id
undef xserial

set lines 120 pages 0
col colx newline just left  format a120
col coly newline just left  word_wrapped format a120
col ser	noprint	new_value xserial
col sid	noprint	new_value xsession_id

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
	,s.sid								sid
	,s.serial#							ser
FROM
         v$session     s
        ,v$process     p
WHERE
         p.spid		= &&server_pid
AND      s.paddr	= p.addr (+)
;

set echo on feed on 
exec sys.dbms_system.set_int_param_in_session(&&xsession_id, &&xserial, 'max_dump_file_size', 2147483647);
exec sys.dbms_system.set_ev(&&xsession_id, &&xserial, 10046, 12, '');
--exec sys.dbms_system.set_ev(session_id, serial, 10046, 0, '');
set echo off feed off

undef server_pid
undef xsession_id
undef xserial
