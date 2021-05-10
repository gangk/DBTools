############################################################################
# USAGE exec pinned_obj(<object_owner>,<object_name>,<object_type>);
############################################################################

CREATE OR REPLACE
procedure pinned_obj (obj_owner varchar2, obj_name varchar2, obj_type varchar2) is

cursor c1 is
          select distinct decode(a.kglnaown,null,'NO OWNER',a.kglnaown) own, substr(a.kglnaobj,1,30) obj,
                    b.kgllkhdl kglhandle
            from x$kglob a, dba_kgllock b, v$db_object_cache c
                    where a.kglhdadr=b.kgllkhdl
                    and a.kglhdexc=c.executions
                    and upper(c.type)=obj_type
                    and b.kgllkmod=2 and kgllktype='Pin'
                    and upper(a.kglnaobj) like obj_name;

cursor c2 is
          select distinct a.sid, a.serial#, a.username, a.osuser, a.terminal, a.program, a.module, b.kgllkhdl
                    from v$session a, dba_kgllock b where a.saddr=b.kgllkuse and b.kgllkmod=2 and b.kgllktype='Pin';

v_owner varchar2(30);
v_name varchar2(30);
v_type varchar2(50);
v_kglhandle RAW(8);
vv_kgllkhdl RAW(8);
k number:=0;
m number:=0;
v_sid number;
v_serial number;
v_username varchar2(30);
v_osuser varchar2(30);
v_terminal VARCHAR2(30);
v_program VARCHAR2(48);
v_module VARCHAR2(48);
begin

open c1;
   loop
     fetch c1 into v_owner, v_name, v_kglhandle;
       if c1%NOTFOUND and k=m then
          dbms_output.put_line('Object '||obj_owner||'.'||obj_name||' has no pins at the moment');
          exit when c1%NOTFOUND;
      else
        if c1%NOTFOUND and k<m and m=1 then
            exit when c1%NOTFOUND;
	else
	     if c1%NOTFOUND and k<m and m=2 then
	     exit when c1%NOTFOUND;
        end if;
      end if;
    end if;
      dbms_output.put_line('Object '||obj_owner||'.'||obj_name||' is pinned by:');
          open c2;
             loop
               fetch c2 into v_sid, v_serial, v_username, v_osuser, v_terminal,v_program, v_module, vv_kgllkhdl;
	          if c2%NOTFOUND and  k=m then
	             m:=1;
	             exit when c2%NOTFOUND;
                  else
                    if c2%NOTFOUND and m=2 then
	               exit when c2%NOTFOUND;
                    end if;
                 end if;
           if vv_kgllkhdl=v_kglhandle
              then
              dbms_output.put_line(v_sid||' '||v_serial||' '||v_username||' '||v_osuser||' '||v_terminal||' '||v_program||' '||v_module);
              m:=2;
           end if;
      end loop;
     close c2;
   end loop;
close c1;
end;
/