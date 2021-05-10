set echo on
col name format a25
col network_name format a30
select name,network_name
from v$active_services 
where network_name is not null
;
