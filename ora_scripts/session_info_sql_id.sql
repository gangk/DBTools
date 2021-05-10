select username, sid, serial#, status, sql_id, event, seconds_in_wait
    from v$session
    where username like nvl('&username',username)
    and sid like nvl('&sid',sid)
    and sql_id='&sql_id'
   order by username, sid, serial#;
