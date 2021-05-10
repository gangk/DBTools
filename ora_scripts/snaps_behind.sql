col mview_owner form a20
col mview_name form a35
col master_link form a20

SELECT mv.owner as "mview_owner",
 mv.mview_name as "mview_name",
 mv.master_link as "master_link",
 1440*(sysdate - mv.last_refresh_date) as "Minutes Behind",  1440*int.interval as "refresh_interval"
 FROM dba_mviews mv,
 (
  SELECT child.owner,
  child.name,
  job.next_date - job.last_date as interval
  FROM dba_refresh ref,
  dba_refresh_children child,
  dba_jobs job
  WHERE ref.rname = child.rname
  AND ((upper(job.what) LIKE '%'||ref.rname||'''%')
       OR (upper(job.what) LIKE '%'||ref.rname||'"%'))
 ) int
 WHERE mv.owner = int.owner(+)
 AND mv.mview_name = int.name(+)
 AND mv.refresh_method = 'FAST'
And 1440*(sysdate - mv.last_refresh_date) > 20  ORDER BY (sysdate - mv.last_refresh_date) * 1440 DESC, mv.owner, mv.mview_name;

