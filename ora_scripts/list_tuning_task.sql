SELECT task_id, task_name, created, advisor_name, status
FROM dba_advisor_tasks
where created > sysdate-2/24
order by created
;
--
