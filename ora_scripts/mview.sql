col name for a30
col lastrefresh for a40
col interval for a50

SELECT b.name,TO_CHAR(last_refresh,'dd-mm-yyyy hh24:mi') LastRefresh , 
TO_CHAR(next_date,'dd-mm-yyyy hh24:mi') NextRefresh 
,job,broken,interval FROM dba_refresh a, dba_SNAPSHOT_REFRESH_TIMES b 
WHERE a.rname=b.name ORDER BY TO_CHAR(last_refresh,'dd-mm-yyyy hh24:mi');