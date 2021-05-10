set long 9999999
select text from dba_source where name=upper('&obj_name') order by line;

undef obj_name
