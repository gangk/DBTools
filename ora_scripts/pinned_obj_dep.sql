#########################################################################
#USAGE --> exec pinned_dep(<object_owner>,<object_name>,<object_type>);
#########################################################################
CREATE OR REPLACE procedure pinned_dep (obj_owner varchar2, obj_name varchar2, obj_type varchar2) is 

cursor c1 is
	select distinct owner, name, type from DBA_DEPENDENCIES
		where referenced_owner=obj_owner
		and referenced_NAME=obj_name
		and referenced_type=obj_type;

cursor c2(owner_c1 varchar2, obj_c1 varchar2) is
	select distinct decode(a.kglnaown,null,'NO OWNER',a.kglnaown) own,
	substr(a.kglnaobj,1,30) obj from x$kglob a, dba_kgllock b
		where a.kglhdadr=b.kgllkhdl
		and b.kgllkmod=2 and kgllktype='Pin' and a.kglnaown=owner_c1
		and a.KGLNAOBJ=obj_c1;

cursor c3(owner_c2 varchar2, name_c2 varchar2, type_c1 varchar2) is
		select distinct object_type, owner
		from all_objects where object_name=name_c2
		and owner=owner_c2 and object_type=type_c1;

dep_own c1%rowtype;
v_owner varchar2(30);
v_name varchar2(30);
v_type varchar2(50);
dep_owner varchar2(30);
dep_name varchar2(30);
dep_type varchar2(17);
vv_owner varchar2(30);
k number:=0;
m number:=0;

begin
	dbms_output.put_line('Pinned dependencies for object '||obj_owner||'.'||obj_name||':');
  open c1;
   loop
		fetch c1 into dep_owner, dep_name, dep_type;
	if c1%NOTFOUND and k=m then
	   dbms_output.put_line('Object '||obj_owner||'.'||obj_name||' has no dependencies at the moment');
	   exit when c1%NOTFOUND;
	else
	if c1%NOTFOUND and k<m and m=1 then
	   dbms_output.put_line('Object '||obj_owner||'.'||obj_name||' has dependencies but no pins at the moment');
	   exit when c1%NOTFOUND;
	else
	if c1%NOTFOUND and k<m and m=2 then
	exit when c1%NOTFOUND;
	end if;
	end if;
	end if;
     open c2(dep_owner, dep_name);
       loop
	fetch c2 into v_owner, v_name;
	   if c2%NOTFOUND and  k=m then
	      m:=1;
	      exit when c2%NOTFOUND;
           else
	   if c2%NOTFOUND and k<m and m=1 then
	      exit when c2%NOTFOUND;
	   else
           if c2%NOTFOUND and m=2 then
	      exit when c2%NOTFOUND;
           end if;
           end if;
	   end if;

             if v_owner=dep_owner and v_name=dep_name then
		open c3(v_owner, v_name, dep_type);
		loop
	     	fetch c3 into v_type, vv_owner;
		exit when c3%NOTFOUND;
                dbms_output.put_line(v_type||' - '||vv_owner||'.'||v_name);
		end loop;
		close c3;
		m:=2;
	     end if;
       end loop;
     close c2;
    end loop;
  close c1;
end;
/