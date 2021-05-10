set feed off;
set pagesize 10000;
set wrap off;
set linesize 200;
set heading on;
set tab on;
set scan off;
set verify off;
set termout on;

column  BT      format a29      heading 'Block Type'
column  KIND    format a12      heading 'Object Type'
column  CB      format 99990    heading 'Nr of Blocks'
column  NAME    format a24      heading 'Object Name'

ttitle left 'Buffer Cache Analysis - Objects' skip 2

spool  C:\ buffer_cache_analysis_obj.txt

select  NAME,
        KIND,
        decode  (CLASS#,0, 'FREE',
                        1, 'DATA INDEX',
                        2, 'SORT',
                        3, 'SAVE UNDO',
                        4, 'SEG HEADER',
                        5, 'SAVE UNDO SH',
                        6, 'FREELIST BLOCK',
        'OTHER') as BT,
        count (BLOCK#) as CB
  from  V$CACHE
 group  by
    NAME,
    KIND,
    CLASS#
 order  by
    CB  desc,
    NAME,
    KIND
/

spool off;
