declare
event_level number;
begin
for i in 10000..29999 loop
sys.dbms_system.read_ev(i,event_level);
-- note: requires exec permission for DBMS_SYSTEM
if (event_level > 0) then
dbms_output.put_line
('Event '||i||' set at level '|| event_level);
end if;
end loop;
end;