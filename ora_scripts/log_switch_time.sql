
SELECT ROUND(AVG(1440 * (b.first_time - a.first_time)), 0) "Log switch time - minutes"
FROM v$loghist a, v$log b
WHERE b.sequence# = a.sequence# + 1
AND a.sequence# = (SELECT MAX(sequence#) FROM v$loghist)
ORDER BY a.sequence#; 
