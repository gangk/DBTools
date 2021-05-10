select 
   count(*)
  ,min(calls)
  ,percentile_cont(0.1) within group (order by calls) p10
  ,percentile_cont(0.2) within group (order by calls) p20
  ,percentile_cont(0.3) within group (order by calls) p30
  ,percentile_cont(0.4) within group (order by calls) p40
  ,percentile_cont(0.5) within group (order by calls) p50
  ,percentile_cont(0.6) within group (order by calls) p60
  ,percentile_cont(0.7) within group (order by calls) p70
  ,percentile_cont(0.8) within group (order by calls) p80
  ,percentile_cont(0.9) within group (order by calls) p90
  ,percentile_cont(0.99) within group (order by calls) p99
  ,percentile_cont(0.999) within group (order by calls) p999
  ,max(calls)
  ,avg(calls)
from pg_stat_statements;

select bucket, count(*) entries, max(calls) max_calls, round(sum(total_time)) total_time, round((100*sum(total_time)/avg(total_total_time))::numeric,2) pct_time from (select ntile(20) over (order by calls) bucket, calls, total_time, sum(total_time) over () total_total_time from pg_stat_statements) stmts group by rollup(bucket) order by bucket;

select bucket, count(*) entries, max(calls) max_calls, round(sum(total_time)) total_time, round((100*sum(total_time)/avg(total_total_time))::numeric,2) pct_time, round(sum(rows)) "rows", round((100*sum(rows)/avg(total_rows))::numeric,2) pct_rows from (select ntile(20) over (order by calls) bucket, calls, total_time, sum(total_time) over () total_total_time, rows, sum(rows) over () total_rows from pg_stat_statements) stmts group by rollup(bucket) order by bucket;
