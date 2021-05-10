column name format a70

select name from v$datafile
union
select member from v$logfile
union
select name from v$controlfile
union
select name from v$tempfile
/
