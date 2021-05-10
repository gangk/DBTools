select  schemaname,module,status,count(1) from v$session where module like '%w3wp%' group by schemaname,module,status
/
