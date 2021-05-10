set pagesize 2000
set linesize 230
set escape on
set serveroutput on
col machine format a40
col service_name format a40
col service format a40

prompt Total Sessions by Instance
select count(*) "Sessions",inst_id "Instance"
from gv$session
group by inst_id
order by inst_id;

prompt
prompt Total Sessions by Service
select service_name "Service",
       count(*) "Total Sessions",
       sum(decode(se.inst_id,1,1,0)) "Inst 1",
       sum(decode(se.inst_id,2,1,0)) "Inst 2",
       sum(decode(se.inst_id,3,1,0)) "Inst 3",
       sum(decode(se.inst_id,4,1,0)) "Inst 4"
from gv$session se
group by service_name
order by service_name;

prompt Total Sessions by Machine
select machine "Machine",
       count(*) "Total Sessions",
       sum(decode(se.inst_id,1,1,0)) "Inst 1",
       sum(decode(se.inst_id,2,1,0)) "Inst 2",
       sum(decode(se.inst_id,3,1,0)) "Inst 3",
       sum(decode(se.inst_id,4,1,0)) "Inst 4"
from gv$session se
group by machine
order by machine;
