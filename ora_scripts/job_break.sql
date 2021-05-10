accept job_id prompt 'enter job_id :- '
set serveroutput on
begin 
    sys.dbms_ijob.broken( job=> &job_id , broken=>TRUE); 
end;
/

prompt Press Enter to commit. <Ctrl-C> to rollback.
pause

commit ;

prompt Job : &job_id broken now. Run broken.sql to verify
prompt
