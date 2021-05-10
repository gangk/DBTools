col name for a50


SELECT a.sid, b.name, a.value    FROM v$sesstat a, v$statname b    
    WHERE a.statistic# = b.statistic#    AND a.statistic# = 176                    
     ORDER BY a.value DESC;