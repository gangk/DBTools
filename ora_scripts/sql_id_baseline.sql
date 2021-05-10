col sql_text for a50 trunc
col last_executed for a28
col enabled for a7
col plan_hash_value for a16
col created format A16
col last_modified format A16
col OPTIMIZER_COST format 99999999999999999 heading Cost
col enabled_accepted_fixed format A14 heading "Ena/Acc/Fix"
col CREATOR format A7 trunc
col last_executed format a16
col ORIGIN format A4

prompt
prompt == shows other baselines/plans apart from the current one == ;
prompt
accept plan_name prompt ' Enter plan_name : '

select s.sql_id,spb.sql_handle, spb.plan_name, spb.CREATOR,
to_char(spb.created,'dd-mon-yy hh24:mi') created,
to_char(spb.last_modified,'dd-mon-yy hh24:mi') last_modified,
substr( spb.ORIGIN,1,4) ORIGIN,
spb.enabled || ' / ' || spb.accepted || ' / ' || spb.fixed enabled_accepted_fixed,
spb.OPTIMIZER_COST,
to_char(spb.last_executed,'dd-mon-yy HH24:MI') last_executed
from
v$sql s,dba_sql_plan_baselines spb
where  s.exact_matching_signature = spb.signature and 
s.sql_id='&sql_id'
order by created ;
