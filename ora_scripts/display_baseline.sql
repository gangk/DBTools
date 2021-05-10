SELECT sql_handle, plan_name, enabled, accepted
FROM   dba_sql_plan_baselines
WHERE  sql_handle = '&sql_handle';


set line 900
select * from table(dbms_xplan.display_sql_plan_baseline(sql_handle => '&sql_handle'));


select extractValue(value(h),'.') AS hint from sys.sqlobj$data od,sys.sqlobj$ so,
table(xmlsequence(extract(xmltype(od.comp_data),'/outline_data/hint'))) h
where so.name ='&SQL_PLAN_NAME'
and so.signature = od.signature
and so.category = od.category
and so.obj_type = od.obj_type
and so.plan_id = od.plan_id;
