SET pages 10000
SET linesize 250
column FORCE_MATCHING_SIGNATURE format 99999999999999999999999
WITH c AS
     (SELECT  FORCE_MATCHING_SIGNATURE,
              COUNT(*) cnt
     FROM     v$sqlarea
     WHERE    FORCE_MATCHING_SIGNATURE!=0
     GROUP BY FORCE_MATCHING_SIGNATURE
     HAVING   COUNT(*) > 20
     )
     ,
     sq AS
     (SELECT  sql_text                ,
              FORCE_MATCHING_SIGNATURE,
              row_number() over (partition BY FORCE_MATCHING_SIGNATURE ORDER BY sql_id DESC) p
     FROM     v$sqlarea s
     WHERE    FORCE_MATCHING_SIGNATURE IN
              (SELECT FORCE_MATCHING_SIGNATURE
              FROM    c
              )
     )
SELECT   sq.sql_text                ,
         sq.FORCE_MATCHING_SIGNATURE,
         c.cnt "unshared count"
FROM     c,
         sq
WHERE    sq.FORCE_MATCHING_SIGNATURE=c.FORCE_MATCHING_SIGNATURE
AND      sq.p                       =1
ORDER BY c.cnt DESC