
select owner,table_name from dba_tab_statistics where  stattype_locked is not
null and owner not in (’SYS’,'SYSTEM’)
/
DECLARE
v_table1 VARCHAR2(30);
v_owner1 VARCHAR2(30);
cursor C1 is select owner,table_name from dba_tab_statistics where
stattype_locked is not null and owner not in (’SYS’,'SYSTEM’) ;
BEGIN
OPEN C1;
loop
fetch C1 into v_owner1,v_table1;
exit when C1%NOTFOUND;
dbms_stats.unlock_schema_stats(v_owner1);
dbms_stats.unlock_table_stats(v_owner1,v_table1);
end loop;
close C1;
END;
/
select owner,table_name from dba_tab_statistics where  stattype_locked is not
null and owner not in (’SYS’,'SYSTEM’) ;

