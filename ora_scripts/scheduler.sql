colu JOB_NAME format 999999
colu JOB_ACTION format A80
colu interval format A15
colu Last_date_Time format a20
colu next_date_time formaT A20
select OWNER,JOB_NAME,to_char(last_start_date,'DD-MM-YY HH24:MI:SS') Last_date_time, to_char(next_run_date,'DD-MM-YY HH24:MI:SS') Next_Date_Time, JOB_ACTION from DBA_SCHEDULER_JOBS where job_name like UPPER('%&job_name%');