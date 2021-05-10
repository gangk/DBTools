select /*+ opt_param('_optimizer_use_feedback','false') */ * from inventory_fnsku_partitions  where application_name = 'FCInventoryNotificationSweeper'  and process_name = 'FCInventoryNotificationSweeper' and last_processed_date_utc < ( sys_extract_utc(localtimestamp) - (45/86400)  ) and fnsku_partition_id in ( select fcsku_partition_id from (select fcsku_partition_id,count(*) rowcount from inventory_notifications where message_status = 'NOT_PROCESSED' and created_date_utc > trunc(sysdate) - 1 group by fcsku_partition_id)) order by last_processed_date_utc;


declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'USE_HASH_AGGREGATION(@"SEL$2")',
		'INDEX_RS_ASC(@"SEL$2" "INVENTORY_ADJUSTMENT_ITEMS"@"SEL$2" ("INVENTORY_ADJUSTMENT_ITEMS"."REASON_CODE"))',
		'NO_ACCESS(@"SEL$1" "from$_subquery$_001"@"SEL$1")',
		'OUTLINE_LEAF(@"SEL$1")',
		'OUTLINE_LEAF(@"SEL$2")',
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
	where t.sql_id = p.sql_id and p.sql_id = 'd9b4jynw4anzq' and p.plan_hash_value = 3659938892 and p.parent_id is null
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
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.3'')',
		'DB_VERSION(''11.2.0.3'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optimizer_use_feedback'' ''false'')',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OUTLINE_LEAF(@"SEL$1C393AD9")',
		'MERGE(@"SEL$833EDA65")',
		'OUTLINE(@"SEL$09D7319C")',
		'UNNEST(@"SEL$335DD26A")',
		'OUTLINE(@"SEL$833EDA65")',
		'OUTLINE(@"SEL$1")',
		'OUTLINE(@"SEL$335DD26A")',
		'MERGE(@"SEL$3")',
		'OUTLINE(@"SEL$2")',
		'OUTLINE(@"SEL$3")',
		'INDEX_RS_ASC(@"SEL$1C393AD9" "INVENTORY_FNSKU_PARTITIONS"@"SEL$1" ("INVENTORY_FNSKU_PARTITIONS"."APPLICATION_NAME" "INVENTORY_FNSKU_PARTITIONS"."PROCESS_NAME" "INVENTORY_FNSKU_PARTITIONS"."FNSKU_PARTITION_ID"))',
		'INDEX(@"SEL$1C393AD9" "INVENTORY_NOTIFICATIONS"@"SEL$3" ("INVENTORY_NOTIFICATIONS"."MESSAGE_STATUS" "INVENTORY_NOTIFICATIONS"."FCSKU_PARTITION_ID"))',
		'LEADING(@"SEL$1C393AD9" "INVENTORY_FNSKU_PARTITIONS"@"SEL$1" "INVENTORY_NOTIFICATIONS"@"SEL$3")',
		'USE_NL(@"SEL$1C393AD9" "INVENTORY_NOTIFICATIONS"@"SEL$3")',
		'NLJ_BATCHING(@"SEL$1C393AD9" "INVENTORY_NOTIFICATIONS"@"SEL$3")',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = '4q5kz7gcgd41r' and p.plan_hash_value = 148740977 and p.parent_id is null
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
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.3'')',
		'DB_VERSION(''11.2.0.3'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OUTLINE_LEAF(@"SEL$1")',
		'INDEX_RS_ASC(@"SEL$1" "SP1"@"SEL$1" ("SHIPPING_PACKAGES"."APPLICATION" "SHIPPING_PACKAGES"."CREATION_DATE"))',
		'INDEX(@"SEL$1" "SP2"@"SEL$1" ("SHIPPING_PACKAGES"."SHIPMENT_ID"))',
		'LEADING(@"SEL$1" "SP1"@"SEL$1" "SP2"@"SEL$1")',
		'USE_NL(@"SEL$1" "SP2"@"SEL$1")',
		'NLJ_BATCHING(@"SEL$1" "SP2"@"SEL$1")',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = 'ggxg3vjjw3ga3' and p.plan_hash_value = 629217260 and p.parent_id is null
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
		'INDEX_RS_ASC(@"SEL$1" "THIS_"@"SEL$1" ("FCSKU_SALES_HISTORY"."FCSKU" "FCSKU_SALES_HISTORY"."SKU_SALE_EVENT_TYPE" "FCSKU_SALES_HISTORY"."SKU_SALE_EVENT_DATE"))',
		'OUTLINE_LEAF(@"SEL$1")',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'DB_VERSION(''11.2.0.3'')',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.3'')',
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = 'd6rmf0u4jddf7' and p.plan_hash_value = 1287376393 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id);
	end loop;
end;
/
