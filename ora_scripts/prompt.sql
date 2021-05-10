REM ------------------------------------------------------------------------------------------------
REM $Id: prompt.sql,v 1.3 2003/03/26 18:04:06 hien Exp $
REM Author     : hien
REM #DESC      : Set SQL prompt with user name, instance name
REM Usage      : Run automatically at SQL*Plus startup
REM Description: called by login.sql
REM ------------------------------------------------------------------------------------------------
SET echo off TERMOUT OFF feed off
COLUMN user_name NEW_VALUE xUser NOPRINT
COLUMN instance_name NEW_VALUE xInstance NOPRINT
SELECT user user_name, upper(instance_name) instance_name FROM v$instance;
SET SQLPROMPT &&xUser..&&xInstance.>
