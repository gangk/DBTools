accept obj_name prompt'Enter Object_name:- '
col db_link for a30
select * from dba_synonyms where SYNONYM_NAME like upper('%&obj_name%')
union
select * from dba_synonyms where TABLE_NAME like upper('%&obj_name%');
