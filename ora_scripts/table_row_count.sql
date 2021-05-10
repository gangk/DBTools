     set serveroutput on size 100000 feedback off

     declare
       rs     integer;       
       cur    integer;       
       rp     integer;       
       trs    integer;       
       n      integer;       
       un     varchar2(30);  
     begin
        dbms_output.put_line(rpad('Table Name',40)||' Number of Rows      Created Date');
        dbms_output.put_line(rpad('-',73,'-'));
        cur:= dbms_sql.open_cursor;
          for  t  in  (select  object_name, created from user_objects where object_type='TABLE') loop
            dbms_sql.parse(cur,'select count(*) from ' || t.object_name, dbms_sql.v7);
            dbms_sql.define_column(cur, 1, rs);
            rp:= dbms_sql.execute(cur);
            n:=dbms_sql.fetch_rows(cur);
            dbms_sql.column_value(cur, 1, rs);
            dbms_output.put_line(rpad(t.object_name,48,'.')||rpad(rs,15,'.')||t.created);
        end loop;
        dbms_sql.close_cursor(cur);
        select  count(*)  into  n  from  tab where tabtype='TABLE';
        select  user  into  un  from  dual;
        dbms_output.put_line(rpad('-',73,'-'));
        dbms_output.put_line(un||' User contain '||n||' Table(s)');
     end;
     /

     set  serveroutput off  feedback  on  feedback 6
