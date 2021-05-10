alter session set nls_date_format = 'dd-mon-yyyy hh24:mi' ;

accept job_id prompt 'enter job_id :- '

col JOB format 999999 print
column interval format a25
column what format a55
col BROKEN format A1 heading "B"
column SCHEMA_USER format a10
set linesize 200
select JOB, LAST_DATE, NEXT_DATE, SCHEMA_USER, interval, WHAT, broken from dba_jobs 
where JOB = &JOB_ID ;
