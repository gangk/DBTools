/*
Script provides Session information

Author : Pavan Kumar N
Version : 11.2.0.1.0

@sessinfo <sid>
Note :- Must have access to v$views
*/

clear screen

set termout on
set tab off 
set verify off
set serveroutput on
set feedback off
set linesize 1000

def _sid="&1"

prompt
prompt   -- 	Session Info by Pavan Kumar N 
prompt   --  	(https://sites.google.com/site/oraclepracticals )
prompt

declare 

	-- Declarations of variable / constants

	type type_sess is table of v$session%rowtype index by pls_integer;
	t_session	type_sess;
	v_sql_text	v$sql.sql_text%type;

begin

	-- Update the collection
	select  *
	bulk collect 
	into t_session
	from  v$session 
	where sid = &_sid; 
	        
	-- Print report
	dbms_output.put_line(chr(9)||chr(9)||'Session - Details : '||&_sid ||'('|| t_session(1).service_name||')'||chr(10));
	
	-- Session Details
	dbms_output.put_line('Connected Schema	: '||t_session(1).schemaname||chr(9)||chr(9)||chr(9)||'Server : '||t_session(1).machine);
	dbms_output.put_line('Type of Connection	: '||t_session(1).server||chr(9)||chr(9)||'OS User	: '||t_session(1).osuser);
	dbms_output.put_line('Session Status		: '||t_session(1).status);	
	
	-- Sql Details
	dbms_output.put_line(chr(10)||chr(9)||chr(9)||'Session SQL - Details'|| chr(10));
	dbms_output.put_line('Current Sql Id		: '||t_session(1).sql_id||chr(9)||chr(9)||chr(9)||'Previous Sql Id		: '||t_session(1).prev_sql_id);
	dbms_output.put_line('Current Sql Hash-vl	: '||t_session(1).sql_hash_value||chr(9)||chr(9)||chr(9)||'Previous Sql Hash-vl	: '||t_session(1).prev_hash_value);
	
	-- Fetch the part of query -- current column size varchar(1000)
	begin
		select sql_text 
		into v_sql_text
		from v$sql
		where sql_id=nvl(t_session(1).sql_id,t_session(1).prev_sql_id);
	exception
		when no_data_found then
		v_sql_text := '';
	end;
	
	dbms_output.put_line('Current/Prev Sql text	: '|| chr(9) || v_sql_text);
	
	-- Blocking Details
	dbms_output.put_line(chr(10)||chr(9)||chr(9)||'Session Blocking - Details'|| chr(10));
	dbms_output.put_line('Session Status		: '||t_session(1).blocking_session_status);
	dbms_output.put_line('Session instance	: '||t_session(1).blocking_instance);
	dbms_output.put_line('Blocking Session	: '||t_session(1).blocking_session);
	
	-- Parallel Activity Details
	dbms_output.put_line(chr(10)||chr(9)||chr(9)||'Session Parallel - Details'|| chr(10));
	dbms_output.put_line('Parallel DML	: '||t_session(1).pdml_status);
	dbms_output.put_line('Parallel DDL	: '||t_session(1).pddl_status);
	dbms_output.put_line('Parallel Query	: '||t_session(1).pq_status);
	
	-- Wait Events
	
	dbms_output.put_line(chr(10)||chr(9)||chr(9)||'Session Wait Events Details '|| chr(10));
	dbms_output.put_line('Wait Event Class	: '||t_session(1).wait_class#);
	dbms_output.put_line('Wait Event Class Name	: '||t_session(1).wait_class|| chr(10));
	
	dbms_output.put_line('Wait Event Id	: '||t_session(1).event#);
	dbms_output.put_line('Wait Event Name	: '||t_session(1).event|| chr(10));
	
	dbms_output.put_line('Waiting State	: '|| t_session(1).state);
	dbms_output.put_line('Wait time		: '|| t_session(1).wait_time|| chr(10));
	
	dbms_output.put_line('Note -> 0 - Value is the duration of the last wait in hundredths of a second');
	dbms_output.put_line('	 -> -1 - Duration of the last wait was less than a hundredth of a second');
	dbms_output.put_line('	 -> -2 - Parameter TIMED_STATISTICS was set to false');
	
	-- Trace Details
	
	dbms_output.put_line(chr(10)||chr(9)||chr(9)||'Session Tracing Details '|| chr(10));
	dbms_output.put_line('SQL Trace Enabled/ Disable Status	: '||t_session(1).sql_trace);
	dbms_output.put_line('SQL Trace Waits Enable/Disable		: '||t_session(1).sql_trace_waits);
	dbms_output.put_line('SQL Trace Binds Enable/Disable		: '||t_session(1).sql_trace_binds);
	

	
	
end;
/

prompt
prompt



undef _sid



