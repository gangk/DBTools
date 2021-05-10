REM ------------------------------------------------------------------------------------------------
REM $Id: tab-priv.sql,v 1.1 2002/03/14 00:43:52 hien Exp $
REM Author     : hien
REM #DESC      : Show all table privileges that have been granted to a schema
REM Usage      : Input parameter: tab_owner
REM Description: Given a schema, show all table privileges that have been granted on tables in the
REM              schema
REM ------------------------------------------------------------------------------------------------

@plusenv
undef tab_owner

col tname	format a42
col who		format a30	head 'Grantor -> Grantee'
col priv	format a15	trunc
col grnt	format a03	
break on tname
SELECT	 
	 owner||'.'||table_name		tname
	,grantor||'->'||grantee		who
	,privilege			priv
	,grantable			grnt
FROM	 
	 dba_tab_privs			
WHERE	 owner 			= upper('&&tab_owner')
ORDER BY owner
	,table_name
	,privilege
;
undef tab_owner
