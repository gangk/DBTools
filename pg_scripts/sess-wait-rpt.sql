select distinct usename,count(1) from pg_stat_activity group by usename order by 2;
select distinct usename,application_name,count(1) from pg_stat_activity group by usename,application_name order by 3;
select distinct usename,application_name,state,count(1) from pg_stat_activity group by usename,application_name,state order by 4;
select distinct usename,application_name,state,wait_event,count(1) from pg_stat_activity group by usename,application_name,state,wait_event order by 5;

select distinct state,wait_event,count(1) from pg_stat_activity group by state,wait_event order by 3;
select distinct wait_event,count(1) from pg_stat_activity group by wait_event order by 2;
select distinct wait_event_type,wait_event,count(1) from pg_stat_activity group by wait_event_type,wait_event order by 3;
