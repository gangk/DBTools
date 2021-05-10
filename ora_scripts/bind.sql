col VALUE_ANYDATA noprint
col NAME format A20
col POSITION format 99 heading "Pos"
col DUP_POSITION noprint
col CHILD_NUMBER format 99 heading "Child" print
col CHILD_ADDRESS noprint
col ADDRESS noprint
col HASH_VALUE noprint
col VALUE_STRING format A30
col VAL format A40 word_wrap
col DATATYPE_STRING format A20
col PRECISION noprint
col SCALE noprint
col DATATYPE noprint

accept sql_id prompt 'enter sql_id :- '

break on child_number skip 1 duplicate

select name,child_number, position, datatype_string, was_captured, value_string, 
anydata.accesstimestamp(value_anydata) val from v$sql_bind_capture where sql_id ='&sql_id' 
order by child_number, position ;

clear breaks

