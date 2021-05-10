@plusenv
col segname	format a45		trunc
select	 seg.owner||'.'||segment_name			segname
	,ts.blocks                                     blks_used
      	,ts.avg_space			
      	,ts.num_rows
      	,ts.avg_row_len
      	,ts.empty_blocks                               empty_blks
      	,seg.blocks                                    alloc_blks
      	,greatest(ts.blocks,1)/greatest(seg.blocks,1) pct_hwm
      	,ts.num_rows*ts.avg_row_len                   data_in_bytes
      	,(ts.num_rows*ts.avg_row_len)/bs.blksize            data_in_blks
      	,((ts.num_rows*ts.avg_row_len)/bs.blksize)*1.25     mod_data_in_blks
      	,(((ts.num_rows*ts.avg_row_len)/bs.blksize)*1.25)/seg.blocks pct_spc_used
from 	 dba_tab_statistics ts
    	,dba_segments       seg
	,(SELECT value blksize   from v$parameter where name='db_block_size') bs
where 	 ts.table_name=seg.segment_name
and	 ts.empty_blocks*bs.blksize/(1024*1024)	>5
and	 (((ts.num_rows*ts.avg_row_len)/bs.blksize)*1.25)/seg.blocks < 80
/
