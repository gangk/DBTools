accept owner char prompt "Enter database link owner : "
accept db_link char prompt "Enter link name : "

begin
  dbms_scheduler.create_job(
    job_name=>'&owner..drop_database_link',
    job_type=>'PLSQL_BLOCK',
    job_action=>'BEGIN execute immediate ''drop database link &db_link'';END;'
  );
  dbms_scheduler.run_job('&owner..drop_database_link',false);
  dbms_lock.sleep(2);
  dbms_scheduler.drop_job('&owner..drop_database_link');
end;
/