SELECT max(l.query) AS "query id", trim(split_part(l.event,’:’,1)) AS event, trim(l.solution) AS solution, count(*) AS "times occured" FROM stl_alert_event_log AS l LEFT JOIN stl_scan AS s ON s.query = l.query AND s.slice = l.slice AND s.segment = l.segment AND s.step = l.step WHERE l.event_time >= dateadd(DAY, -7, CURRENT_DATE) GROUP BY 2,3;
