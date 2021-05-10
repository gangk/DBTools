col MODULE format A30 trunc
col USERNAME format A20
set linesize 180
set pagesize 1000
set feedback 1
prompt
prompt ----- Module count, sorted by module. Press enter to continue...; ;
pause
select module,  count(*) from gv$session
group by module
order by upper(module) ;

prompt ----- Module count, sorted by count desc. Press enter to continue... ;
pause
select module,  count(*) from gv$session
group by module
order by  2 desc ;

prompt ----- Module count  by User --- ;
prompt Press enter to continute... ;
pause
col MODULE format A30 trunc
col USERNAME format A20
select USERNAME, module,  count(*) from gv$session 
group by USERNAME, module
order by username, upper(module) ;

