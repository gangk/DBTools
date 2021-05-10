colu job format 999999
colu what format A65
colu log_user format A9
colu interval format A30
colu Last_date_Time format a20
colu next_date_time formaT A20
select job, log_user,this_date, to_char(last_date,'DD-MM-YY HH24:MI:SS') Last_date_Time, to_char(next_date,'DD-MM-YY HH24:MI:SS') Next_Date_Time, interval,failures,what from dba_jobs where &1 order by 4;

