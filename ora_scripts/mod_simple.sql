col module format A40 print
col username format A15 heading "User"
col unix_pid format A10
col session_iden format A15
col event format A40 wrap
col login_since format A20
col logon_time format A30

break on module skip 1 duplicate
accept module_like  prompt 'enter module like :- '
select module, sid || ', ' ||  serial# session_iden, logon_time, 
 trunc( SYSDATE - logon_time ) || 'd, ' ||
        trunc( ( ( SYSDATE - logon_time ) - trunc( SYSDATE - logon_time ) ) * 24 ) || 'h, ' ||
        trunc( (( SYSDATE - logon_time )* 24 -  trunc(( SYSDATE - logon_time )* 24) ) * 60) || 'm, '  ||
        trunc(MOD((SYSDATE - logon_time)*24*60*60, 60)) || 's' login_since,
 status, last_call_et, sql_id
 from v$session 
 where upper(module) like upper('%&module_like%')
 order by module, logon_time ;
clear breaks




