undef tabowner
undef tabname
exec dbms_stats.gather_table_stats('&&tabowner','&&tabname', degree=>dbms_stats.auto_degree, no_invalidate=>false);
