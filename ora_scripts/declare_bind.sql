with binding as
(
	select replace(name,':','') name,value_string
	from v$sql_bind_capture
	where 
	sql_id='&mysql' and child_number=&child
)
select stmt from
(
select 1, 'var '||regexp_replace(name,'^[1-9]','B'||name)||' varchar2(2000)' stmt from binding
union
select 2, 'exec :'||regexp_replace(name,'^[1-9]','B'||name)||':='''||value_string||''';' stmt from binding
order by 1
);

undef mysql
undef child
