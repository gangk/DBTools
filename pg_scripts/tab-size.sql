DO $$
DECLARE
r RECORD;
db_size TEXT;
BEGIN
FOR r in
SELECT distinct table_name from admin.numeric_convert
LOOP
db_size:= (SELECT pg_size_pretty(pg_relation_size(r.table_name)));
RAISE NOTICE 'Table:% , Size:%', r.table_name , db_size;
END LOOP;
END$$;

