col machine for a50
col module for a50
col username for a30
set lines 500
select distinct db_name,username,module,machine from DB_LOGONS_SUMMARY where username=upper('&username');
