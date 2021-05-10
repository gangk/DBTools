col object_anme for a20


select object_name from dba_objects 
where object_id IN (select obj# from ind$ where BITAND(property,4) = 4);