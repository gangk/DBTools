SELECT 
	u.username,u.account_status,p.privilege
from
	dba_users u,dba_sys_privs p
where
	(u.username in
		(
			select username from dba_users where account_status='OPEN' minus select database_username from admin.spda_cred_mgr_actions
		)
	or
	u.username in 
		(
			select distinct owner from dba_tab_privs where grantee='PUBLIC' intersect select distinct owner from dba_procedures where authid='DEFINER' and object_type<>'TRIGGER'
		)
	)
and
	u.username not in 
	('SYS','MGDSYS','ORACLE_OCM','OUTLN','SYSTEM','DBSNMP','CSMIG','ADMIN')
and
	p.privilege in
	( 'EXECUTE ANY PROCEDURE', 'CREATE ANY TRIGGER', 'SELECT ANY TABLE', 'CREATE TRIGGER', 'ALTER ANY TRIGGER', 'DROP ANY TRIGGER', 'EXEMPT ACCESS POLICY', 'ADMINISTER DATABASE TRIGGER ', 'CREATE PROCEDURE', 'CREATE ANY PROCEDURE', 'ALTER ANY PROCEDURE', 'CREATE JOB', 'CREATE ANY JOB', 'CREATE DATABASE LINK', 'CREATE PUBLIC DATABASE LINK', 'ALTER SYSTEM', 'RESTRICTED SESSION', 'BECOME USER', 'GRANT ANY OBJECT', 'SELECT ANY DICTIONARY', 'DELETE ANY TABLE', 'UPDATE ANY TABLE', 'INSERT ANY TABLE' ) 
and
	p.grantee=u.username order by 2,1;
