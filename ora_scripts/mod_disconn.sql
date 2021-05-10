select to_char(logoff_time,'DD-MM HH24:MI'),MODULE,count(1) no_of_disconnects from admin.DB_LOGONS where LOGOFF_TIME between to_date ('&start_time','DD-MM-YY HH24:MI') and
to_date ('&end_time','DD-MM-YY HH24:MI') and module='&module' group by to_char(logoff_time,'DD-MM HH24:MI'),MODULE order by 1;
