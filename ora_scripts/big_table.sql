alter table big_table nologging;
declare
l_cnt number;
l_rows number := &1;
begin
insert /*+ append */
into big_table
select rownum, a.*
from all_objects a
where rownum <= &1;
l_cnt := sql%rowcount;
commit;
while (l_cnt < l_rows)
loop
insert /*+ APPEND */ into big_table
select rownum+l_cnt,
OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID, DATA_OBJECT_ID,
OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS,
TEMPORARY, GENERATED, SECONDARY, NAMESPACE, EDITION_NAME
from big_table
where rownum <= l_rows-l_cnt;
l_cnt := l_cnt + sql%rowcount;
commit;
end loop;
end;