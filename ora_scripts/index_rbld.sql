select 
  s.name,s.del_lf_rows*100/decode(s.lf_rows, 0, 1, s.lf_rows) pct_deleted,
  (s.lf_rows-s.distinct_keys)*100/ decode(s.lf_rows,0,1,s.lf_rows)
  distinctiveness, i.blevel blevel
from 
  index_stats s,
  dba_indexes i
where 
  i.index_name =  '&index_name' and s.name='&&index_name';
