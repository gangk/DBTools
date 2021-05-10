COLUMN month        FORMAT a7                   HEADING 'Month'
COLUMN growth       FORMAT 999,999,999,999,999  HEADING 'Growth (Bytes)'

BREAK ON report
COMPUTE SUM OF growth ON report

SELECT
    TO_CHAR(creation_time, 'RRRR-MM') month
  , SUM(bytes)                        growth
FROM     sys.v_$datafile
GROUP BY TO_CHAR(creation_time, 'RRRR-MM')
ORDER BY TO_CHAR(creation_time, 'RRRR-MM');
