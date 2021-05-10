with binding as
(
select substr(column_value,14,instr(substr(column_value,14),'"',1,1)-1) name,extractvalue(value(d), '/bind') value from xmltable('/*/bind' passing
(
			select
                                xmltype(binds_xml) as xmlval
                        from
                                v$sql_monitor
                        where
                                binds_xml is not null
                        and
                                sql_id='&mysql'
                        and 
                        	sql_exec_id=&id
                        ) 
                                 ) d
)
select stmt from 
(
select 1, 'var '||regexp_replace(name,'^[1-9]','B'||name)||' varchar2(2000)' stmt from binding
union
select 2, 'exec :'||regexp_replace(name,'^[1-9]','B'||name)||':='''||value||''';' stmt from binding
order by 1
);

undef id
undef mysql
