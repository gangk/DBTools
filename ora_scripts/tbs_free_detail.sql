rem Script Description: Reports the free space availability in a tablespace.
rem
rem Usage Information:  SQLPLUS SYS/pswd
rem                     @oralts.sql
rem
set pagesize 60;
set verify off;
set feedback off;

column a heading 'Tablespace' format a20;
column b heading 'Allocated Space |  in MBytes ' format 999,999,999,999,990;
column c heading 'Freespace| in MBytes ' format 999,999,999,999,990;
column d heading 'Percent| Used ' format 999.90;
column e heading 'Space Used' format 999,999,999,999,990;
column f heading 'Status' format a10;

ttitle 'Freespace in database '
compute sum label TOTAL of b c e on report

create or replace view space_free
as select x.tablespace_name,sum((x.bytes)/1024/1024) freespace,y.status
from sys.dba_free_space x
     ,sys.dba_tablespaces y
 where x.tablespace_name = y.tablespace_name
 group by x.tablespace_name, y.status;

create or replace view space_available
as select tablespace_name,sum((bytes)/1024/1024) availspace
from sys.dba_data_files group by tablespace_name;

select
       x.tablespace_name a
       ,100-(freespace/availspace*100) d
       ,availspace b
       ,availspace-freespace e
       ,freespace c
       ,status f
from
        space_free x
        ,space_available y
where
        x.tablespace_name=upper('&tbs_name')
        and
        y.tablespace_name = x.tablespace_name
       
order by
       100-(freespace/availspace*100)  desc
 ;

drop view space_free;
drop view space_available;
ttitle off