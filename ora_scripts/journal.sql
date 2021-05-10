column name format a30
column jname format a20
column iotname format a20
column obj# format 99999999
select i_info.iname,i_info.obj#,j_info.jname, j_info.obj#, iot_info.iotname, iot_info.obj#
from
(select a.name iname, b.obj#, 'SYS_JOURNAL_'||b.obj# jname
 from sys.obj$ a, sys.ind$ b
 where a.obj# = b.obj#
 and bitand(b.flags, 512)=512) i_info,
(select name jname, obj#, 'SYS_IOT_TOP_'||obj# iotname
 from sys.obj$
 where name like 'SYS_JOURNAL_%') j_info,
(select name iotname, obj#
 from sys.obj$
 where name like 'SYS_IOT_TOP_%') iot_info
where j_info.jname = i_info.jname (+)
and j_info.iotname = iot_info.iotname (+);
