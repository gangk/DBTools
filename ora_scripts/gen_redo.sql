-- Daily Count and Size of Redo Log Space (Single Instance)
--
SELECT A.*,
Round(A.Count#*B.AVG#/1024/1024) Daily_Avg_Mb
FROM
(
SELECT
To_Char(First_Time,'YYYY-MM-DD') DAY,
Count(1) Count#,
Min(RECID) Min#,
Max(RECID) Max#
FROM
v$log_history
GROUP
BY To_Char(First_Time,'YYYY-MM-DD')
ORDER
BY 1 DESC
) A,
(
SELECT
Avg(BYTES) AVG#,
Count(1) Count#,
Max(BYTES) Max_Bytes,
Min(BYTES) Min_Bytes
FROM
v$log
) B
;
column day format a10
column "00" format a5
column "01" format a5
column "02" format a5
column "03" format a5
column "04" format a5
column "05" format a5
column "06" format a5
column "07" format a5
column "08" format a5
column "09" format a5
column "10" format a5
column "11" format a5
column "12" format a5
column "13" format a5
column "14" format a5
column "15" format a5
column "16" format a5
column "17" format a5
column "18" format a5
column "19" format a5
column "20" format a5
column "21" format a5
column "22" format a5
column "23" format a5

alter session set nls_date_format='DD/MM/YYYY';
SELECT to_date(first_time) DAY,
to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'999') "00",
to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'999') "01",
to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'999') "02",
to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'999') "03",
to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'999') "04",
to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'999') "05",
to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'999') "06",
to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'999') "07",
to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'999') "08",
to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'999') "09",
to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'999') "10",
to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'999') "11",
to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'999') "12",
to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'999') "13",
to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'999') "14",
to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'999') "15",
to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'999') "16",
to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'999') "17",
to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'999') "18",
to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'999') "19",
to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'999') "20",
to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'999') "21",
to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'999') "22",
to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'999') "23"
from v$log_history
where to_date(first_time) > sysdate -8
GROUP by  to_date(first_time)
order by to_date(first_time)
/
alter session set nls_date_format='DD/MM/YYYY HH24:MI:SS';