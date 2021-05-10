accept module_like prompt 'enter Module like :- '
col MODULE format A40 trunc
col USERNAME format A20
set linesize 180
set pagesize 1000
set feedback 1
select module,  count(*) from gv$session
where upper(module) like upper('%&module_like%')
group by module
order by 1 ;

select USERNAME, module, min(LOGON_TIME), max(LOGON_TIME), count(*) from gv$session 
where upper(module) like upper('%&module_like%')
group by USERNAME, module
order by 1, 2 ;

select sysdate from dual ;

