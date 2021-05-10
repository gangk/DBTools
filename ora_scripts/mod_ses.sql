col module format A40
col username format A15 heading "User"
col unix_pid format A10
col session_iden format A12
col event format A40 wrap
col login_since format A20

accept module_like  prompt 'enter module like :- '
select sid || ', ' ||  serial# session_iden, module, username, status, sql_id, event, prev_sql_id
 from v$session 
 where upper(module) like upper('%&module_like%')
 order by 1 ;

prompt Presss to contintue... ;
pause

select sid || ', ' ||  serial# session_iden, logon_time, 
trunc( SYSDATE - logon_time ) || 'd, ' ||
	trunc( ( ( SYSDATE - logon_time ) - trunc( SYSDATE - logon_time ) ) * 24 ) || 'h, ' || 
	trunc( (( SYSDATE - logon_time )* 24 -  trunc(( SYSDATE - logon_time )* 24) ) * 60) || 'm, '  ||
	trunc(MOD((SYSDATE - logon_time)*24*60*60, 60)) || 's' login_since,	
        status, last_call_et, module from v$session 
where upper(module) like upper('%&module_like%')
order by 2 ;

set heading off feedback off
select 'sysdate - ' || sysdate from dual ;
set heading on feedback 1


