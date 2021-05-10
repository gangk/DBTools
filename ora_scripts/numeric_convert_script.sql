--Run3
DO $$
DECLARE
sql text;
v_statement text;
BEGIN
for v_statement in execute 'select ''alter table booker.''||table_name||'' ''||string_agg(''alter column ''||column_name||'' type ''||datatype1,'', '')||'';'' from admin.numeric_convert 
where table_name not in
(
''inventory_adjustment_items'',
''cost_messages'',
''order_pipeline_events'',
''fulfillment_shipment_item_map'',
''inventory_cost_txn_audits'',
''consumed_inventory_costs'',
''hist_inventory_cost_items'',
''binedit_entries'',
''inventory_adjustment_by_owner'',
''inventory_notifications'',
''inventory_bindings'',
''containers_physical''
)
and status = ''NO''
group by table_name'
loop
execute v_statement;
raise notice '%', v_statement;
end loop;
END$$;


--Run1 (done)

DO $$
DECLARE
sql text;
v_statement text;
BEGIN
for v_statement in execute 'select ''alter table booker.''||table_name||'' ''||string_agg(''alter column ''||column_name||'' type ''||datatype1,'', '')||'';'' from admin.numeric_convert
where table_name in
(
''transfer_request_items'',
''pending_customer_shipments''
)
and status = ''NO''
group by table_name'
loop
execute v_statement;
raise notice '%', v_statement;
end loop;
END$$;

--Run2 (done)
set max_parallel_workers_per_gather=12;

DO $$
DECLARE
sql text;
v_statement text;
BEGIN
for v_statement in execute 'select ''alter table booker.''||table_name||'' ''||string_agg(''alter column ''||column_name||'' type ''||datatype1,'', '')||'';'' from admin.numeric_convert
where table_name in
(
''cost_messages'',
''inventory_notifications'',
''inventory_adjustment_by_owner''
)
and status = ''NO''
group by table_name'
loop
execute v_statement;
raise notice '%', v_statement;
end loop;
END$$;

--Run4
set max_parallel_workers_per_gather=24;

DO $$
DECLARE
sql text;
v_statement text;
BEGIN
for v_statement in execute 'select ''alter table booker.''||table_name||'' ''||string_agg(''alter column ''||column_name||'' type ''||datatype1,'', '')||'';'' from admin.numeric_convert
where table_name in
(
''inventory_adjustment_items'',
''binedit_entries'',
''order_pipeline_events''
)
and status = ''NO''
group by table_name'
loop
execute v_statement;
raise notice '%', v_statement;
end loop;
END$$;

alter table booker.inventory_adjustment_items alter column record_version_number type bigint, alter column inventory_cost_id type bigint, alter column inventory_fiscal_owner_id type bigint, alter column adjustment_item_id type bigint;
alter table booker.binedit_entries alter column binedit_entry_id type bigint;
alter table booker.order_pipeline_events alter column event_id_new type bigint, alter column event_id_old type bigint, alter column day_of_week type bigint, alter column ope_id type bigint, alter column event_uid type bigint;




--Run5
set max_parallel_workers_per_gather=12;

DO $$
DECLARE
sql text;
v_statement text;
BEGIN
for v_statement in execute 'select ''alter table booker.''||table_name||'' ''||string_agg(''alter column ''||column_name||'' type ''||datatype1,'', '')||'';'' from admin.numeric_convert
where table_name in
(
''inventory_cost_txn_audits'',
''hist_inventory_cost_items'',
''fulfillment_shipment_item_map'',
''consumed_inventory_costs''
)
and status = ''NO''
group by table_name'
loop
execute v_statement;
raise notice '%', v_statement;
end loop;
END$$;

alter table booker.inventory_cost_txn_audits alter column record_version_number type bigint, alter column inventory_cost_id type bigint;
alter table booker.hist_inventory_cost_items alter column inventory_cost_id type bigint;
alter table booker.fulfillment_shipment_item_map alter column fc_fulfillment_request_item_id type bigint;
alter table booker.consumed_inventory_costs alter column record_version_number type bigint, alter column inventory_fiscal_owner_id type bigint, alter column inventory_cost_id type bigint;

--Run6

DO $$
DECLARE
sql text;
v_statement text;
BEGIN
for v_statement in execute 'select ''alter table booker.''||table_name||'' ''||string_agg(''alter column ''||column_name||'' type ''||datatype1,'', '')||'';'' from admin.numeric_convert
where table_name in
(
''containers_physical'',
''inventory_bindings''
)
and status = ''NO''
group by table_name'
loop
execute v_statement;
raise notice '%', v_statement;
end loop;
END$$;

alter table booker.containers_physical alter column container_id type bigint, alter column fc_filter_id type bigint, alter column containing_container_id type bigint;
alter table booker.inventory_bindings alter column inventory_binding_id type bigint;


--
select distinct table_name,status from admin.numeric_convert
where table_name not in
(
'inventory_adjustment_items',
'order_pipeline_events',
'fulfillment_shipment_item_map',
'inventory_cost_txn_audits',
'consumed_inventory_costs',
'hist_inventory_cost_items',
'binedit_entries',
'inventory_bindings',
'containers_physical'
)
and status = 'NO';

select * from admin.numeric_convert where table_name in ('inventory_bindings','cost_messages','inventory_notifications','inventory_adjustment_by_owner') and status='NO';

select 'alter table booker.'||table_name||' '||string_agg('alter column '||column_name||' type '||datatype1,', ')||';' from admin.numeric_convert
where table_name in
(
'inventory_adjustment_items',
'order_pipeline_events',
'fulfillment_shipment_item_map',
'inventory_cost_txn_audits',
'consumed_inventory_costs',
'hist_inventory_cost_items',
'binedit_entries',
'inventory_bindings',
'containers_physical'
)
and status = 'NO'
group by table_name;



