set lines 150 pages 100
col MACHINE for a25

select sid ,SERIAL#,terminal,program,SQL_HASH_VALUE from v$session where status='ACTIVE'and username='MMFDBA'
/
