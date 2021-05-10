col username for a25
col accoutn_status for a20
col TEMPORARY_TBS for a15



select username,account_status,default_tablespace,temporary_tablespace "TEMPORARY_TBS",profile from dba_users;