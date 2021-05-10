select  job,log_user,LAST_DATE,THIS_DATE,NEXT_DATE,BROKEN,FAILURES,WHAT from dba_jobs where BROKEN='Y';
