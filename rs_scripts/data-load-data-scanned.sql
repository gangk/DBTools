SELECT trim(b.relname) AS "tablename", sum(d.MB_scanned) AS MB_scanned FROM (SELECT query, tbl, sum(rows) AS rows_inserted, max(endtime) AS endtime, datediff('microsecond',min(starttime),max(endtime)) AS insert_micro FROM stl_insert GROUP BY query, tbl) a, 
pg_class b, pg_namespace c, 
(SELECT b.query, count(distinct b.bucket||b.key) AS distinct_files, sum(b.transfer_size)/1024/1024 AS MB_scanned, sum(b.transfer_time) AS load_micro FROM stl_s3client b WHERE b.http_method = 'GET' GROUP BY b.query) d WHERE a.tbl = b.oid AND b.relnamespace = c.oid AND d.query = a.query GROUP BY 1;

