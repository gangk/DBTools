======
Title:
======

Compiling Invalid Objects in the Database

===========
Disclaimer:
===========

This script is provided for educational purposes only.  It is not supported by
Oracle Worldwide Technical Support.  This script has been tested and appears
to work as intended.  However, you should always test any script before
relying on it.

PROOFREAD THIS SCRIPT BEFORE USING IT!   Due to differences in the way text
editors, e-mail packages, and operating systems handle text formatting
(spaces, tabs, and carriage returns), this script may not be in an executable
state when you first receive it.  Check over the script to ensure that errors
of this type are corrected.

=========
Abstract:
========

This script will compile INVALID objects in the database.

=============
Requirements:
=============

DBA

=======
Script:
=======

-------------cut-------------cut---------------cut--------------
*/
REM Script to compile INVALID Objects in the database
REM
REM      VALIDATE.SQL
REM
REM
REM      This script recompiles all objects that have become invalidated
REM
REM
REM     For proper generation of the log file, this script should be
REM     run after connecting as SYS (or internal) using SQL*Plus 3.3
REM     (PLUS33W.EXE or PLUS33.EXE).
REM
REM     When run from Server Manager 2.3, all objects will still be
REM     recompiled, but the log file, VALIDATE.LOG, will contain some
REM     error messages.  Those error messages are generated because
REM     Server Manager does not understand all of the SET xxx messages
REM     used in this script.
REM

set pagesize 0
set linesize 120
set heading off
set feedback off
set trimspool on
set termout on
select 'Recompiling '||count(object_name)||' invalid objects.'
        from dba_objects where status='INVALID';
prompt This may take a long time.  Please wait...
set termout off
spool validate_objects.sql
prompt spool validate.log
prompt set trimspool on

select 'alter ' || decode(object_type, 'PACKAGE BODY', 'PACKAGE', object_type)
      || ' ' || owner || '.' || object_name || ' compile'
        || decode(object_type, 'PACKAGE BODY', ' body;', ';')
from dba_objects
where status='INVALID'
order by decode(owner, 'SYS', 'A', 'SYSTEM', 'B', 'C'||owner) asc,
         decode(object_type, 'PACKAGE BODY', 'AAA', 'PACKAGE', 'AAB',
                substr(object_type, 1, 3)) desc,
     object_name;

REM
REM Compile SYS's objects first, then SYSTEM's, then the rest.
REM This order by clause will result in compiling objects
REM in this order:
REM
REM      VIEWS, TRIGGERS, PROCEDURES, FUNCTIONS, PACKAGES, PACKAGE BODIES.
REM

select 'set heading on' from dual;
select 'set feedback on' from dual;
select 'select substr(rpad(owner||''.''||object_name,40)' from dual;
select '        ||''(''||object_type||'')'', 1, 80) "Remaining Invalid
Objects"' from dual;
select 'from dba_objects where status=''INVALID'' order by owner, object_type,
object_name;' from dual;
select 'spool off' from dual;
spool off

@validate_objects.sql
set termout on
set pagesize 25
set linesize 80
set heading off
set feedback off
select chr(13)||'Finished recompiling.' from dual;
select chr(13)||'There are '||count(*)||' remaining invalid objects.'
    ||decode(count(*), 0, null, '  Please recompile manually.')
      from dba_objects where status='INVALID';
set heading on
select substr(rpad(owner||'.'||object_name,40)
     ||'('||object_type||')', 1, 80) "Remaining Invalid Objects"
      from dba_objects where status='INVALID' order by owner, object_type,
object_name;
/*
-------------cut-------------cut---------------cut--------------

