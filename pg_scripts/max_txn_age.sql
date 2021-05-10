select txid_current();

select max(age(datfrozenxid)) from pg_database;

SELECT relname, age(relfrozenxid) as xid_age, 
    pg_size_pretty(pg_table_size(oid)) as table_size
FROM pg_class 
WHERE relkind = 'r' and pg_table_size(oid) > 1073741824
ORDER BY age(relfrozenxid) DESC LIMIT 20;

SELECT relname, age(relfrozenxid) as xid_age,
    pg_size_pretty(pg_table_size(oid)) as table_size
FROM pg_class
WHERE relkind = 'r' and pg_table_size(oid) > 200000000
ORDER BY age(relfrozenxid) DESC LIMIT 20;

SELECT relname, age(relfrozenxid) as xid_age,
    pg_size_pretty(pg_table_size(oid)) as table_size
FROM pg_class
WHERE relkind = 'r' ORDER BY age(relfrozenxid) DESC LIMIT 20;

SELECT relname, age(relfrozenxid) as xid_age, pg_size_pretty(pg_table_size(oid)) as table_size FROM pg_class WHERE relkind = 'r' and age(relfrozenxid) > 200000000;

