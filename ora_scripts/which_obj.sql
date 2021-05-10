define __FILE = &1
define __BLOCK = &2

alter system dump datafile &__FILE block &__BLOCK;

declare
	v_dba		varchar2(100);
	v_type	varchar2(100);
	v_obj_id		number;
	v_obj_name	varchar2(100);
begin
	for r in (select column_value as t from table(get_trace_file1)) loop
		if regexp_like(r.t, 'buffer tsn:') then
			dbms_output.put_line('------------------------------------------------');
			v_dba := regexp_substr(r.t, '[[:digit:]]+/[[:digit:]]+');
			dbms_output.put_line(rpad('dba = ',20)|| v_dba);
		end if;

		if regexp_like(r.t, 'type: 0x([[:xdigit:]]+)=([[:print:]]+)') then
			v_type := substr(regexp_substr(r.t, '=[[:print:]]+'), 2);
			dbms_output.put_line(rpad('type = ',20)|| v_type);
		end if;

		if regexp_like(r.t, 'seg/obj:') then
			v_obj_id := to_dec(substr(regexp_substr(r.t,
							'seg/obj: 0x[[:xdigit:]]+'), 12));
			select object_name into v_obj_name from all_objects
				where data_object_id = v_obj_id;
			dbms_output.put_line(rpad('object_id = ',20)|| v_obj_id);
			dbms_output.put_line(rpad('object_name = ',20)|| v_obj_name);
		end if;

		if regexp_like(r.t, 'Objd: [[:digit:]]+') then
			v_obj_id := substr(regexp_substr(r.t, 'Objd: [[:digit:]]+'), 7);
			select object_name into v_obj_name from all_objects
				where data_object_id = v_obj_id;
			dbms_output.put_line(rpad('object_id = ',20)|| v_obj_id);
			dbms_output.put_line(rpad('object_name = ',20)|| v_obj_name);
		end if;

	end loop;

	dbms_output.put_line('------------------------------------------------');

end;
/
