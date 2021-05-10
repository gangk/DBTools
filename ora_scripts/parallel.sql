col sql_text for a40
col command for a10
col module for a20
col degree for 99
select distinct px.sid,px.serial#,px.qcsid,px.QCSERIAL#,px.degree,px.SERVER#,s.sql_id,DECODE(s.command, 0, 'None', 2, 'Insert', 3, 'Select', 6, 'Update', 7, 'Delete', 8, 'Drop',47,'PL/SQL', 189,'Merge',-67,'Merge',command||' Other ') command,substr(sq.sql_text,1,40) sql_text,substr(s.module,1,20) module  from v$px_session px,v$session s,v$sql sq where px.sid=s.sid and s.sql_id=sq.sql_id;
