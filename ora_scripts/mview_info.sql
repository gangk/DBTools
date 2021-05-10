SELECT b.name,TO_CHAR(last_refresh,'dd-mm-yyyy hh24:mi') LastRefresh ,
TO_CHAR(next_date,'dd-mm-yyyy hh24:mi') NextRefresh
,job,broken,interval FROM user_refresh a, USER_SNAPSHOT_REFRESH_TIMES b
WHERE b.name=UPPER('&mview_name') and a.rname=b.name ORDER BY TO_CHAR(last_refresh,'dd-mm-yyyy hh24:mi')
/