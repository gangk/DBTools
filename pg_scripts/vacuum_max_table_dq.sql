select a.relid, a.relname, a.n_tup_del, a.n_live_tup , a.n_dead_tup, a.last_autovacuum, a.last_autoanalyze, age(b.relfrozenxid) as xid_age, pg_size_pretty(pg_table_size(b.oid)) as table_size
from pg_stat_user_tables a, pg_class b
where a.relname = b.relname and a.n_dead_tup > (select setting::int from pg_settings where name='autovacuum_vacuum_threshold')  and now() - a.last_autovacuum > '6 hours'::interval and b.relkind = 'r';


