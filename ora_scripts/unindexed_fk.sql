@plusenv

col pktab	format a40	heading 'PK|Table Name' 
col pkcons	format a30	heading 'PK|Const Name'
col fktab	format a40	heading 'FK|Table Name'		
col fkcons	format a30	heading 'FK|Const Name'
col fkcol	format a30	heading 'FK|Column Name'
col cpos	format 9	head	'P'
col pkcol 	format a30	heading 'PK|Col Name'

break on pktab on pkcons on fktab on fkcons

SELECT 	 
	 pk.owner||'.'||pk.table_name		pktab
	--,pk.constraint_name	pkcons
	,fk.owner||'.'||fk.table_name		fktab
	,fk.constraint_name	fkcons
	,cc.position		cpos
	,cc.column_name		fkcol
FROM     dba_constraints 	pk
	,dba_constraints 	fk
	,dba_cons_columns 	cc
WHERE    fk.constraint_type	= 'R'
  AND    pk.constraint_type 	= 'P'
  AND    fk.r_owner		= pk.owner
  AND    fk.r_constraint_name	= pk.constraint_name
  AND    fk.constraint_name	= cc.constraint_name
  AND    fk.owner		= cc.owner
  AND    fk.table_name		= cc.table_name
  AND	 pk.owner		not in ('SYS','SYSTEM')
--and	 pk.owner		= 'LE101'
  AND	(fk.owner,fk.table_name,cc.column_name,cc.position) not in
	(select table_owner,table_name,column_name, column_position
	 from dba_ind_columns ic
	 where ic.table_owner	= fk.owner
	 and ic.table_name	= fk.table_name
	 and ic.column_name	= cc.column_name
	 and ic.column_position	= cc.position)
ORDER BY pk.owner||'.'||pk.table_name
	,fk.owner||'.'||fk.table_name
	,fk.constraint_name
	,cc.position
;
