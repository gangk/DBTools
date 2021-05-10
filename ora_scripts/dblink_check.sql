set feedback off
set serveroutput on

declare

l_result varchar2(1000);
l_status number default null;
l_cursor integer;

begin

execute immediate ('ALTER SESSION SET GLOBAL_NAMES=FALSE');
for c1 in
(  select u.user_id ,d.owner , d.db_link
from
dba_db_links d,dba_users u
where d.owner=u.username
order by d.owner
) loop

begin

dbms_output.put_line('#######################################################################');
-- dbms_output.put_line('userid....: '|| c1.user_id);
dbms_output.put_line('owner...: '|| c1.owner);
dbms_output.put_line('db_link.....: '|| c1.db_link);

l_cursor:=sys.dbms_sys_sql.open_cursor();

sys.dbms_sys_sql.parse_as_user(l_cursor,'select * from global_name@'||c1.db_link,dbms_sql.native,c1.user_id);

sys.dbms_sys_sql.define_column( l_cursor,1,l_result,1000);

l_status:=sys.dbms_sys_sql.execute(l_cursor);

if ( dbms_sys_sql.fetch_rows(l_cursor) > 0 )
then
dbms_sys_sql.column_value(l_cursor, 1,l_result );
end if;

dbms_output.put_line('Global_name of remote database: '||l_result);

sys.dbms_sys_sql.close_cursor(l_cursor);

commit;

exception
when others  then dbms_output.put_line('Error: ' || SQLCODE || ' ' || SQLERRM);

end;

end loop;

end ;
/