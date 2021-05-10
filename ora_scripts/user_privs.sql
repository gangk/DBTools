SELECT LPAD(' ', 2*level) || granted_role "USER PRIVS"
FROM (
SELECT NULL grantee, username granted_role
FROM dba_users
WHERE username LIKE UPPER('%&uname%')
UNION
SELECT grantee, granted_role
FROM dba_role_privs
UNION
SELECT grantee, privilege
FROM dba_sys_privs)
START WITH grantee IS NULL
CONNECT BY grantee = prior granted_role;