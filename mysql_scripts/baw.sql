select p1.id waiting_thread, p1.user waiting_user, p1.host waiting_host, it1.trx_query waiting_query,
       ilw.requesting_trx_id waiting_transaction, ilw.blocking_lock_id blocking_lock, il.lock_mode blocking_mode,
       il.lock_type blocking_type, ilw.blocking_trx_id blocking_transaction,
       case it.trx_state when 'LOCK WAIT' then it.trx_state else p.state end blocker_state, il.lock_table locked_table,
       it.trx_mysql_thread_id blocker_thread, p.user blocker_user, p.host blocker_host
from information_schema.innodb_lock_waits ilw
join information_schema.innodb_locks il on ilw.blocking_lock_id = il.lock_id and ilw.blocking_trx_id = il.lock_trx_id
join information_schema.innodb_trx it on ilw.blocking_trx_id = it.trx_id
join information_schema.processlist p on it.trx_mysql_thread_id = p.id
join information_schema.innodb_trx it1 on ilw.requesting_trx_id = it1.trx_id
join information_schema.processlist p1 on it1.trx_mysql_thread_id = p1.id;


SELECT
  r.trx_id waiting_trx_id,
  r.trx_mysql_thread_id waiting_thread,
  r.trx_query waiting_query,
  b.trx_id blocking_trx_id,
  b.trx_mysql_thread_id blocking_thread,
  b.trx_query blocking_query
FROM       information_schema.innodb_lock_waits w
INNER JOIN information_schema.innodb_trx b
  ON b.trx_id = w.blocking_trx_id
INNER JOIN information_schema.innodb_trx r
  ON r.trx_id = w.requesting_trx_id;


