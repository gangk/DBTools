/*
     This file is part of demos for "Mutex Internals" seminar v.22.04.2011
     Andrey S. Nikolaev (Andrey.Nikolaev@rdtex.ru) 
     http://andreynikolaev.wordpress.com 

     Top 10 heavily accessed library cache objects

     usage: @library_cache_objects_heavily_accessed.sql
*/
col name format a30
col cursor format a15 noprint
col type format a17
col LOCKED_TOTAL heading Locked format 9999999999999
col PINNED_TOTAL heading Pinned format 9999999999999
col EXECUTIONS heading Executed format 9999999999999
col NAMESPACE heading Nsp format 999
set wrap on
select * from (
   select case when (kglhdadr =  kglhdpar) then 'Parent' else 'Child '||kglobt09 end cursor,
             kglhdadr ADDRESS,substr(kglnaobj,1,20) name, kglnahsh hash_value,kglobtyd type,kglobt23 LOCKED_TOTAL,kglobt24 PINNED_TOTAL,kglhdexc EXECUTIONS,kglhdnsp NAMESPACE 
               from x$kglob  
               order by kglobt24 desc)
where rownum <= 10;
