COLUMN comments FORMAT A40

SELECT window_name,
       resource_plan,
       enabled,
       active,
       comments
FROM   dba_scheduler_windows
ORDER BY window_name;
