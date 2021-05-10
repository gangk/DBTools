begin
sys.dbms_sqldiag.drop_sql_patch('&patch');
end;
 /

undef patch
