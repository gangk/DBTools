select a.INST_ID,a.OBJECT_ID,a.SESSION_ID,a.PROCESS,b.object_name from gv$locked_object a,dba_objects b where a.OBJECT_ID=b.OBJECT_ID and b.object_name=upper('&table_name');