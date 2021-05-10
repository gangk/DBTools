REM -----------------------------------------------------
REM $Id: trc-prop.sql,v 1.1 2002/04/01 21:36:22 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Initiates a sql trace on oracle queue propagation
REM Usage       : QNAME - queue name
REM Description : Initiates a sql tr ace on oracle queue propagation
REM -----------------------------------------------------

set serveroutput on
set verify off

DECLARE
  stmt     varchar2(250);
  psid     BINARY_INTEGER;
  pname    varchar2(8);
  pserial# BINARY_INTEGER;
  pspid    number;
BEGIN
  select djr.sid,aqs.process_name,vs.serial#,vp.spid
  into psid,pname,pserial#,pspid
  from dba_jobs_running  djr
      ,sys.aq$_schedules aqs
      ,sys.obj$
      ,v$session vs
      ,v$process vp
  where sys.obj$.oid$ = aqs.oid
  and   sys.obj$.name = upper('&QNAME')
  and   djr.job = aqs.jobno
  and   vs.sid = djr.sid
  and   vs.paddr = vp.addr;

 dbms_system.set_ev(psid,pserial#,10046,12,'');
 dbms_output.put_line('sid: ' || psid || ' spid: ' || pspid || ' process: ' || pname);
 dbms_output.put_line('USE THE FOLLOWING COMMAND TO TURN TRACING OFF WHEN YOU ARE DONE!'); 
 dbms_output.put_line('exec dbms_system.set_ev(' || psid ||',' || pserial# || ',10046,0,'''||''');'); 

EXCEPTION
  when NO_DATA_FOUND THEN
    dbms_output.put_line('Propagation not running at the moment.  Try again later. ');

end;
/

set verify on
