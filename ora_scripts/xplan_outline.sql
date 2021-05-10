explain plan for
update bucketized_tasks set processed = 'Y' where task_id in (select * from table(in_list_str( :1  )))
;
select * from table(dbms_xplan.display(null, null, 'OUTLINE'));
