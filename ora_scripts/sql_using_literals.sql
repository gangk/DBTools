 SELECT substr(sql_text,1,60) SQL,count(*) ,sum(executions) TotExecs FROM v$sqlarea
WHERE executions < 5 GROUP BY substr(sql_text,1,60) HAVING count(*) > 30 ORDER BY 2;








