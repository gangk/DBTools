select sid, seconds_in_wait from v$session_wait 
    where state='WAITING' and event='SQL*Net message from client'
         order by seconds_in_wait desc;
