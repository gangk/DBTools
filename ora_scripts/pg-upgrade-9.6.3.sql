select distinct db_cluster_id,engine_ver, count(1) from fleet.AWS_RDS_DB_INSTANCE
where engine='aurora-postgresql'
--and db_cluster_role = 'writer'
and db_inst_id like 'fc%'
and (db_inst_id not like '%shadow%' and db_inst_id not like '%test%' and db_inst_id not like '%sea6%')
and acct_name not in ('FC DBA', 'ARUN', 'ITSDatabase-test')
and engine_ver='9.6.3'
group by db_cluster_id,engine_ver order by 1,2;


select distinct db_cluster_id,engine_ver, count(1) from fleet.AWS_RDS_DB_INSTANCE
where engine='aurora-postgresql'
--and db_cluster_role = 'writer'
and db_inst_id not like 'fc%'
and (db_inst_id not like '%shadow%' and db_inst_id not like '%test%' and db_inst_id not like '%sea6%')
and acct_name not in ('FC DBA', 'ARUN', 'ITSDatabase-test')
and engine_ver='9.6.3'
group by db_cluster_id,engine_ver order by 1,2;
