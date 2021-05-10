
SELECT SCN_TO_TIMESTAMP(TIMESTAMP_TO_SCN(startup_time)) "DB Shutdown Time" , startup_time "DB Startup Time" FROM v$instance;