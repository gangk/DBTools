col created for a30
col plan_hash_value for 999999999999
select s.sql_id,b.SQL_HANDLE,b.PLAN_NAME,s.plan_hash_value,b.CREATED,b.ENABLED,b.ACCEPTED,b.FIXED,b.ELAPSED_TIME from DBA_SQL_PLAN_BASELINES b,v$sql s where s.sql_id='&sql_id' and 
s.exact_matching_signature = b.signature
And s.SQL_PLAN_BASELINE = b.plan_name;
