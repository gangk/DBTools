BEGIN
  DBMS_SQLTUNE.alter_sql_profile (
    name            => '&profile',
    attribute_name  => 'STATUS',
    value           => '&status');
END;
/
