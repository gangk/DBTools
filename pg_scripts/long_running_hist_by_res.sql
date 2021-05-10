SELECT 
	pd.datname
	,pss.query AS SQLQuery
	,pss.rows AS TotalRowCount
	,(pss.total_time / 1000 / 60) AS TotalMinute 
	,((pss.total_time / 1000 / 60)/calls) as TotalAverageTime		
FROM pg_stat_statements AS pss
INNER JOIN pg_database AS pd
	ON pss.dbid=pd.oid
ORDER BY 1 DESC 
LIMIT 10;
