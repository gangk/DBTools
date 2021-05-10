SELECT startup_time "Startup", SUM (VALUE) "Transactions",
SUM (VALUE)
/ DECODE (SUM (TRUNC (SYSDATE - startup_time)),
0, 1,
SUM (TRUNC (SYSDATE - startup_time))
) "Avg per day",
SUM (VALUE)
/ DECODE (SUM (TRUNC (SYSDATE - startup_time)),
0, 1,
SUM (TRUNC (SYSDATE - startup_time))
)
/ 24 "Avg per hour",
SUM (VALUE)
/ DECODE (SUM (TRUNC (SYSDATE - startup_time)),
0, 1,
SUM (TRUNC (SYSDATE - startup_time))
)
/ 1440 "Avg per min"
FROM v$sysstat, v$instance
WHERE NAME IN ('user commits', 'user rollbacks')
GROUP BY startup_time;