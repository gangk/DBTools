select a.sql_id,b.address,b.hash_value,b.child_number,b.plan_hash_value,b.sql_text
 from v$session a, v$sql b
 where a.SQL_ADDRESS=b.ADDRESS
 and a.sid=&mysid
 /
