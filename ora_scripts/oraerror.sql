set serveroutput on
set veri off feed off

prompt Lookup Oracle error messages:
prompt
prompt Please enter error numbers as negatives. E.g. -1
prompt

exec dbms_output.put_line('==> '||sqlerrm( &errno ) );

set veri on feed on
undef errno
