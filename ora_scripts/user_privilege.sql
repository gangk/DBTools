whenever sqlerror exit rollback
set arraysize 1
set space 1
set verify off
set pages 25
set lines 90
set termout on
clear screen
set feed off
set head off
set echo off
set serveroutput on size 1000000
col system_date noprint new_value val_system_date
select to_char(sysdate,'YYYYMMDD') system_date from sys.dual;

undefine user_to_find

prompt
accept user_to_find char prompt 'NAME OF USER TO CHECK : '

/* Creates a temporary view to get the list of ROLES recursivly for a user*/
create or replace view Privileges_Grant_user
(GRANTEE#,PRIVILEGE#,SEQUENCE#,LEV_EL) as
SELECT GRANTEE#,PRIVILEGE#,SEQUENCE#,LEVEL
from sys.sysauth$
connect by prior privilege# = grantee#
start with grantee# = (select USER# from sys.user$ where name = upper('&&user_to_find'));

/* list the roles Hierarchy */

spool C:\find_all_roles_privs_&val_system_date.log;

prompt *********************************************************
prompt List of roles Hierarchically Granted to &user_to_find
prompt *********************************************************
select lpad( ' ', 6 * ( lev_el - 1 ) ) || u2.name "Role Name"
from Privileges_Grant_user v ,
sys.user$ u2
where u2.user#=v.privilege#;
prompt
drop view Privileges_Grant_user;

declare
--
lv_tabs number:=0;

procedure write_op (pv_str in varchar2) is
begin
dbms_output.put_line(pv_str);
exception
when others then
dbms_output.put_line('ERROR (write_op) => '||sqlcode);
dbms_output.put_line('MSG (write_op) => '||sqlerrm);

end write_op;
--
procedure get_privs (pv_grantee in varchar2,lv_tabstop in out number) is
--
lv_tab varchar2(50):='';
lv_loop number;
--
cursor c_main (cp_grantee in varchar2) is
select 'ROLE' typ,
grantee grantee,
granted_role priv,
admin_option ad,
'--' tabnm,
'--' colnm,
'--' owner
from dba_role_privs
where grantee=cp_grantee and
GRANTED_ROLE NOT IN ('CONNECT','SELECT_CATALOG_ROLE','EXECUTE_CATALOG_ROLE',
'RESOURCE','DBA','IMP_FULL_DATABASE','EXP_FULL_DATABASE','AQ_ADMINISTRATOR_ROLE')
union
select 'SYSTEM' typ,
grantee grantee,
privilege priv,
admin_option ad,
'--' tabnm,
'--' colnm,
'--' owner
from dba_sys_privs
where grantee=cp_grantee
union
select 'TABLE' typ,
grantee grantee,
privilege priv,
grantable ad,
table_name tabnm,
'--' colnm,
owner owner
from dba_tab_privs
where grantee=cp_grantee
union
select 'COLUMN' typ,
grantee grantee,
privilege priv,
grantable ad,
table_name tabnm,
column_name colnm,
owner owner
from dba_col_privs
where grantee=cp_grantee
order by 1;
begin
lv_tabstop:=lv_tabstop+1;
for lv_loop in 1..lv_tabstop loop
lv_tab:=lv_tab||chr(9);
end loop;
for lv_main in c_main(pv_grantee) loop
if lv_main.typ='ROLE' then
write_op(lv_tab||'ROLE => '
||lv_main.priv||' which contains =>');
get_privs(lv_main.priv,lv_tabstop);
elsif lv_main.typ='SYSTEM' then
write_op(lv_tab||'SYS PRIV => '
||lv_main.priv
||' grantable => '||lv_main.ad);
elsif lv_main.typ='TABLE' then
write_op(lv_tab||'TABLE PRIV => '
||lv_main.priv
||' object => '
||lv_main.owner||'.'||lv_main.tabnm
||' grantable => '||lv_main.ad);
elsif lv_main.typ='COLUMN' then
write_op(lv_tab||'COL PRIV => '
||lv_main.priv
||' object => '||lv_main.tabnm
||' column_name => '
||lv_main.owner||'.'||lv_main.colnm
||' grantable => '||lv_main.ad);
end if;
end loop;
lv_tabstop:=lv_tabstop-1;
lv_tab:='';
exception
when others then
dbms_output.put_line('ERROR (get_privs) => '||sqlcode);
dbms_output.put_line('MSG (get_privs) => '||sqlerrm);
end get_privs;

begin
write_op('User => '||upper('&&user_to_find')||' has been granted the following
privileges');
write_op('*********************************************************');
get_privs(upper('&&user_to_find'),lv_tabs);
exception
when others then
dbms_output.put_line('ERROR (main) => '||sqlcode);
dbms_output.put_line('MSG (main) => '||sqlerrm);

end;
/
prompt
prompt ********************************************************
prompt End of the report
prompt ********************************************************
spool off
whenever sqlerror continue 
