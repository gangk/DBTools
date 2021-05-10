On primary 
select 'Instance'||thread#||': Last Applied='||max(sequence#)||' (resetlogs_change#='||resetlogs_change#||')' from v$archived_log where applied = (select decode(database_role, 'PRIMARY', 'NO', 'YES') from v$database) and thread# in (select thread# from gv$instance) and resetlogs_change# = (select resetlogs_change# from v$database) group by thread#, resetlogs_change# order by thread#;


On standby

select 'Instance'||thread#||': Last Applied='||max(sequence#)||' (resetlogs_change#='||resetlogs_change#||')' from v$archived_log where applied = (select decode(database_role, 'PRIMARY', 'NO', 'YES') from v$database) and thread# in (select thread# from gv$instance) and resetlogs_change# = (select resetlogs_change# from v$database) group by thread#, resetlogs_change# order by thread#;