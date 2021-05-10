accept hash_value prompt 'Enter Hash Value:- '
select sql_id,module from v$sql where hash_value=&hash_value and rownum < 2;
select sql_text from v$sql where  hash_value=&hash_value group by sql_text;
undef hash_value
