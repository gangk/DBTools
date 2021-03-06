declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'USE_HASH_AGGREGATION(@"SEL$24AECD26")',
		'NLJ_BATCHING(@"SEL$24AECD26" "BI"@"SEL$2")',
		'USE_NL(@"SEL$24AECD26" "BI"@"SEL$2")',
		'USE_NL(@"SEL$24AECD26" "FCF"@"SEL$6")',
		'USE_NL(@"SEL$24AECD26" "CONTAINERS_PHYSICAL"@"SEL$3")',
		'LEADING(@"SEL$24AECD26" "CONT_C"@"SEL$4" "CONTAINERS_PHYSICAL"@"SEL$3" "FCF"@"SEL$6" "BI"@"SEL$2")',
		'INDEX(@"SEL$24AECD26" "BI"@"SEL$2" ("BIN_ITEMS"."CONTAINER_ID"))',
		'INDEX_RS_ASC(@"SEL$24AECD26" "FCF"@"SEL$6" ("FC_FILTERS"."FC_FILTER_ID" "FC_FILTERS"."WAREHOUSE_ID"))',
		'INDEX_RS_ASC(@"SEL$24AECD26" "CONTAINERS_PHYSICAL"@"SEL$3" ("CONTAINERS_PHYSICAL"."CONTAINING_CONTAINER_ID" "CONTAINERS_PHYSICAL"."CONTAINER_TYPE"))',
		'INDEX_RS_ASC(@"SEL$24AECD26" "CONT_C"@"SEL$4" ("CONTAINERS_PHYSICAL"."SCANNABLE_ID"))',
		'USE_NL(@"SEL$F549B632" "TR"@"SEL$18")',
		'USE_NL(@"SEL$F549B632" "CONTAINERS_PHYSICAL"@"SEL$10")',
		'USE_NL(@"SEL$F549B632" "TRI"@"SEL$16")',
		'USE_NL(@"SEL$F549B632" "TRIB"@"SEL$14")',
		'USE_NL(@"SEL$F549B632" "BI"@"SEL$9")',
		'LEADING(@"SEL$F549B632" "CONTAINERS_PHYSICAL"@"SEL$12" "BI"@"SEL$9" "TRIB"@"SEL$14" "TRI"@"SEL$16" "CONTAINERS_PHYSICAL"@"SEL$10" "TR"@"SEL$18")',
		'INDEX_RS_ASC(@"SEL$F549B632" "TR"@"SEL$18" ("TRANSFER_REQUESTS"."TRANSFER_REQUEST_ID" "TRANSFER_REQUESTS"."WAREHOUSE_ID"))',
		'INDEX_RS_ASC(@"SEL$F549B632" "CONTAINERS_PHYSICAL"@"SEL$10" ("CONTAINERS_PHYSICAL"."CONTAINER_ID"))',
		'INDEX_RS_ASC(@"SEL$F549B632" "TRI"@"SEL$16" ("TRANSFER_REQUEST_ITEMS"."TRANSFER_REQUEST_ITEM_ID" "TRANSFER_REQUEST_ITEMS"."WAREHOUSE_ID"))',
		'INDEX_RS_ASC(@"SEL$F549B632" "TRIB"@"SEL$14" ("TRANSFER_REQUEST_ITEM_BINDINGS"."TRANSFER_REQ_ITEM_BINDING_ID"))',
		'INDEX_RS_ASC(@"SEL$F549B632" "BI"@"SEL$9" ("BIN_ITEMS"."OWNER" "BIN_ITEMS"."CONTAINER_ID"))',
		'INDEX_RS_ASC(@"SEL$F549B632" "CONTAINERS_PHYSICAL"@"SEL$12" ("CONTAINERS_PHYSICAL"."SCANNABLE_ID"))',
		'USE_HASH_AGGREGATION(@"SEL$BE0B514E")',
		'NO_ACCESS(@"SEL$BE0B514E" "VW_DAG_0"@"SEL$BE0B514E")',
		'USE_NL(@"SEL$1" "DESTS"@"SEL$1")',
		'LEADING(@"SEL$1" "COUNTS"@"SEL$1" "DESTS"@"SEL$1")',
		'NO_ACCESS(@"SEL$1" "DESTS"@"SEL$1")',
		'NO_ACCESS(@"SEL$1" "COUNTS"@"SEL$1")',
		'OUTLINE(@"SEL$10")',
		'OUTLINE(@"SEL$9")',
		'OUTLINE(@"SEL$11")',
		'MERGE(@"SEL$10")',
		'OUTLINE(@"SEL$0EE6DB63")',
		'OUTLINE(@"SEL$13")',
		'MERGE(@"SEL$11")',
		'MERGE(@"SEL$0EE6DB63")',
		'OUTLINE(@"SEL$7C28817E")',
		'OUTLINE(@"SEL$14")',
		'OUTLINE(@"SEL$15")',
		'MERGE(@"SEL$7C28817E")',
		'MERGE(@"SEL$14")',
		'OUTLINE(@"SEL$D6E5BC54")',
		'OUTLINE(@"SEL$16")',
		'OUTLINE(@"SEL$17")',
		'OUTLINE(@"SEL$3")',
		'OUTLINE(@"SEL$2")',
		'MERGE(@"SEL$D6E5BC54")',
		'MERGE(@"SEL$16")',
		'OUTLINE(@"SEL$A6814521")',
		'OUTLINE(@"SEL$18")',
		'OUTLINE(@"SEL$19")',
		'OUTLINE(@"SEL$20")',
		'OUTLINE(@"SEL$4")',
		'MERGE(@"SEL$3")',
		'OUTLINE(@"SEL$335DD26A")',
		'OUTLINE(@"SEL$5")',
		'MERGE(@"SEL$A6814521")',
		'MERGE(@"SEL$18")',
		'OUTLINE(@"SEL$DAD89B32")',
		'OUTER_JOIN_TO_INNER(@"SEL$20")',
		'OUTLINE(@"SEL$60D552F4")',
		'OUTLINE(@"SEL$6")',
		'MERGE(@"SEL$4")',
		'MERGE(@"SEL$335DD26A")',
		'OUTLINE(@"SEL$20D83E82")',
		'OUTLINE(@"SEL$7")',
		'OUTLINE(@"SEL$8")',
		'OUTLINE(@"SEL$12")',
		'MERGE(@"SEL$DAD89B32")',
		'OUTLINE(@"SEL$0CB8CED2")',
		'MERGE(@"SEL$6")',
		'MERGE(@"SEL$20D83E82")',
		'OUTLINE(@"SEL$9F7DB5F0")',
		'OUTER_JOIN_TO_INNER(@"SEL$8")',
		'OUTLINE(@"SEL$1182123A")',
		'OUTLINE(@"SEL$1")',
		'MERGE(@"SEL$12")',
		'OUTLINE(@"SEL$974B2BA9")',
		'TRANSFORM_DISTINCT_AGG(@"SEL$CA73643D")',
		'OUTLINE(@"SEL$24AECD26")',
		'MERGE(@"SEL$9F7DB5F0")',
		'OUTLINE(@"SEL$CA73643D")',
		'OUTLINE_LEAF(@"SEL$1")',
		'PUSH_PRED(@"SEL$1" "DESTS"@"SEL$1" 1)',
		'OUTLINE_LEAF(@"SEL$F549B632")',
		'OUTLINE_LEAF(@"SEL$BE0B514E")',
		'TRANSFORM_DISTINCT_AGG(@"SEL$CA73643D")',
		'OUTLINE_LEAF(@"SEL$24AECD26")',
		'OPT_PARAM(''optimizer_index_caching'' 80)',
		'OPT_PARAM(''optimizer_index_cost_adj'' 3)',
		'OPT_PARAM(''_optimizer_connect_by_cost_based'' ''false'')',
		'OPT_PARAM(''_optim_peek_user_binds'' ''false'')',
		'OPT_PARAM(''_b_tree_bitmap_plans'' ''false'')',
		'DB_VERSION(''11.2.0.2'')',
		'OPTIMIZER_FEATURES_ENABLE(''11.2.0.2'')',
		'IGNORE_OPTIM_EMBEDDED_HINTS',
		'END_OUTLINE_DATA'
);
for sql_rec in (
	select t.sql_id, t.sql_text
	 from dba_hist_sqltext t, dba_hist_sql_plan p
	where t.sql_id = p.sql_id and p.sql_id = 'a6v6t7p32ru4a' and p.plan_hash_value = 4016480850 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id);
	end loop;
end;
/
