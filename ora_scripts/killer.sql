declare
ar_profile_hints sys.sqlprof_attr;
begin
	ar_profile_hints := sys.sqlprof_attr(
		'BEGIN_OUTLINE_DATA',
		'INDEX_RS_ASC(@"SEL$2" "TIME_CLOCK_PUNCHES"@"SEL$2" "I_TCP_EMP_ID_PUN_DATE")',
		'NO_ACCESS(@"SEL$1" "from$_subquery$_001"@"SEL$1")',
		'OUTLINE_LEAF(@"SEL$1")',
		'OUTLINE_LEAF(@"SEL$2")',
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
	where t.sql_id = p.sql_id and p.sql_id = 'gay8y4gavqaut' and p.plan_hash_value = 3088756932 and p.parent_id is null
		) loop
	      DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
		sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => 'PROFILE_'||sql_rec.sql_id);
	end loop;
end;
/
