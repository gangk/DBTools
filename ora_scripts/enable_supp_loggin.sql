select name,open_mode,database_role,SUPPLEMENTAL_LOG_DATA_MIN from v$database;

ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
