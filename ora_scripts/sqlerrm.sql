set linesize 180
set trimspool on
set serveroutput on size 1000000 format wrapped
-- Usage sqlerrm(-nnnnn)
declare
    m_ct        number(5) := 0;
    m_message   varchar2(511);
begin
    for i in 10000..10999 loop
--  for i in 1..65535 loop
        m_message := sqlerrm(-i);
        if m_message not like 'ORA-_____: Message _____ not found;%' then
--      if lower(m_message) like 'ora-%event%' then
            m_ct := m_ct + 1;
            dbms_output.put_line(m_message);
        end if;
    end loop;
    dbms_output.new_line;
    dbms_output.put_line('Messages reported: ' || m_ct);
end;
/