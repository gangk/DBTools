BEGIN
  dbms_sqldiag.drop_sql_patch (
    name   => '&patch_name',
    ignore => TRUE);
END;
/
