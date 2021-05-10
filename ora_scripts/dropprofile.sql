BEGIN
  DBMS_SQLTUNE.drop_sql_profile (
    name   => '&profile',
    ignore => TRUE);
END;
/
