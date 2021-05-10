SELECT statistic#,
       name
FROM   v$segstat_name
ORDER BY statistic#;

ACCEPT l_schema char PROMPT 'Enter Schema: '
ACCEPT l_stat  NUMBER PROMPT 'Enter Statistic#: '


SELECT object_name,
       object_type,
       value
FROM   v$segment_statistics 
WHERE  owner = UPPER('&l_schema')
AND    statistic# = &l_stat
ORDER BY value;
