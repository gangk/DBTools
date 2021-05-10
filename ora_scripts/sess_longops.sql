col message for a80

select username,sid,message,time_remaining From v$session_longops where time_remaining>0;