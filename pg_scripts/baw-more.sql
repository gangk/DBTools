  SELECT a.datname,
         c.relname,
         l.transactionid,
         l.mode,
         l.GRANTED,
         a.usename,
         a.current_query, 
         a.query_start,
         age(now(), a.query_start) AS "age", 
         a.procpid 
    FROM  pg_stat_activity a
     JOIN pg_locks         l ON l.pid = a.procpid
     JOIN pg_class         c ON c.oid = l.relation
    ORDER BY a.query_start;
