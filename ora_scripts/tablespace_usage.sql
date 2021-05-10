SELECT tbs.tablespace_name,
tot.bytes / 1024 /1024 total_mb,
tot.bytes / 1024 /1024 -SUM(nvl(fre.bytes, 0)) / 1024 / 1024 used_mb,
SUM(nvl(fre.bytes, 0)) / 1024 /1024 free_mb,
(1 -SUM(nvl(fre.bytes, 0)) / tot.bytes) *100 pct,
decode(greatest((1 -SUM(nvl(fre.bytes, 0)) / tot.bytes) *100, 90), 90, '', '*') pct_warn
FROM dba_free_space fre,
(SELECT tablespace_name,
SUM(bytes) bytes
FROM dba_data_files
GROUP BY tablespace_name)
tot,
dba_tablespaces tbs
WHERE tot.tablespace_name = tbs.tablespace_name
AND fre.tablespace_name(+) = tbs.tablespace_name
GROUP BY tbs.tablespace_name,
tot.bytes / 1024,
tot.bytes
ORDER BY 5, 1;