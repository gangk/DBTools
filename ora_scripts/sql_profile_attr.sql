SELECT attr_value
 FROM dba_sql_profiles p JOIN dbmshsxp_sql_profile_attr 
 ON (a.profile_name = p.NAME)
 WHERE p.NAME = '&profile_name';