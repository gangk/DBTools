undef sql_id
undef pcursor

col curs	noprint new_value pcursor
set echo off head off feed off 
select address||','||hash_value curs from v$sqlarea
where sql_id ='&&sql_id'
;

set termout on feed on
prompt Purging cursor &pcursor ...
exec sys.dbms_shared_pool.purge('&pcursor','C');
-- @sqlid_info
