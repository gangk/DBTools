select SQL_HANDLE,PLAN_NAME,ENABLED,ACCEPTED,FIXED,CREATED from dba_sql_plan_baselines where sql_handle in (select sql_handle from dba_sql_plan_baselines where plan_name='&plan') order by 6;
