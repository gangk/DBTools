set serverout on size 1000000
set lines 132
declare
  cursor cur_lock is
         select sid,id1,id2,inst_id, ctime
           from gv$lock
          where block = 1;
  vid1       number;
  vid2       number;
  cursor cur_locked is
         select sid, inst_id, ctime
           from gv$lock
          where id1 = vid1
            and id2 = vid2
            and block <> 1;
  vlocks     varchar2(30);
  vsid1      number;
  vobj1      number;
  vfil1      number;
  vblo1      number;
  vrow1      number;
  vrowid1    varchar2(20);
  vcli1      varchar2(64);
  vobj2      number;
  vfil2      number;
  vblo2      number;
  vrow2      number;
  vrowid2    varchar2(20);
  vcli2      varchar2(64);
  vobjname   varchar2(30);
  vlocked    varchar2(30);
  ctim1      number;
  ctim2      number;
begin
dbms_output.put_line('=====================================================');
dbms_output.put_line('Blocking lock list.');
dbms_output.put_line('=====================================================');
dbms_output.put_line('Block / Is blocked         SID        INST_ID OBJECT                         TIME(secs) ROWID              CLIENT_IDENTIFIER');
dbms_output.put_line('-------------------------  ---------  ------- ------------------------------ ---------- ------------------ -----------------');
  for c1 in cur_lock loop
      vid1 := c1.id1;
      vid2 := c1.id2;
      select username,sid,row_wait_obj#,row_wait_file#,row_wait_block#,row_wait_row#,client_identifier
                 into vlocks,vsid1,vobj1,vfil1,vblo1,vrow1,vcli1 
                 from gv$session where sid = c1.sid and inst_id = c1.inst_id;
      if vobj1 = -1 then
         vobjname := 'UNKNOWN';
      else
         select name into vobjname from sys.obj$ where obj# = vobj1;
         select decode(vrow1,0,'MANY ROWS',dbms_rowid.rowid_create(1, vobj1, vfil1, vblo1, vrow1)) into vrowid1 from dual;
      end if;
      dbms_output.put_line(rpad(vlocks,25) || ' ' ||
                           to_char(vsid1,'999999999') || ' ' ||
                           to_char(c1.inst_id,'9999999') || ' ' ||
                           rpad(vobjname,30) || ' ' ||
                           to_char(c1.ctime,'999999999') || ' ' || rpad(vrowid1,18) || ' ' || vcli1);
      for c2 in cur_locked loop
          select username, row_wait_obj#,row_wait_file#,row_wait_block#,row_wait_row#
            into vlocked, vobj2, vfil2, vblo2, vrow2 
            from gv$session where sid = c2.sid and inst_id = c2.inst_id;
          if vobj2 = -1 then
             vobjname := 'UNKNOWN';
          else
             select name into vobjname from sys.obj$ where obj# = vobj2;
             select decode(vrow2,0,'MANY ROWS',dbms_rowid.rowid_create(1, vobj2, vfil2, vblo2, vrow2)) into vrowid2 from dual;
          end if;
          dbms_output.put_line(chr(9) || '\--> ' || rpad(vlocked,12) || ' ' || 
                 to_char(c2.sid,'999999999') || ' ' || 
                 to_char(c2.inst_id,'9999999') || ' ' || rpad(vobjname,30) || ' ' ||
                 to_char(c2.ctime,'999999999') || ' ' || rpad(vrowid2,18) || ' ' || vcli2 ) ;
      end loop;
  end loop;
commit;
end;
/
