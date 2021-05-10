accept sql_id prompt 'Enter SQL_ID:- '
DECLARE
 name varchar2(50);
BEGIN
 select distinct address||','||hash_value into name
 from v$sqlarea
 where sql_id like '&sql_id';

 sys.dbms_shared_pool.purge(name,'C',65);

END;
/

