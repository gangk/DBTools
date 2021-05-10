-- Determine Top-5 child cursors
select * from
   (select sql_id, count(child_number)
      from v$sql_shared_cursor
     group by sql_id
     order by count(child_number) desc)
where rownum <=5;


-- Script Code
set serveroutput on

DECLARE
  v_count number;
  v_sql varchar2(500);
  v_sql_id varchar2(30) := '&sql_id';
BEGIN
  v_sql_id := lower(v_sql_id);
  dbms_output.put_line(chr(13)||chr(10));
  dbms_output.put_line('sql_id: '||v_sql_id);
  dbms_output.put_line('------------------------');
  FOR c1 in
    (select column_name 
       from dba_tab_columns
      where table_name ='V_$SQL_SHARED_CURSOR'
        and column_name not in ('SQL_ID', 'ADDRESS', 'CHILD_ADDRESS', 'CHILD_NUMBER', 'REASON')
      order by column_id)
  LOOP
    v_sql := 'select count(*) from V_$SQL_SHARED_CURSOR
              where sql_id='||''''||v_sql_id||''''||'
              and '||c1.column_name||'='||''''||'Y'||'''';
    execute immediate v_sql into v_count;
    IF v_count > 0
    THEN
      dbms_output.put_line(' - '||rpad(c1.column_name,30)||' count: '||v_count);
    END IF;
  END LOOP;
END;
/

