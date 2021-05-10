undef owner
undef table_name
exec dbms_stats.delete_table_stats( -
	ownname=>'&&owner',-
  	tabname=>'&&table_name', -
	cascade_indexes=>true);

exec dbms_stats.gather_table_stats( -
	ownname=>	'&&owner', -
   	tabname=>	'&&table_name',-
   	estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,-
   	cascade=>	 true,-
	degree=>	 3, -
   	method_opt=>	'for all columns size AUTO'); 
--
-- (if col stats not beneficial use method_opt below
--   	method_opt=>	'for all columns size    1'); 
--
