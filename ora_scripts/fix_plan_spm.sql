DECLARE
my_plans pls_integer;
BEGIN
my_plans := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id => 'faaqqrwv5sj2n', plan_hash_value => 4160131797, fixed => 'YES'); 
END; /
