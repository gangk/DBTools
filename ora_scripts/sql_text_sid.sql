set linesize 200
set pagesize 1000
set long 3000
select sql_fulltext from v$sql where (ADDRESS,HASH_VALUE) in (select sql_address,sql_hash_value from v$session where sid= &sid_number);

