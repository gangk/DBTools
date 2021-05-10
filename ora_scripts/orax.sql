SET LONG 100000
SET LONGCHUNKSIZE 100000
select
        sql_id
        ,SQL_FULLTEXT
from
        v$sqlarea
where
      sql_id  = '&&1'
;
SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('&&1',NULL,'typical +peeked_binds allstats last'));
--SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('&&1',NULL));
--SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('&&1',NULL, 'ALLSTATS LAST'));
--SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('&&1',NULL, 'ALL'));

