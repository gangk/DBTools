select pid, usename, substr(query,1,80), extract(epoch from now()) - extract(epoch from xact_start) as duration,state from pg_stat_activity where xact_start is not null order by 3 desc;
