set termout off
column value new_value BlkSz

select value
from sys.v_$parameter
where name = 'db_block_size'
/

set termout on
set verify off

select &BlkSz * (1 + 2 * sum(ceil(record_size * records_total / (&BlkSz - 24)))) bytes
from sys.v_$controlfile_record_section
/
