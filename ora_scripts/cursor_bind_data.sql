undef sql_id
@plusenv
col sql_id	format a13
col cpusecs	format 9999999
col sqltext	format a50	trunc
col module	format a26	trunc
col pos		format 999	head 'Pos'
col bval	format a30	head 'Bind Value'
select 	 s.sql_text
	,c.bind_vars
	,b.datatype
	,b.value
from 	 v$sql_cursor c
	,v$sql s
	,v$sql_bind_data b
where 	s.address = c.parent_handle
and 	c.curno = b.cursor_num
and	s.sql_id = '&&sql_id'
;
