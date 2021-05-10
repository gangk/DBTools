set linesize 500 pagesize 0 feedback off trimspool on

SELECT
  '/* '||to_char(CEIL((f.blocks-e.hwm)*(f.bytes/f.blocks)/1024/1024),99999999)||' M */ ' ||
  'alter database datafile '''||file_name||''' resize '||CEIL(e.hwm*(f.bytes/f.blocks)/1024/1024)||'M;' SQL
FROM
  DBA_DATA_FILES f,
  SYS.TS$ t,
  (SELECT ktfbuefno relative_fno,ktfbuesegtsn ts#,
  MAX(ktfbuebno+ktfbueblks) hwm FROM sys.x$ktfbue GROUP BY ktfbuefno,ktfbuesegtsn) e
WHERE
  f.relative_fno=e.relative_fno and t.name=f.tablespace_name and t.ts#=e.ts#
  and f.blocks-e.hwm > 1000
ORDER BY f.blocks-e.hwm DESC
/

