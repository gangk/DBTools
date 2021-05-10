-- given an object, explain plan for all afffected cursors
undef obj_name
select 	t.plan_table_output
from    (
        select 	 sql_id, child_number
        from 	 v$sql
        where 	 hash_value in (
                        select  from_hash
                        from    v$object_dependency
                        where   to_name = upper('&&obj_name')
        )
	and 	 last_active_time = (
			select max(timestamp) from v$sql_plan
			where object_name =  upper('&&obj_name'))
        ) v,
        table(dbms_xplan.display_cursor(v.sql_id, v.child_number)) t
;
