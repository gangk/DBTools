set lin 200

select distinct module,username,machine from db_logons where module like '&mod_like%' and logon_time > sysdate - &days order by 2;
