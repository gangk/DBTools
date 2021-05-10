
REM Filename:  CurrentSQL.sql
REM

set lines 70
clear col

col "Total Memory" for 999,999,999,999
col "Average Memory" for 999,999,999,999
col Num_Statements for 999,999,999 head "Num of|Statements"
col "TotExecs" for 999,999,999

SELECT sum(sharable_mem) "Total Memory"
  ,avg(sharable_mem) "Average Memory"
 ,count(*) Num_Statements
 ,sum(executions) "Total Execs"
FROM gv$sql
/

/*----------------------------------------------------

Sample Output
                                        Num of
    Total Memory   Average Memory   Statements   TotExecs
---------------- ---------------- ------------ ----------
         937,400            9,374          100       3,294
*/