/* Script to generate grants in a database */
clear col
break on connect_string skip 1
COL TEXT FOR A200 WORD_WRAP
set verify off
set feedback off
set termout off
set heading off
set pagesize 0
set linesize 150
set echo off
drop table g_temp
/
set termout on
clear scr
prompt For user_list, enter list of users to print grants for, in quotes, 
sep. by commas
prompt e.g. 'HR_DATA','HR_WORK','UTILITY'
select 'List of users to print grants for: ' || &&user_list from dual;
set termout off
spool C:\grant_list.txt
/* System privileges */
select '-- System privileges' from dual
/
select 'connect sys@FEED_27' connect_string,
chr(10) || 'GRANT ' || privilege || ' to ' || grantee || 
decode(admin_option,'YES',' with
admin option',null) || ';' text
from dba_sys_privs
where grantee in (&user_list) order by 1
/
/* Role privileges */
select '-- Role privileges' from dual
/
select 'connect sys@FEED_27'||chr(10) connect_string, 
chr(10) || 'grant ' || granted_role || ' to ' || grantee || 
decode(admin_option,'YES',' with 

admin option',null) || ';' text
from dba_role_privs
where grantee in (&user_list) order by 1

/* Object privileges */
/* This part of the script is modified from tfscsopv.sql, an Oracle TFTS 
script */
select '-- Object privileges' from dual
/
set termout off
set echo off
set verify off
set feedback off
set pagesize 0
set heading off
set recsep off
create table g_temp (seq NUMBER, grantor_owner varchar2(20),
                    text VARCHAR2(800))
/
DECLARE
   cursor grant_cursor is 
    SELECT ur$.name, uo$.name, o$.name, ue$.name,
              m$.name, t$.sequence#, 
              decode(NVL(t$.option$,0), 1, ' WITH GRANT OPTION;',';')
     FROM sys.objauth$ t$, sys.obj$ o$, sys.user$ ur$,
            sys.table_privilege_map m$, sys.user$ ue$, sys.user$ uo$
       WHERE o$.obj# = t$.obj# AND t$.privilege# = m$.privilege AND
             t$.col# IS NULL AND t$.grantor# = ur$.user# AND
             t$.grantee# = ue$.user# and 
             o$.owner#=uo$.user# and 
             t$.grantor# != 0 
		and (ue$.name in (&user_list) or ur$.name in (&user_list))
       order by sequence#;
   lv_grantor    sys.user$.name%TYPE;
   lv_owner      sys.user$.name%TYPE;
   lv_table_name sys.obj$.name%TYPE;
   lv_grantee    sys.user$.name%TYPE;
   lv_privilege  sys.table_privilege_map.name%TYPE;
   lv_sequence   sys.objauth$.sequence#%TYPE;
   lv_option     VARCHAR2(30);
   lv_string     VARCHAR2(800);
   lv_first      BOOLEAN;
 
   procedure write_out(p_seq INTEGER, p_owner VARCHAR2, p_string VARCHAR2) 
is
   begin
      insert into g_temp (seq, grantor_owner,text)
 values (lv_sequence, lv_grantor, lv_string);
   end;
 
BEGIN
  OPEN grant_cursor;
    LOOP
      FETCH grant_cursor INTO 
lv_grantor,lv_owner,lv_table_name,lv_grantee,
         lv_privilege,lv_sequence,lv_option;
      EXIT WHEN grant_cursor%NOTFOUND;
      lv_string := 'GRANT ' || lv_privilege || ' ON ' || lower(lv_owner) 
||
                   '.' ||
                   lower(lv_table_name) || ' TO ' || lower(lv_grantee) ||
                   lv_option;
      write_out(lv_sequence, lv_grantor,lv_string);
    END LOOP;
  CLOSE grant_cursor;
END;
/
--set termout on 
clear breaks
break on guser skip 1
col text format a200 word_wrap
select   'connect ' || grantor_owner || '@FEED_27'  guser, chr(10) || text
from     g_temp
order by grantor_owner, seq
/
drop table g_temp
/
spool off
undef user_list
drop table g_temp
clear breaks
set termout on
select 'Finished!' from dual
/
host notepad C:\grant_list.txt
