PROMPT
PROMPT -- LastChanged.sql v1.0 by Tanel Poder ( http://www.tanelpoder.com )
PROMPT

PROMPT Running this query:
PROMPT
PROMPT .   select MAX(ora_rowscn)
PROMPT .   from &1
PROMPT .   where &2;;

PROMPT

SET FEEDBACK OFF

VAR max_date VARCHAR2(50)

BEGIN
     SELECT TO_CHAR(SCN_TO_TIMESTAMP(MAX(ORA_ROWSCN)), 'YYYY-MM-DD HH24:MI:SS') INTO :max_date

     FROM &1
     WHERE &2;
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/


COL runme NOPRINT NEW_VALUE runme

SELECT 
    'scn_to_timestamp ' data_source
  , CASE 
        WHEN :max_date IS NULL THEN 'SCN_TO_TIMESTAMP couldn''t convert SCN to time. See next section below' 
        ELSE :max_date 
    END last_changed
  , CASE WHEN :max_date IS NULL THEN '--' ELSE '' END runme 
FROM dual
/

COL runme CLEAR


WITH 
sq_smon_scn_time AS (
     SELECT * FROM sys.smon_scn_time
), 
sq_loghistory AS (
     SELECT * FROM v$log_history
),
sq_maxscn AS (
     SELECT 
         MAX(ORA_ROWSCN) max_scn 
         FROM &1
         WHERE &2
),
sq_smon AS (
    SELECT
        'sys.smon_scn_time'   source
      ,  MIN(t1.time_dp)      first_known_change_after
      ,  MAX(t2.time_dp)      last_known_change_before
    FROM 
        sq_smon_scn_time t1
      , sq_smon_scn_time t2
    WHERE 
        (t1.scn_wrp * (POWER(2,32)-1) + t1.scn_bas) > (SELECT max_scn FROM sq_maxscn)
    AND (t2.scn_wrp * (POWER(2,32)-1) + t2.scn_bas) < (SELECT max_scn FROM sq_maxscn)
),
sq_log AS (
    SELECT
        'v$log_history'       source
      ,  MIN(t1.first_time)   first_known_change_after
      ,  MAX(t2.first_time)   last_known_change_before
    FROM 
        sq_loghistory t1
      , sq_loghistory t2
    WHERE 
        (t1.first_change#) > (SELECT max_scn FROM sq_maxscn)
    AND (t2.first_change#) < (SELECT max_scn FROM sq_maxscn)
)
SELECT
    source data_source
  , CASE WHEN last_changed IS NULL THEN 'No matching rows found. Adjust your filter condition' ELSE last_changed END last_changed 
FROM ( 
    SELECT 
        source
      , CASE 
            WHEN sq_smon.first_known_change_after IS NULL OR sq_smon.last_known_change_before IS NULL THEN
                CASE WHEN (SELECT sq_maxscn.max_scn FROM sq_maxscn ) < 
                              ( SELECT MIN(scn_wrp * (POWER(2,32)-1) + scn_bas) 
                                FROM sq_smon_scn_time ) 
                     THEN
                         (SELECT 'Before  '||TO_CHAR(MIN(time_dp),'YYYY-MM-DD HH24:MI:SS')||
                                 ' (earlier than '||ROUND((SYSDATE - MIN(time_dp)))||' days ago)' 
                                 FROM sq_smon_scn_time)
                     WHEN (SELECT sq_maxscn.max_scn FROM sq_maxscn ) > 
                              ( SELECT MAX(scn_wrp * (POWER(2,32)-1) + scn_bas) 
                                FROM sq_smon_scn_time ) 
                     THEN
                         (SELECT 'After   '||TO_CHAR(MAX(time_dp),'YYYY-MM-DD HH24:MI:SS')||
                                 ' (between '||ROUND(((SYSDATE - MAX(time_dp))*24*60))||' minutes ago and now)' 
                                 FROM sq_smon_scn_time)
            END
        ELSE
            'Between '||TO_CHAR(last_known_change_before, 'YYYY-MM-DD HH24:MI:SS')||
               ' and '||TO_CHAR(first_known_change_after, 'YYYY-MM-DD HH24:MI:SS')||
                  ' ('||ROUND((first_known_change_after - last_known_change_before)*24*60) || ' minute range)'
        END last_changed
    FROM ( 
        sq_smon
    )
    UNION ALL
    SELECT 
        source data_source
      , CASE 
            WHEN sq_log.first_known_change_after IS NULL OR sq_log.last_known_change_before IS NULL THEN
                CASE WHEN (SELECT sq_maxscn.max_scn FROM sq_maxscn ) < 
                              ( SELECT MIN(first_change#) FROM sq_loghistory ) 
                     THEN
                         (SELECT 'Before  '||TO_CHAR(MIN(first_time),'YYYY-MM-DD HH24:MI:SS')||
                                 ' (earlier than '||ROUND((SYSDATE - MIN(first_time)))||' days ago)' 
                                 FROM sq_loghistory)
                     WHEN (SELECT sq_maxscn.max_scn FROM sq_maxscn ) > 
                              ( SELECT MAX(first_change#) FROM sq_loghistory ) 
                     THEN
                         (SELECT 'After   '||TO_CHAR(MAX(first_time),'YYYY-MM-DD HH24:MI:SS')||
                                 ' (between '||ROUND(((SYSDATE - MAX(first_time))*24*60))||' minutes ago and now)' 
                                 FROM sq_loghistory)
            END
        ELSE
            'Between '||TO_CHAR(last_known_change_before, 'YYYY-MM-DD HH24:MI:SS')||
               ' and '||TO_CHAR(first_known_change_after, 'YYYY-MM-DD HH24:MI:SS')||
                  ' ('||ROUND((first_known_change_after - last_known_change_before)*24*60) || ' minute range)'
        END last_changed
    FROM ( 
        sq_log
    )
)
&runme WHERE 1=0
/

SET HEADING OFF
SELECT COUNT(*)||' rows analyzed.' FROM &1 WHERE &2;
SET HEADING ON
