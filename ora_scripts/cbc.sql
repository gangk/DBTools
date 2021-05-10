set lines 500
col event for a40
col p1p2p3 for a30
col STATE for a10
set feedback on
col object_name for a30
col owner for a20
select sid,serial#,module,sql_id,p1raw||' -'||p2||'-'||p3 p1p2p3,event  from  v$session where event  like '%cache%buffer%';
accept mysql prompt'enter sql_id:- ' 
accept myaddress prompt'enter p1:- '
select addr, latch#, child#, level#, gets from v$latch_children where addr='&&myaddress';

prompt '=======DUMPING FIRST TIME====='
select * from (select hladdr,  file#, dbablk, decode(state,0,'Free',1,'cur ',3,'CR',state) STATE, tch,obj from x$bh where hladdr ='&&myaddress' order by tch desc) where rownum <21;
prompt '=======DUMPING SECOND TIME====='
select * from (select hladdr,  file#, dbablk, decode(state,0,'Free',1,'cur ',3,'CR',state) STATE, tch,obj from x$bh where hladdr ='&&myaddress' order by tch desc) where rownum <21;
prompt '=======DUMPING THIRD TIME====='
select * from (select hladdr,  file#, dbablk, decode(state,0,'Free',1,'cur ',3,'CR',state) STATE, tch,obj from x$bh where hladdr ='&&myaddress' order by tch desc) where rownum <21;

accept mytch prompt 'enter Minimum TCH TO CHECK FROM:- '
select object_name,object_id,owner,data_object_id,tch,file#,dbablk from dba_objects,x$bh where data_object_id =obj and hladdr ='&&myaddress' and tch>=&&mytch order by tch desc;
--accept myobj prompt'enter object value :-'

SELECT * FROM TABLE(dbms_xplan.display_cursor('&mysql'));
undef mysql
undef myaddress
undef myobj
undef mytch
