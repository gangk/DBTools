select 'T ' seg_type,
       t.owner sort1,
       t.table_name sort2,
       null sort3,
       t.table_name,
       to_char(t.last_analyzed,'yyyymmdd hh24mi') last_analyzed,
       t.num_rows,
       -- t.sample_size,
       decode(t.num_rows,
              null,to_number(null),
              0,100,
              round((t.sample_size*100)/t.num_rows,0)) sample_pct,
       null global_stats
  from dba_tables t
 where t.owner = upper('&tblown')
   and t.table_name like upper('&tblnm')
/