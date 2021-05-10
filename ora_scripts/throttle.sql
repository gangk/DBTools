set lines 500
accept mytab prompt 'ENTER TABLE NAME  : '
set serveroutput on

declare
/* Declare Variables */
input                 THROTTLE_SNAP_CONFIG.SOURCE_TABLE%type;
output                THROTTLE_SNAP_CONFIG.TARGET_TABLE%type;
master                DBA_SNAPSHOTS.MASTER%type;
master_link           DBA_SNAPSHOTS.MASTER_LINK%type;
last_refresh          DBA_SNAPSHOTS.last_refresh%type;
owner                 THROTTLE_SNAP_CONFIG.SOURCE_OWNER%type;
log                   DBA_SNAPSHOT_LOGS.LOG_TABLE%type;
counter               number;
mlog_count            number;
delay_rows            number;
input_type            dba_objects.object_type%type;
output_type           dba_objects.object_type%type;
type type_name is table of DBA_REGISTERED_SNAPSHOTS.NAME%TYPE;
type type_site is table of DBA_REGISTERED_SNAPSHOTS.snapshot_site%TYPE;
type type_refresh is table of DBA_SNAPSHOT_LOGS.CURRENT_SNAPSHOTS%type;
type type_delay is table of number;
name                  type_name;
site                  type_site;
refresh               type_refresh;
delay                 type_delay;
begin

select count(*) into counter from THROTTLE_SNAP_CONFIG where SOURCE_TABLE='&mytab' or  TARGET_TABLE='&mytab';

if counter=0
then
	select SOURCE_TABLE,TARGET_TABLE into input,output from THROTTLE_SNAP_CONFIG where SOURCE_TABLE like '%&mytab%' or  TARGET_TABLE like '%&mytab%';
else
	select SOURCE_TABLE,TARGET_TABLE into input,output from THROTTLE_SNAP_CONFIG where SOURCE_TABLE='&mytab' or  TARGET_TABLE='&mytab';
end if;

select MASTER,MASTER_LINK,LAST_REFRESH into master,master_link,last_refresh from dba_snapshots where name=input;

select distinct LOG_TABLE into log FROM DBA_SNAPSHOT_LOGS WHERE master=output;

select r.name, r.snapshot_site, l.current_snapshots,(sysdate-l.current_snapshots)*1441 bulk collect into name,site,refresh,delay
from dba_registered_snapshots r, dba_snapshot_logs l where r.snapshot_id = l.snapshot_id and l.master=output;

execute immediate 'select count(*) from booker.'||log into mlog_count;
execute immediate 'select count(*) from booker.'||input  ||' WHERE last_row_update > (SELECT next_synch_window_start_time FROM throttle_snap_config  WHERE source_table = :1)' into delay_rows using input;

select OBJECT_TYPE into input_type from (select object_type from dba_objects where object_name=input AND OBJECT_TYPE<>'SYNONYM'  order by 1 ASC) WHERE ROWNUM <2;
select OBJECT_TYPE into output_type  from (select object_type from dba_objects where object_name=output AND OBJECT_TYPE<>'SYNONYM'  order by 1 ASC) WHERE ROWNUM <2;

dbms_output.put_line(chr(9));
dbms_output.put_line('======= MASTER DETAIL FOR THIS TABLE =======');
dbms_output.put_line(chr(9));
dbms_output.put_line(rpad('INPUT TABLE',30)||chr(9)||rpad('OUTPUT TABLE',30)||CHR(9)||rpad('MASTER',30)||CHR(9)||rpad('LINK',20)||chr(9)||rpad('LAST_REFRESH',20)||CHR(9)||rpad('LOG',30));
dbms_output.put_line(rpad(input,30)||CHR(9)||rpad(output,30)||CHR(9)||rpad(master,30)||CHR(9)||rpad(master_link,20)||chr(9)||rpad(last_refresh,20)||CHR(9)||rpad(log,30));

dbms_output.put_line(chr(9));
dbms_output.put_line('MLOG COUNT'||chr(9)||chr(9)||'PENDING_ROWS');
dbms_output.put_line(mlog_count|| chr(9)||chr(9)||delay_rows);
dbms_output.put_line(chr(9));
dbms_output.put_line(input||'--->'||input_type);
dbms_output.put_line(output||'--->'||output_type);

dbms_output.put_line(chr(9));
dbms_output.put_line('======= SITES REFRESHING FROM '||output||' =======');
dbms_output.put_line(CHR(9));

dbms_output.put_line('NAME'||CHR(9)||CHR(9)||chr(9)||'SITE'||CHR(9)||CHR(9)||chr(9)||'REFRESH'||CHR(9)||CHR(9)||chr(9)||'DELAY ( in min )');
for i in name.first..name.last
loop
	dbms_output.put_line(name(i)||chr(9)||site(i)||chr(9)||refresh(i)||chr(9)||delay(i));
end loop;
end;
/

undef mytab
