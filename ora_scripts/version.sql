set head off feed off 


col banner format a72 wrap

select banner
from   sys.v_$version;

select '   With the '||parameter||' option'
from   sys.v_$option
where  value = 'TRUE';

select '   The '||parameter||' option is not installed'
from   sys.v_$option
where  value <> 'TRUE';

begin
    dbms_output.put_line('Port String: '||dbms_utility.port_string);
end;
/

set head on feed on
