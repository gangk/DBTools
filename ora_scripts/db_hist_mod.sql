  select     module
              ,cpu
              ,100*ratio_to_report (cpu) over () pctcpu
              ,wait
              ,io
              ,100*ratio_to_report (io) over () pctio
              ,tot
      from
      (
      select    ash.module     module
              ,sum(decode(ash.session_state,'ON CPU',1,0))     cpu
              ,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0)) wait
              ,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
              ,sum(decode(ash.session_state,'ON CPU',1,1))     tot
      from     DBA_HIST_ACTIVE_SESS_HISTORY ash	  
              ,v$event_name en
      where    ash.sql_id is not NULL
     -- and ash.snap_id between (
      and      ash.event_id=en.event# (+)
      and user_id not in (select USER_ID from dba_users where username in ('SYS','SYSTEM','ADMIN'))
       and sample_time between sysdate-3 and sysdate-1
      group by    module
      order by sum(decode(session_state,'ON CPU',1,0))   desc
      )
      where rownum <=20
      ;

