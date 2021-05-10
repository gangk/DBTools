select 'I ' seg_type,
       i.table_owner sort1,
       i.index_name sort2,
       to_char(null) sort3,
       i.index_name,
       to_char(i.last_analyzed,'yyyymmdd hh24mi') last_analyzed,
       num_rows,
       -- sample_size,
       decode(i.num_rows,
              null,to_number(null),
              0,100,
              round((i.sample_size*100)/i.num_rows,0)) sample_pct,
       distinct_keys,
       clustering_factor,
       decode(uniqueness,'UNIQUE','U','N')
       ||decode(index_type,
                'NORMAL',' ',
                'BITMAP','B',
                'CLUSTER','C',
                'DOMAIN','D',
                'FUNCTION-BASED NORMAL','F',
                'IOT - TOP','I',
                'LOB','L',
                '?')
       ||decode(compression,
                'ENABLED',substr(to_char(prefix_length,9),
                ' '),2,1) flags
  from dba_indexes i
 where i.table_owner = upper('&tblown')
   and i.table_name like upper('&tblnm')