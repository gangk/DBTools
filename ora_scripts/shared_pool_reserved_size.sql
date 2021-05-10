col free_space for 999,999,999,999 head "TOTAL FREE"
col avg_free_size for 999,999,999,999 head "AVERAGE|CHUNK SIZE"
col free_count for 999,999,999,999 head "COUNT"
col request_misses for 999,999,999,999 head "REQUEST|MISSES"
col request_failures for 999,999,999,999 head "REQUEST|FAILURES"
col max_free_size for 999,999,999,999 head "LARGEST CHUNK"

select free_space, avg_free_size, free_count, max_free_size, request_misses, request_failures from v$shared_pool_reserved; 

PROMPT The reserved pool is small when:- REQUEST_FAILURES > 0 (and increasing)
