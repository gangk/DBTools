REM GET_BUFFER_STAT

select state.mode_held,le_addr,dbarfil,dbablk,cr_scn_bas,cr_scn_wrp from x$BH where obj in (select data_object_id from dba_objects where object_name=upper('&object') and class=1;