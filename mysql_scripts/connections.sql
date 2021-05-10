select SUBSTRING_INDEX(host,':',1) ipaddr, command,count(*) from information_schema.processlist where state not like 'Master%'  group by  SUBSTRING_INDEX(host,':',1) order by count(*);
