select
      ROUND(RATIO_TO_REPORT(SUM(1)) OVER () * 100 ,2) PERCENT_OF_TOTAL,
      ash.session_type "SESSION",
      session_state status,
      count(distinct to_char(session_id)|| to_char(session_serial#)) num_sess
from v$active_session_history  ash
where
     sample_time > sysdate - 15/(24*60)
   and  (
            (  ash.session_state = 'ON CPU' )
        or
            ( ash.session_type != 'BACKGROUND'  )
        )
group by
      ash.session_type,
      session_state
order by count(*)
/

