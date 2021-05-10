set pages 50

PROMPT
PROMPT Tablespace Freespace Fragmentation Report
PROMPT

column "Blocks" format 99999999999999
column "Free" format 99999999999999
column "Pieces" format 99999
column "Biggest" format 99999999999999
column "Smallest" format 99999999999999
column "Average" format 99999999999999
column "Dead" format 9999
select substr(ts.tablespace_name,1,12) "Tspace",
       tf.blocks "Blocks",
       sum(f.blocks) "Free",
       count(*) "Pieces",
       max(f.blocks) "Biggest",
       min(f.blocks) "Smallest",
       round(avg(f.blocks)) "Average",
       sum(decode(sign(f.blocks-5),-1,f.blocks,0)) "Dead"
from   dba_free_space f,
       dba_data_files tf,
       dba_tablespaces ts
where  ts.tablespace_name=f.tablespace_name
and    ts.tablespace_name = tf.tablespace_name
group by ts.tablespace_name,tf.blocks
/
