SELECT max(query) AS max_query_id, min(run_minutes) AS "min", max(run_minutes) AS "max", avg(run_minutes) AS "avg", sum(run_minutes) AS total FROM (SELECT userid, label, stl_query.query, trim(DATABASE) AS DATABASE, trim(querytxt) AS qrytext, md5(trim(querytxt)) AS qry_md5, starttime, endtime, (datediff(seconds, starttime,endtime)::numeric(12,2))/60 AS run_minutes, alrt.num_events AS alerts, aborted FROM stl_query LEFT OUTER JOIN (SELECT query, 1 AS num_events FROM stl_alert_event_log GROUP BY query) AS alrt ON alrt.query = stl_query.query WHERE userid <> 1 AND starttime >= dateadd(DAY, -7, CURRENT_DATE)) GROUP BY DATABASE, label, qry_md5, aborted ORDER BY total DESC LIMIT 50;