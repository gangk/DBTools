accept object_name prompt 'Enter object_name:- '
set line 999
set pagesize 999
col owner format a20
col object format a30;
select * from v$access where upper(object) = upper('&object_name');
