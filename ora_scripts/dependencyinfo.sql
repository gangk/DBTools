col owner for a15
col name for a30
col type for a20
col REFERENCED_NAME for a30
col REFERENCED_OWNER for a15
col REFERENCED_TYPE for a20
col status for a10
accept object_name prompt 'Enter object_name:- '

Prompt Obj dependen on:-- 

select dep.OWNER,dep.NAME,dep.TYPE,obj.status,dep.REFERENCED_OWNER,dep.REFERENCED_NAME,dep.REFERENCED_TYPE,ref.status from dba_dependencies  dep,dba_objects obj,dba_objects ref
where
	NAME=upper('&object_name')
and
	dep.name=obj.object_name
and
        dep.owner=obj.owner
and
        dep.type=obj.object_type
and
        dep.referenced_name=ref.object_name
and
        dep.referenced_owner=ref.owner
and
        dep.referenced_type=ref.object_type
order by 4,5,6;

Prompt dependent objects:-- 

select dep.OWNER,dep.NAME,dep.TYPE,obj.status,dep.REFERENCED_OWNER,dep.REFERENCED_NAME,dep.REFERENCED_TYPE,ref.status from dba_dependencies dep,dba_objects obj,dba_objects ref
where
        REFERENCED_NAME=upper('&object_name')
and
	dep.name=obj.object_name
and
	dep.owner=obj.owner
and
	dep.type=obj.object_type
and
	dep.referenced_name=ref.object_name
and
	dep.referenced_owner=ref.owner
and
	dep.referenced_type=ref.object_type
order by 1,2,3;
