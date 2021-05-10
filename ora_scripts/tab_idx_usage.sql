--
-- This script is used primarily to help determine if unused indexes can be dropped
-- Given a table, list all indexes: when/whether they have been used in the last 30 days
--
undef towner
undef tname
@plusenv
col in_plan format a03
col tname       format a40      head 'Table Name'
col iname       format a50      head 'Index Name'
col uniq        format a01      head 'U'        trunc
col days_ago    format 999      head 'Days|Ago'
col execs       format 999,999,999 head 'Execs'
col last_ref    format a18      head 'Last Used'
col cf          format a06      head 'Cache ?'
col unf         format a09      head 'Unused ?'
col part        format a03      head 'Part'     trunc

break on tname on uniq on part on iname skip 1

WITH     in_plan as
(
SELECT   object_name, sql_id, max(timestamp) last_ref
FROM     dba_hist_sql_plan
WHERE    object_owner not in ('SYS','SYSTEM','ADMIN')
GROUP BY object_name, sql_id
having   max(timestamp) > sysdate-30
union
SELECT   object_name, sql_id, max(timestamp) last_ref
FROM     v$sql_plan
WHERE    object_owner not in ('SYS','SYSTEM','ADMIN')
GROUP BY object_name, sql_id
having   max(timestamp) > sysdate-30
)
        ,vsql as
(
SELECT   sql_id, sum(executions) execs, max(last_active_time) last_ref
FROM     v$sql
GROUP BY sql_id
having   max(last_active_time) > sysdate-30
)
        ,hsql as
(
SELECT   sql_id, sum(executions_delta) execs
FROM     dba_hist_sqlstat
GROUP BY sql_id
)
        ,tab_idx as
(
select   table_owner
        ,table_name
        ,owner          idx_owner
        ,index_name
        ,uniqueness
        ,partitioned
from     dba_indexes
where    table_owner    = upper('&&towner')
and      table_name     = upper('&&tname')
)
select   /*+ ordered */
         i.table_owner||'.'||i.table_name                       tname
        ,i.uniqueness                                           uniq
        ,i.partitioned                                          part
        ,i.idx_owner||'.'||index_name                           iname
        ,decode(p.sql_id,null,'<unused>','')                    unf
        ,decode(s.sql_id,null,p.sql_id,s.sql_id)                sql_id
        ,decode(s.sql_id,null,'No ','Yes')                      cf
        ,decode(s.execs,null,hs.execs,s.execs)                  execs
        ,sysdate - decode(s.last_ref,null,p.last_ref,s.last_ref) days_ago
        ,decode(s.last_ref,null,p.last_ref,s.last_ref)          last_ref
from     tab_idx        i
        ,in_plan        p
        ,vsql           s
        ,hsql           hs
where    i.index_name   = p.object_name (+)
and      p.sql_id       = s.sql_id (+)
and      p.sql_id       = hs.sql_id (+)
order by iname
        ,unf
        ,cf desc
        , execs desc
;

