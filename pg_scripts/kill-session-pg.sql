select usename, application_name, state, count(1) from pg_stat_activity group by usename, application_name, state order by usename,state;

select pg_terminate_backend(pid) from pg_stat_activity where datname=current_database() and usename = '<username>';

select usename, application_name, state, count(1) from pg_stat_activity group by usename, application_name, state order by usename,state;
