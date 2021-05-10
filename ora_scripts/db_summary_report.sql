break on today
column today noprint new_value xdate
select substr(to_char(sysdate,'fmMonth DD, YYYY HH:MI:SS P.M.'),1,35) today
from dual;
column name noprint new_value dbname
select name from v$database;

spool database.rpt

rem -------------------------------------------------------------
rem             Tablespace Information
rem -------------------------------------------------------------

set pagesize 66
set line 132

break on "Tablespace Name" skip 1

TTitle left "*** Database:  "dbname", Tablespace Size Information (As of:  "xdate " ) ***" skip 1

select  substr(ts.TABLESPACE_NAME,1,32) "Tablespace Name",
        substr(ts.INITIAL_EXTENT,1,10) "INI_Extent",
        substr(ts.NEXT_EXTENT,1,10) "Next Exts",
        substr(ts.MIN_EXTENTS,1,5) "MinEx",
        substr(ts.MAX_EXTENTS,1,5) "MaxEx",
        substr(ts.PCT_INCREASE,1,5) "%Incr",
        substr(ts.STATUS,1,8) "Status",
        substr(df.FILE_NAME,1,52) "DataFile Assigned"
from sys.dba_tablespaces ts, sys.dba_data_files df
where   ts.TABLESPACE_NAME = df.TABLESPACE_NAME(+) and
        ts.STATUS NOT LIKE 'INVALID'
order by ts.tablespace_name, df.file_name;

TTITLE OFF


rem -------------------------------------------------------------
rem             Tablespace Usage Information
rem -------------------------------------------------------------

set pagesize 66
set line 132

clear breaks
clear computes

column "Total Bytes" format 9,999,999,999
column "SQL Blocks" format 999,999,999
column "VMS Blocks" format 999,999,999
column "Bytes Free" format 9,999,999,999
column "Bytes Used" format 9,999,999,999
column "% Free" format 9999.999
column "% Used" format 9999.999
break on report
compute sum of "Total Bytes" on report
compute sum of "SQL Blocks" on report
compute sum of "VMS Blocks" on report
compute sum of "Bytes Free" on report
compute sum of "Bytes Used" on report
compute avg of "% Free" on report
compute avg of "% Used" on report

TTitle left "*******   Database:  "dbname", Current Tablespace Usage ( As of:"xdate")***"  
skip 1

select  substr(fs.FILE_ID,1,3) "ID#",
        fs.tablespace_name,
        df.bytes "Total Bytes",
        df.blocks "SQL Blocks",
        df.bytes/512 "VMS Blocks",
        sum(fs.bytes) "Bytes Free",
(100*((sum(fs.bytes))/df.bytes)) "% Free",
        df.bytes-sum(fs.bytes) "Bytes Used",
        (100*((df.bytes-sum(fs.bytes))/df.bytes)) "% Used"
from sys.dba_data_files df, sys.dba_free_space fs
where df.file_id(+) = fs.file_id
group by fs.FILE_ID, fs.tablespace_name, df.bytes, df.blocks
order by fs.tablespace_name;

ttitle off


rem -------------------------------------------------------------
rem             Datafile Information
rem -------------------------------------------------------------

set pagesize 66
set line 132

clear breaks
clear computes

break on report
column "Bytes" format 9,999,999,999
compute Sum of bytes "Bytes" on report
compute Sum of blocks "SQL Blks" on report
compute Sum of bytes/512 "VMS Blocks" on report

TTitle left "*Database:  "dbname", Datafile Information (As of:  " xdate ")***" skip 1

select  substr(FILE_ID,1,3) "ID#",
        substr(FILE_NAME,1,52) "DataFile Name",
        substr(TABLESPACE_NAME,1,25) "Related Tablespace",
        BYTES "Bytes",
        BLOCKS "SQL Blks",
        BYTES/512 "VMS Blocks",
        STATUS
from sys.dba_data_files
order by TABLESPACE_NAME, FILE_NAME;

TTITLE OFF
clear breaks
clear computes


rem -------------------------------------------------------------
rem             User Information
rem -------------------------------------------------------------

set line 132
set pagesize 66

ttitle "****   Database:  "dbname", Users (As Of:  "xdate")   ****" skip 1

