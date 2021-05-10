select o.name,c.name,decode (bitand(h.spare2,8),8,'yes','no') incremental from sys.hist_head$ h,sys.obj$ o,sys.col$ c
where
h.obj#=o.obj#
and o.obj#=c.obj#
and h.intcol#=c.intcol#
and o.name=upper('&table_name')
and o.subname is null;