SET VERIFY OFF

SPOOL  C:\Search_Source.txt

SELECT a.name "Name",
       a.line "Line",
       Substr(a.text,1,200) "Text"
FROM   all_source a
WHERE  Instr(Upper(a.text),Upper('&&1')) != 0
AND    a.owner = Upper('&&2')
ORDER BY 1,2;

SPOOL OFF
