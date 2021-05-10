select to_char(logon_time,'DD-MM HH24:MI'),MODULE,count(1) no_of_connects from admin.DB_LOGONS where LOGON_TIME between to_date ('&start_time','DD-MM-YY HH24:MI') and 
to_date ('&end_time','DD-MM-YY HH24:MI') and module='&module' group by to_char(logon_time,'DD-MM HH24:MI'),MODULE order by 1;
