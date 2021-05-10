declare
    p int;
    S_Archived int;
    S_Applied  int;
begin
 Select * into P,S_Archived,S_Applied
 from
(select Sequence#      P          from V\$log          where Status = 'CURRENT') a,
(Select Max(sequence#) S_Archived from v\$archived_log where dest_id = 2 and archived = 'YES') b,
(select Max(sequence#) S_Applied  from v\$archived_log where dest_id = 2 and applied  = 'YES') c;
dbms_output.put_line('Primary Current Log Seq Standby Archived Log Seq Standby Applied Log Seq Pending Logs to be applied');
dbms_output.put_line('----------------------- ------------------------ ----------------------- --------------------------');
dbms_output.put_line(p || '                   ' || S_Archived || '                    ' || S_Applied || '                   ' || (P-S_Applied));

If P-S_Applied > 1 then
       dbms_output.put_line(Chr(10));
       dbms_output.put_line('DG-Lagging');
       dbms_output.put_line('----------');
End if;
End;
/
