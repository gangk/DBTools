set serverout on size 1000000
set verify off


select decode(state, 0, 'Free', 
	1, decode(lrba_seq,0,'Available','Being Modified'), 
	2, 'Not Modified', 
	3, 'Being Read',
	'Other') "BLOCK STATUS"
	,count(*) cnt
from sys.x$bh
group by decode(state, 0, 'Free', 
	1, decode(lrba_seq,0,'Available','Being Modified'), 
	2, 'Not Modified', 
	3, 'Being Read',
	'Other') 
/

set verify on
