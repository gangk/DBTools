accept SQL_ID prompt 'Enter hinted SQL ID:- '
accept plan_hash_value prompt 'Enter good plan_hash_value:- '
accept sql_handle prompt 'Enter bad SQL_HANDLE to link to:- '
var ret number
exec :ret := dbms_spm.load_plans_from_cursor_cache(-
    sql_id=>'&SQL_ID', -
    plan_hash_value=>&plan_hash_value,-
    sql_handle=>'&sql_handle',-
    fixed=>'NO');

