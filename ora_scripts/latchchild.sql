- ********************************************************************
-- * Copyright Notice   : (c)2011 OraPub, Inc.
-- * Filename		: latchchild.sql 
-- * Author		: Craig A. Shallahamer
-- * Original		: 15-Nov-2011
-- * Last Update	: 15-Nov-2011
-- * Description	: Show which address is the most active for a given
-- *                      latch over a given period of time.
-- * Usage		: start latchchild.sql :latch# :sleep_seconds
-- ********************************************************************

def latch_in=&1
def sleep_in=&2

def osm_prog	= 'latchchild.sql'
def osm_title	= 'Latch Children Activity Report (latch#:&latch_in, delta:&sleep_in (sec))'

start osmtitle
set linesize 110

col delta_gets 	  heading "Gets"	  form     999,999,99,9990
col delta_sleeps  heading "Sleeps"	  form     999,999,99,9990
col addr 	  heading "Latch|Address" form     a10

drop table op_interim
/

create table op_interim as
select addr,gets,sleeps
from   v$latch_children
where  latch# = &latch_in
/

prompt Sleeping...
exec dbms_lock.sleep(&sleep_in);

select t1.addr,
       t1.gets-t0.gets delta_gets,
       t1.sleeps-t0.sleeps delta_sleeps
from   op_interim t0,
       (
         select addr,gets,sleeps
         from   v$latch_children
         where  latch# = &latch_in
       ) t1
where  t0.addr = t1.addr
order by 3,2
/

start osmclear