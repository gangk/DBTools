select to_char(logon_time,'DD-MM HH24:MI'),MODULE,count(1) from admin.DB_LOGONS where LOGON_TIME between to_date ('&start_time','DD-MM-YY HH24:MI') and
to_date ('&end_time','DD-MM-YY HH24:MI') and module='FCShipmentDataService' group by to_char(logon_time,'DD-MM HH24:MI'),MODULE order by 1;




set linesize 100
set verify off
set echo off
set feedback off
set heading off

column wait_event format a25

column collected new_value _collected
column runs new_value _runs
column beg new_value _beg
column end new_value _end
column mins_ago new_value _mins_ago
column duration new_value _duration
column end_time new_value _end_time

select &mins_ago+0  mins_ago, &duration+0 duration from dual;
select decode(&_mins_ago,0,15,&_mins_ago) mins_ago , 
       decode(&_duration,0,15,&_duration) duration from dual;
select  &_mins_ago , &_mins_ago - &_duration end_time  from dual;

set heading on
select nvl(count(*),0) collected, 
       max(sample_id),min(sample_id) ,
       nvl(max(sample_id)-min(sample_id),0)+1 runs,
       --nvl(min(sample_time),sysdate) beg,
       --nvl(max(sample_time),sysdate) end
       to_char(nvl(min(sample_time),sysdate),'DD/MM/YY HH24:MI:SS') beg,
       to_char(nvl(max(sample_time),sysdate),'DD/MM/YY HH24:MI:SS') end
from v$active_session_history
where sample_time >= sysdate - (&_mins_ago)/(24*60) 
  and sample_time <= sysdate - (&_end_time)/(24*60)
  -- and session_type!=81;
set termout off
set heading off
set termout on

select
        'Analysis Begin Time :   ' || '&_beg' || '                               ',
        'Analysis End   Time :   ' || '&_end' || '                               ',
        'Start time, mins ago:   ' || '&_mins_ago' || '                             ',
        'Request Duration    :   ' || '&_duration' || '                             ',
        'Collections         :   ' || '&_runs' || '                             ',
        'Data Values         :   ' || '&_collected' || '                             ',
        --'Elapsed Time:  ' || to_char(round((to_date(&_end)-to_date(&_beg))*24*60))||' mins '
        'Elapsed Time:  ' || to_char(round((to_date('&_end','DD/MM/YY HH24:MI:SS')-to_date('&_beg','DD/MM/YY HH24:MI:SS'))*24*60))||' mins '
from dual
/
--where &_collected > 0;

set heading on
break on report
compute sum of "Ave_Act_Sess" on Report


select * from (
   select 
        substr(decode(session_state,'ON CPU','ON CPU',event),0,25) wait_event, 
        count(*)  cnt,
        round( 100* (count(*)/&_collected) +0.00  , 2.2) "% Active",
        round( (count(*)/&_runs) +0.00, 2.2) "Ave_Act_Sess"
   from 
        v$active_session_history ash
   where
        sample_time >= sysdate - &_mins_ago/(24*60)
    and sample_time <= sysdate - (&_end_time)/(24*60) 
    --and session_type!=81
    -- and dbid = _dbid 
   group by decode(session_state,'ON CPU','ON CPU',event) 
   order by count(*)
) where cnt/&_collected > 0.001
 and &_collected > 0
;


declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'USE_HASH_AGGREGATION(@"SEL$1")',
		'INDEX_RS_ASC(@"SEL$1" "FCSKUSALES0_"@"SEL$1" ("FCSKU_SALES_HISTORY"."FCSKU" "FCSKU_SALES_HISTORY"."WAREHOUSE_ID" "FCSKU_SALES_HISTORY"."SKU_SALE_EVENT_DATE"))',
		'OUTLINE_LEAF(@"SEL$1")',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
                'OPT_PARAM(''_optimizer_use_feedback'' ''false'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'DB_VERSION(''11.2.0.3'')',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.3'')',
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = 'akcy17m4vy02g' and p.plan_hash_value = 1287376393 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id);
	end loop;
