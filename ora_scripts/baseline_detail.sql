col sql_text for a50 trunc
col last_executed for a28
col enabled for a7
col plan_hash_value for a16
col last_executed for a16
col last_modified for a16
col last_verified for a16
col created format a16
col VERSION format a15
col CREATOR format A10 word_wrap
col enabled_accepted_fixed format A14 heading "Ena/Acc/Fix"
col OPTIMIZER_COST format 999,999 heading "cost"
col SIGNATURE format 999999999999999999999999
col sql_fulltext format A120 word_wrap

accept sql_handle prompt ' Enter sql_handle : '
accept plan_name prompt ' Enter plan_name : '

set long 999999

-- sql
select dbms_lob.substr(SQL_TEXT,3999,1) sql_fulltext  from dba_sql_plan_baselines
where SQL_HANDLE = nvl('&sql_handle',SQL_HANDLE)
and PLAN_NAME = nvl('&plan_name',PLAN_NAME ) ;
-- main
prompt
prompt == main details ==
select spb.sql_handle, spb.plan_name,
spb.enabled || ' / ' || spb.accepted || ' / ' || spb.fixed enabled_accepted_fixed,
module,
to_char(spb.last_executed,'dd-mon-yy HH24:MI') last_executed
from
dba_sql_plan_baselines spb
where
spb.sql_handle like nvl('&sql_handle',spb.sql_handle)
and spb.plan_name like nvl('&plan_name',spb.plan_name)
order by spb.sql_handle, spb.plan_name ;

set feedback off
prompt
prompt
prompt other details :- ;
select spb.signature, spb.sql_handle, spb.plan_name, spb.creator, spb.origin,
spb.PARSING_SCHEMA_NAME, VERSION
from
dba_sql_plan_baselines spb
where
spb.sql_handle like nvl('&sql_handle',spb.sql_handle)
and spb.plan_name like nvl('&plan_name',spb.plan_name)
order by spb.sql_handle, spb.plan_name ;


select spb.sql_handle, spb.plan_name,
to_char(CREATED, 'dd-mon-yy HH24:MI') created,
to_char(LAST_MODIFIED, 'dd-mon-yy HH24:MI') last_modified,
to_char(LAST_VERIFIED, 'dd-mon-yy HH24:MI') last_verified,
to_char(spb.last_executed,'dd-mon-yy HH24:MI') last_executed,
REPRODUCED,AUTOPURGE,OPTIMIZER_COST
from
dba_sql_plan_baselines spb
where
spb.sql_handle like nvl('&sql_handle',spb.sql_handle)
and spb.plan_name like nvl('&plan_name',spb.plan_name)
order by spb.sql_handle, spb.plan_name ;

select spb.sql_handle, spb.plan_name, EXECUTIONS, ELAPSED_TIME, CPU_TIME, BUFFER_GETS,
DISK_READS, DIRECT_WRITES, ROWS_PROCESSED, FETCHES
from
dba_sql_plan_baselines spb
where
spb.sql_handle like nvl('&sql_handle',spb.sql_handle)
and spb.plan_name like nvl('&plan_name',spb.plan_name)
order by spb.sql_handle, spb.plan_name ;
set feedback 1
prompt

