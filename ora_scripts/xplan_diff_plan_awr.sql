-- available only in 11R2+
-- null result?

undef sql_id
undef phash_val1
undef phash_val2
set linesize 180
set pagesize 2000
select dbms_xplan.diff_plan_awr('&&sql_id','&&phash_val1','&&phash_val2') from dual
;
