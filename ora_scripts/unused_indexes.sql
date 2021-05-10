@plusenv
col tname       format a42      head 'Table Name'
col iname       format a60      head 'Index Name'
col mb          format 9,999,999.9
col uniq	format a01	head 'U'	trunc

break on report on uniq on tname
compute sum of mb on uniq
compute sum of mb on report

WITH 	 in_plan as
(
SELECT   DISTINCT object_owner, object_name
FROM     v$sql_plan
WHERE    object_owner not in ('SYS','SYSTEM','ADMIN')
union
SELECT   DISTINCT object_owner, object_name
FROM     dba_hist_sql_plan
WHERE    object_owner not in ('SYS','SYSTEM','ADMIN')
)
select   i.table_owner||'.'||i.table_name 	tname
        ,sum(s.bytes)/(1024*1024)       	mb
	,decode(i.uniqueness,'UNIQUE','Y','N')  uniq
        ,decode(substr(index_name,1,3),'PK_','      '||i.owner||'.'||i.index_name,i.owner||'.'||i.index_name) iname
FROM     in_plan	p
	,dba_indexes 	i
	,dba_segments 	s
where    i.index_name  	= p.object_name (+)
and	 i.owner	= p.object_owner (+)
and      i.owner        = s.owner
and      i.index_name   = s.segment_name
and      i.table_owner 	not in ('SYS','SYSTEM','TSMSYS','ADMIN','OUTLN','PERFSTAT','DBSNMP','PRECISE')
and      p.object_name 	IS NULL
and      i.generated 	= 'N'
group by object_name
	,i.table_owner
	,i.table_name
	,i.owner
	,i.index_name
	,i.uniqueness
order by uniq
	,i.table_owner||'.'||i.table_name
	,i.index_name
;
