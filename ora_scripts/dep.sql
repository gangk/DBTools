col dep_owner 			head OWNER		for a16
col dep_name			head DEPENDENT_NAME	for a30
col dep_type			head DEPENDENT_TYPE	for a12
col dep_referenced_owner	head REF_OWNER		for a16
col dep_referenced_name		head REF_NAME		for a30
col dep_referenced_type		head REF_TYPE		for a12
col dep_depency_type		head HARDSOFT		for a8

select 
	owner			dep_owner, 
	name			dep_name,
	type			dep_type,
	referenced_owner	dep_referenced_owner,
	referenced_name		dep_referenced_name,
	referenced_type		dep_referenced_type,
	dependency_type		dep_dependency_type
from 
	dba_dependencies 
where 
	lower(owner) like lower('&owner') 
and	lower(name) like lower('&object_name')
/


