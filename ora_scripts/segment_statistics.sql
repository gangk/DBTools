With pivot_stats as (
select owner,object_name,statistic_name,value from v$segment_statistics 
)
select * from pivot_stats
PIVOT
(sum(value) for statistic_name in ('logical reads', 'physical writes' ,'row lock waits' ));