end;
/



declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'INDEX_RS_ASC(@"SEL$1" "FCSKUSALES0_"@"SEL$1" ("FCSKU_SALES_HISTORY"."FCSKU" "FCSKU_SALES_HISTORY"."SKU_SALE_EVENT_TYPE" "FCSKU_SALES_HISTORY"."SKU_SALE_EVENT_DATE"))',
		'OUTLINE_LEAF(@"SEL$1")',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
                'OPT_PARAM(''_optimizer_use_feedback'' ''false'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'DB_VERSION(''11.2.0.3'')',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.3'')',
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = 'akcy17m4vy02g' and p.plan_hash_value = 1287376393 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id);
	end loop;
end;
/




declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'USE_HASH_AGGREGATION(@"SEL$1")',
		'NLJ_BATCHING(@"SEL$1" "RC"@"SEL$1")',
		'USE_NL(@"SEL$1" "RC"@"SEL$1")',
		'LEADING(@"SEL$1" "TEMP"@"SEL$1" "RC"@"SEL$1")',
		'INDEX(@"SEL$1" "RC"@"SEL$1" ("REMOVAL_CANDIDATES"."DISTRIBUTOR_SHIPMENT_ITEM_ID"))',
		'FULL(@"SEL$1" "TEMP"@"SEL$1")',
		'OUTLINE_LEAF(@"SEL$1")',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OPT_PARAM(''optimizer_index_cost_adj'' 1)',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
		'OPT_PARAM(''_optimizer_use_feedback'' ''false'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'DB_VERSION(''11.2.0.2'')',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.2'')',
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = '4uav5kg51b2tf' and p.plan_hash_value = 1556974389 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id);
	end loop;
end;


declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'FULL(@"SEL$1" "WHSE_DEMANDS"@"SEL$1")',
		'OUTLINE_LEAF(@"SEL$1")',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'DB_VERSION(''11.2.0.3'')',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.2'')',
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = '7r3wsk8n0x4zv' and p.plan_hash_value = 4193834438 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id
					);
	end loop;
end;
/



declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'PX_JOIN_FILTER(@"SEL$5DA710D3" "INVENTORY_AVAILABILITY_CHANGES"@"SEL$2")',
		'USE_MERGE(@"SEL$5DA710D3" "INVENTORY_AVAILABILITY_CHANGES"@"SEL$2")',
		'LEADING(@"SEL$5DA710D3" "INVENTORY_FNSKU_PARTITIONS"@"SEL$1" "INVENTORY_AVAILABILITY_CHANGES"@"SEL$2")',
		'INDEX_RS_ASC(@"SEL$5DA710D3" "INVENTORY_AVAILABILITY_CHANGES"@"SEL$2" ("INVENTORY_AVAILABILITY_CHANGES"."NEED_TO_BE_SWEPT"))',
		'INDEX_RS_ASC(@"SEL$5DA710D3" "INVENTORY_FNSKU_PARTITIONS"@"SEL$1" ("INVENTORY_FNSKU_PARTITIONS"."APPLICATION_NAME" "INVENTORY_FNSKU_PARTITIONS"."PROCESS_NAME" "INVENTORY_FNSKU_PARTITIONS"."FNSKU_PARTITION_ID"))',
		'OUTLINE(@"SEL$2")',
		'OUTLINE(@"SEL$1")',
		'UNNEST(@"SEL$2")',
		'OUTLINE_LEAF(@"SEL$5DA710D3")',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
                'OPT_PARAM(''_optimizer_use_feedback'' ''false'')',
		'DB_VERSION(''11.2.0.3'')',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.3'')',
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = '5tm612d4n1a8w' and p.plan_hash_value = 2859081095 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id);
	end loop;
end;
/
