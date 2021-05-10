REM -----------------------------------------------------
REM $Id: find-obj.sql,v 1.1 2002/03/14 19:59:43 hien Exp $
REM Author      : Murray Ed
REM #DESC       : Find table or index given a file id and block id
REM Usage       : fid - file id
REM               blk - block id
REM Description : Find table or index given a file id and block id
REM -----------------------------------------------------

undefine fid
undefine blk

set linesize 132
set verify off

column column_name format a29


ACCEPT fid prompt 'Please enter file id: '
ACCEPT blk prompt 'Please enter block: '


Select segment_name
From dba_extents
where file_id = &fid
and &blk between block_id and  block_id+blocks;

undefine fid
undefine blk