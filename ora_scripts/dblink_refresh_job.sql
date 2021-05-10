SELECT DISTINCT mv.master_link
  FROM dba_rgroup rg, dba_refresh_children rc, dba_mviews mv
 WHERE rg.job = &job_no
   AND rc.rowner = rg.owner
   AND rc.rname = rg.name
   AND rc.type = 'SNAPSHOT'
   AND mv.mview_name = rc.name
   AND mv.owner = rc.owner;