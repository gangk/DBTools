SELECT Substr(a.name,1,60) "Datafile",
       b.status "Status"
FROM   v$datafile a,
       v$backup b
WHERE  a.file# = b.file#;
