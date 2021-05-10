SET SERVEROUTPUT ON
declare
cursor c1 is
select owner,table_name from DBA_TABLES
where owner = '&owner';
c_rec c1%rowtype;
m varchar2(1000);
n number:=0;
begin
DBMS_OUTPUT.ENABLE (500000);
for c_rec in c1
loop
m:='select count(*) from '||c_rec.owner||'.' || c_rec.table_name ;
--dbms_output.put_line( m);
execute immediate m into n ;
dbms_output.put_line('TOTAL ROWS IN TABLE ' || c_rec.table_name || ':='||n);
end loop;
end; 
/






