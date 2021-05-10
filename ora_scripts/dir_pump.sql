
COL grantee FORMAT a20
COL privilege FORMAT a10
SELECT directory_name, grantee, privilege
  FROM user_tab_privs t, all_directories d  
 WHERE t.table_name(+)=d.directory_name  
 ORDER BY 1,2,3;