select  user_id,
        substr(username,1,15) UserName,
        substr(password,1,15) Password,
        substr(DEFAULT_TABLESPACE,1,15) "Default TBS",
        substr(TEMPORARY_TABLESPACE,1,15) "Temporary TBS",
        CREATED,
        substr(profile,1,10) Profile
from sys.dba_users
order by username;

ttitle off


rem -------------------------------------------------------------
rem             Table Information
rem -------------------------------------------------------------

set pagesize 66
set line 131

break on "Owner" skip 1

TTitle left "*** Database:  "dbname", Table Size Information (As of:  " xdate") ***" skip 1

select  substr(OWNER,1,15) "Owner",
        substr(TABLESPACE_NAME,1,32) "Tablespace Name",
        substr(TABLE_NAME,1,24) "Table Name",
        substr(PCT_FREE,1,3) "%F",
        substr(PCT_USED,1,3) "%U",
        substr(INI_TRANS,1,2) "IT",
        substr(MAX_TRANS,1,3) "MTr",
        substr(INITIAL_EXTENT,1,10) "INI_Extent",
        substr(NEXT_EXTENT,1,10) "Next Exts",
        substr(MIN_EXTENTS,1,5) "MinEx",
substr(MAX_EXTENTS,1,5) "MaxEx",
        substr(PCT_INCREASE,1,5) "%Incr"
from sys.dba_tables
order by owner, tablespace_name, table_name;

ttitle off


rem -------------------------------------------------------------
rem             Index Information
rem -------------------------------------------------------------

set line 79
set pagesize 66

clear breaks
clear computes

column TABLE_NAME format a20
break on TABLE_NAME on report

TTitle left "*** Database:  "dbname", Indexes Information (As of:  " xdate " )***" skip 1

select  distinct
        TABLE_NAME,
     INDEX_NAME,
        STATUS,
        UNIQUENESS
from sys.dba_indexes
where TABLE_OWNER not in ('SYS', 'SYSTEM')
and     TABLE_TYPE = 'TABLE'
order by TABLE_NAME, index_name;

ttitle off
clear breaks


rem -------------------------------------------------------------
rem             Synonyms Information
rem -------------------------------------------------------------

set line 131
set pagesize 66

clear breaks
clear computes

break on "Owner" skip 1

TTitle left "*** Database:  "dbname", Synonym Information (As of:  " xdate " )***" skip 1

select  substr(owner,1,10) Owner,
        synonym_name,
        substr(TABLE_OWNER,1,15) Table_Owner,
        substr(TABLE_NAME,1,20) Table_Name,
        substr(DB_LINK,1,20) DB_Link
from sys.dba_synonyms
where OWNER not in ('SYS', 'SYSTEM')
and TABLE_OWNER not in ('SYS', 'SYSTEM')
order by owner, synonym_name, TABLE_NAME;

ttitle off
clear computes


rem -------------------------------------------------------------
rem             Views Information
rem -------------------------------------------------------------

set line 132
set pagesize 66

clear breaks
clear computes

break on TABLE_NAME on "View Name" skip 1

TTitle left "*** Database:  "dbname", Views Information (As of:  " xdate " )***" skip 1

select distinct
        v.VIEW_NAME "View Name",
        c.TABLE_NAME,
        c.COLUMN_NAME,
        c.DATA_TYPE,
        c.DATA_LENGTH
from SYS.DBA_VIEWS v, SYS.DBA_TAB_COLUMNS c
where v.VIEW_NAME = c.TABLE_NAME
and v.OWNER not in ('SYS', 'SYSTEM')
order by v.view_name, c.column_name;

ttitle off
clear computes


rem -------------------------------------------------------------
rem             Other Objects Information
rem -------------------------------------------------------------

set line 79
set pagesize 66

clear breaks
clear computes

break on "Owner" skip 1

TTitle left "*** Database:  "dbname", Other Objects Information (As of:  "xdate " ) ***" 
skip 1

select  substr(owner,1,10) Owner,
        substr(OBJECT_NAME,1,25) Object_Name,
        object_type, status, created
from sys.dba_objects
where object_type not in
('INDEX', 'SYNONYM', 'TABLE', 'VIEW')
AND OWNER not in ('SYS', 'SYSTEM')
order by owner, object_type;

ttitle off
clear computes


rem -------------------------------------------------------------
rem -------------------------------------------------------------

spool off
exit
