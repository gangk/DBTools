REM GET_RESOURCE_NAME

col hexname for a25
col resource_name for a24


select b.kjblname hexname , b.kjblname2 resource_name,b.kjblgrant, b.kjblrole,b.kjblrequest from X$LE a,X$KJBL b
where a.le_kjbl=b.kjbllockp
and a.le_addr=(select le_addr from X$BH where dbablk=&blk and obj=&data_object_id and class=1 and state !=3);
