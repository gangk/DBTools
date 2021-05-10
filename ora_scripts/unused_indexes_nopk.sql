set lines 170
col in_cached_plan format a03
col tname       format a40      head 'Table Name'
col iname       format a50      head 'Index Name'
col mb          format 999999.9
col uniq	format a01	head 'U'	trunc

break on report on in_cached_plan on uniq on tname
compute sum of mb on uniq 
compute sum of mb on report 

WITH in_plan_objects AS
(
SELECT   DISTINCT object_name
FROM     v$sql_plan
WHERE    object_owner not in ('SYS','SYSTEM','ADMIN')
union
SELECT   DISTINCT object_name
FROM     dba_hist_sql_plan
WHERE    object_owner not in ('SYS','SYSTEM','ADMIN')
)
select
	 decode(object_name,null,'NO','YES') 	in_cached_plan
        ,i.table_owner||'.'||i.table_name 	tname
        ,sum(s.bytes)/(1024*1024)       	mb
	,decode(i.uniqueness,'UNIQUE','U',' ')  uniq
        ,decode(substr(index_name,1,3),'PK_','      '||i.owner||'.'||i.index_name,i.owner||'.'||i.index_name) iname
FROM     in_plan_objects, dba_indexes i, dba_segments s
where    i.index_name  	= object_name (+)
and      i.owner        = s.owner
and      i.index_name   = s.segment_name
and      i.table_owner 	not in ('SYS','SYSTEM','TSMSYS','ADMIN','OUTLN','PERFSTAT','DBSNMP','PRECISE')
and      object_name 	IS NULL
and      i.generated 	= 'N'
and      i.index_name 	not like 'PK_%'
group by object_name,i.table_owner,i.table_name, i.owner,i.index_name,i.uniqueness
order by in_cached_plan,uniq, i.table_owner||'.'||i.table_name,i.index_name;
