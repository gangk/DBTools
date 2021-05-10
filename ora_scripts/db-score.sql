set lines 222
col DB_NAME for a8
col TAB_CNT_COST for a14
col MV_CNT_COST for a14
col DLINK_CNT_CST for a14
col PRC_CNT_CST for a14
col FUNC_CNT_CST for a14
col PKG_CNT_CST for a14
col TRG_CNT_CST for a14
col TB_PART_CNT_CST for a14
col LOB_CNT_CST for a14
col HASH_PART for a10
col max_redo_hr for 9,999.99
select (select name from v$database) as DB_NAME, A.tab_count||':'||round(0.5*(A.tab_count)) as TAB_CNT_COST,A.mview_count || ':'|| round(3*(A.mview_count)) as MV_CNT_COST,A.db_links_count||':'||round(1*(A.db_links_count)) as DLINK_CNT_CST,A.proc_count||':'||(4*A.proc_count) as PRC_CNT_CST,A.func_count||':'||(4*A.func_count) as FUNC_CNT_CST,A.package_count||':'||(15*A.package_count) as PKG_CNT_CST,A.trig_count||':'||(3*A.trig_count) as TRG_CNT_CST,A.tab_part_count||':'||round(0.1*(A.tab_part_count+A.ind_part_count+nvl(A.tab_sub_part_cnt,0)+nvl(A.ind_sub_part_cnt,0))) as TB_PART_CNT_CST,lobs_count||':'||(1*A.lobs_count) as LOB_CNT_CST,A.hash_part as HASH_PART,(select max(round(sum(BLOCKS*BLOCK_SIZE/1024/1024/1024),2)) from   v$archived_log where  trunc(first_time) >= trunc(sysdate - 1) group by trunc(first_time,'HH24')) as max_redo_hr,
round(
(0.5*(A.tab_count))
+(3*(A.mview_count))
+(1*(A.db_links_count))
+(3*A.trig_count)
+(4*A.proc_count)
+(4*A.func_count)
+(15*A.package_count)
+(0.1*(A.tab_part_count+A.ind_part_count+nvl(A.tab_sub_part_cnt,0)+nvl(A.ind_sub_part_cnt,0)))
+(1*A.lobs_count)
----+(decode(A.hash_part,'YES',15,'NO',0))
----+(decode(A.bmap_index,'YES',15,'NO',0))
----+(decode(A.local_index,'YES',15,'NO',0))
----+(decode(A.roll_part,'YES',10,'NO',0))
----+(select decode(DBLNK,'YES',2,'NO',0) from (select case when (cnt > 0) then 'YES' else 'NO' end dblnk from (select count(1) cnt from dba_db_links)))
) tot_weightage
from
(
select (select count(1) from dba_tables where OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')) tab_count,
(select count(1)  from dba_mviews ) mview_count,
----(select count(site.SNAPSHOT_SITE) "Mviews_Source_For" from dba_registered_snapshots site,dba_snapshot_logs logs where site.snapshot_id=logs.snapshot_id) mv_source,
(select count(1) from dba_db_links) db_links_count,
(select count(1) from dba_objects where object_type='PROCEDURE' and OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','STDBYPERF','PERFSTAT','ADMIN')) proc_count,
(select count(1) from dba_objects where object_type in ('FUNCTION') and OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')) func_count,
(select count(1) from dba_objects where object_type in ('PACKAGE BODY') and OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')) package_count,
(select count(1) from dba_triggers where OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','STDBYPERF','PERFSTAT','ADMIN')) trig_count,
(select count(1) from dba_tab_partitions where table_OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')) tab_part_count,
(select count(1) from dba_ind_partitions where index_OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')) ind_part_count,
(select nvl(sum(SUBPARTITION_COUNT),0) from dba_tab_partitions where table_OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')) tab_sub_part_cnt,
(select nvl(sum(SUBPARTITION_COUNT),0) from dba_ind_partitions where index_OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')) ind_sub_part_cnt,
(select count(1) from dba_lobs where OWNER not in ('OUTLN','SYSTEM','SYS','ADMIN') and OWNER not like '%DBA%') lobs_count,
(select case when (cnt > 0) then 'YES' else 'NO' end hash_part from
(select count(1) cnt from (select distinct PARTITIONING_TYPE from dba_part_tables where PARTITIONING_TYPE like '%HASH%' and OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')
union
select distinct PARTITIONING_TYPE from dba_part_indexes where PARTITIONING_TYPE like '%HASH%' and OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN')
))) hash_part
----(select decode(count(1), 1, 'YES', 0, 'NO','YES') from (select distinct LOCALITY from dba_part_indexes where LOCALITY='LOCAL' and OWNER not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN'))) local_index,
----(select decode(count(1), 1, 'YES', 0, 'NO','YES') from (select distinct index_type from dba_indexes where INDEX_TYPE='BITMAP'and owner not in ('SYS','SYSTEM','REPADMIN','OUTLN','MGDSYS','DBSNMP','ADMIN'))) bmap_index,
----(select decode(count(1), 1, 'YES', 0, 'NO','YES') from (select what from dba_jobs where upper(what) like '%ROLLING_PARTITION%')) roll_part
from dual
) A
;
