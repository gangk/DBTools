set linesize 200
set pagesize 1000

select to_number(value) shared_pool_size,
                         sum_obj_size,
                         sum_sql_size,
                         sum_user_size,
(sum_obj_size + sum_sql_size+sum_user_size)* 1.3 min_shared_pool
  from (select sum(sharable_mem) sum_obj_size
          from v$db_object_cache where type <> 'CURSOR'),
               (select sum(sharable_mem) sum_sql_size
          from v$sqlarea),
               (select sum(250 * users_opening) sum_user_size
          from v$sqlarea), v$parameter
 where name = 'shared_pool_size'
/
