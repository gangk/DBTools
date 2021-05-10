undef last_x_mins
@plusenv
    col block_type for a15
    col objn for a30
    col sname for a30
    col otype for a10	trunc
    col filen for 9999
    col blockn for 9999999
    col obj for a40
    col tbs for a25
col cnt	format 9999
col p1		format 999
col p2		format 999999
col p3		format 999
select
       bbw.cnt,
       bbw.obj,
       bbw.otype,
       bbw.sname,
       bbw.sql_id,
       bbw.block_type,
       bbw.p1,
       bbw.p3,
       nvl(tbs.name,to_char(bbw.p1)) TBS,
       tbs_defs.assm ASSM
from (
    select
       count(*) cnt,
       o.owner||'.'||nvl(object_name,CURRENT_OBJ#) obj,
       o.object_type otype,
       o.subobject_name sname,
       ash.SQL_ID sql_id,
       nvl(w.class,'usn '||to_char(ceil((ash.p3-18)/2))||' '||
                    decode(mod(ash.p3,2),
                         1,'header',
                         0,'block')) block_type,
       ash.p3 p3,
       ash.p1 p1
    from v$active_session_history ash,
        ( select rownum class#, class from v$waitstat ) w,
        all_objects o
    where event='buffer busy waits'
      and w.class#(+)=ash.p3
      and o.object_id (+)= ash.CURRENT_OBJ#
      and ash.session_state='WAITING'
      and ash.sample_time > sysdate - &&last_x_mins/(60*24)
      --and w.class# > 18
   group by o.owner, o.object_name, ash.current_obj#, o.object_type, o.subobject_name,
         ash.sql_id, w.class, ash.p3, ash.p1
  ) bbw,
    (select   file_id, 
       tablespace_name name
  from dba_data_files
   ) tbs,
    (select
 tablespace_name    NAME,
        extent_management  LOCAL,
        allocation_type    EXTENTS,
        segment_space_management ASSM,
        initial_extent
     from dba_tablespaces 
   ) tbs_defs
  where tbs.file_id(+) = bbw.p1
    and tbs.name=tbs_defs.name
Order by bbw.cnt
;
