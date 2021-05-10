select i.instance_name
    ,p.table_owner
    ,p.table_name
    ,max(p.partition_name) as max_partition
from 
    v$instance i
    ,dba_tab_partitions p
    ,dba_part_key_columns k
    ,dba_tab_cols c
    ,dba_part_tables t    
-- joins
where k.owner = c.owner
and k.name = c.table_name
and k.column_name = c.column_name
and c.owner = p.table_owner
and c.table_name = p.table_name
and t.owner = p.table_owner
and t.table_name = p.table_name
--
-- filters
and (  c.data_type = 'DATE'
    or c.data_type like 'TIMESTAMP%'
    )
and (p.table_owner,p.table_name) not in
(   select rp.owner,rp.table_name
    from admin.db_rolling_partitions rp
)
and t.interval is null
and t.partitioning_type = 'RANGE'
and p.partition_name != 'MAXVALUE'
--
-- exclusions
and p.table_owner not in ('SYS','ADMIN')
and p.table_owner not like '%%_DBA'
and p.table_name not like '%%_OLD'
and p.table_name not like '%%_BACKUP'
and p.table_name not like '%%BAK'
and p.table_name not like '%%_DROPME'
--
and not REGEXP_LIKE (p.table_name,'*_O$')
and not REGEXP_LIKE (p.table_name,'*_OLD[0-9]$')
and not REGEXP_LIKE (p.table_name,'*_BACKUP[0-9]$')
and not REGEXP_LIKE (p.table_name,'*BAK[0-9]$')
and not REGEXP_LIKE (p.table_name,'*_BKP_*')
--
-- known old tables with max partition date > 1 year ago. Examples:
-- ICQA_COUNT_ATT_LOGS_20110430
-- SCORECARD_PERF_EVAL_20120630
and not REGEXP_LIKE (p.partition_name,'*_200[0-9][0-1][0-9][0-3][0-9]$') --2000-2009
and not REGEXP_LIKE (p.partition_name,'*_201[0-5][0-1][0-9][0-3][0-9]$') --2010-2015
--
-- known one-off exceptions
and p.table_name not like 'BIN$%%' -- DC: BIN$LILyYtoxWB/gU+3/hwocHw==$0 INVOICE_APPROVALS_20160221
-- 
group by i.instance_name,p.table_owner,p.table_name
order by i.instance_name,p.table_owner,p.table_name;
