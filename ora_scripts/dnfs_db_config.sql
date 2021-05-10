spool db_dnfs_layout.html
SET MARKUP HTML ON
set echo on

set pagesize 200

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';

select 'THIS DB REPORT WAS GENERATED AT: ==)> ' , sysdate " "  from dual;


select 'HOSTNAME ASSOCIATED WITH THIS DB INSTANCE: ==)> ' , MACHINE " " from v$session where program like '%SMON%';

select * from v$dnfs_servers;
select * from v$dnfs_files;
select * from v$dnfs_channels;
select * from v$dnfs_stats;

select * from v$datafile;
select * from dba_data_files;
select * from DBA_TEMP_FILES;
select * from v$logfile;
select * from  v$log;

select * from v$version;

show parameter


spool off

exit