set lines 120
set pages 999

REM 
REM   Change 'having count(*) > 30'   can be changed
REM     as appropriate.  Larger values will result in
REM     in fewer matching rows

col statement format a60 word_wrapped heading "SQL"
col cursor_count format 999,999,999 head "Total Cnt"
col sid format 9999999 heading "ID"


SELECT O.SID SID, COUNT(*) CURSOR_COUNT, A.SQL_TEXT STATEMENT
    FROM gV$OPEN_CURSOR O, gV$SQLAREA A
      WHERE O.HASH_VALUE = A.HASH_VALUE
      AND O.ADDRESS = A.ADDRESS
      GROUP BY O.SID, A.SQL_TEXT
    HAVING COUNT(*) > 30
      ORDER BY CURSOR_COUNT DESC
/


