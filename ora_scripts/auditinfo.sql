accept OBJ_NAME prompt 'Enter Object Name:- '
accept DDL prompt 'Enter truncated DDL:- '
accept num_days prompt 'Enter num_days:- '
set line 999
set verify off;
col TRUNCATED_DDL format a40;
select DDL_DATE, object_name, ORACLE_USERNAME, OS_USERNAME, TRUNCATED_DDL from admin.DB_AUDITED_DDL_OPERATIONS
where OBJECT_NAME like '%&OBJ_NAME%'
and TRUNCATED_DDL like '%&DDL%'
and DDL_DATE > (sysdate - &num_days)
order by DDL_DATE;
