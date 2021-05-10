SELECT ((UR * (UPS * DBS)) + (DBS * 24))/1024/1024 "MB"
FROM (SELECT value AS UR FROM v$parameter WHERE name = 'undo_retention'),
(SELECT (SUM(undoblks)/SUM(((end_time - begin_time)*86400))) AS UPS FROM
v$undostat),
(select block_size as DBS from dba_tablespaces where tablespace_name=
(select upper(value) from v$parameter where name = 'undo_tablespace'));


