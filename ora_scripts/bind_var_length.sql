@plusenv
select	 address
	,position
	,datatype
	,max_length
	,bind_name
from	 v$sql_bind_metadata
where	 address in
(select	 child_address from v$sql
 where	 address = '&par_address'
 and	 position= &position)
;
