select
      count(*),
       CASE WHEN state != 'WAITING' THEN 'WORKING'
            ELSE 'WAITING'
       END AS state,
       CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
            ELSE event
       END AS sw_event
    FROM
     v$session
  WHERE
      type = 'USER'
  AND status = 'ACTIVE'
  GROUP BY
     CASE WHEN state != 'WAITING' THEN 'WORKING'
          ELSE 'WAITING'
     END,
     CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
          ELSE event
     END
  ORDER BY
     1 DESC, 2 DESC;
 