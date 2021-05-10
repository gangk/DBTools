SELECT a.granted_role "Role",
       a.admin_option "Adm"
FROM   user_role_privs a;

SELECT a.privilege "Privilege",
       a.admin_option "Adm"
FROM   user_sys_privs a;
