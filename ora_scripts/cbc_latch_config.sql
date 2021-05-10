@plusenv
COLUMN parameter           FORMAT a50
COLUMN description         FORMAT a75 WORD_WRAPPED
COLUMN "Session VALUE"     FORMAT a20
COLUMN "Instance VALUE"    FORMAT a20

SELECT
   a.ksppinm  "Parameter",
   c.ksppstvl "Instance Value",
   a.ksppdesc "Description"
FROM
   x$ksppi a,
   x$ksppsv c
WHERE
   a.indx = c.indx
and a.ksppinm in
	('db_block_buffers'
	,'_db_block_buffers'
	,'db_block_size'
	,'_db_block_hash_buckets'
	,'_db_block_hash_latches'
	,'_db_block_lru_latches'
	,'_db_block_max_cr_dba')
order by 1
;
