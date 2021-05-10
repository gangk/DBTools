REM ------------------------------------------------------------------------------------------------
REM $Id: tab-hwm.sql,v 1.1 2002/04/01 22:34:41 hien Exp $
REM Author     : hien
REM #DESC      : Show table high water mark and unused blocks
REM Usage      : Input parameter: tab_owner & tab_name
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

accept tab_owner	prompt 'Enter Table Owner: ' 
accept tab_name  	prompt 'Enter Table Name : ' 

prompt ;
prompt ;
prompt -- TABLE HWM --;
prompt ;

DECLARE
	tblks 	number;
	tbytes 	number;
	ublks	number;
	ubytes	number;
	luefid 	number;
	luebid	number;
	lub 	number;
BEGIN
	dbms_space.unused_space(upper('&&tab_owner'),upper('&&tab_name'),'TABLE',
				tblks,tbytes,ublks,ubytes,luefid,luebid,lub);
	dbms_output.put_line('Total Blocks      = '||tblks);
	dbms_output.put_line('Total Bytes       = '||tbytes);
	dbms_output.put_line('Total MB          = '||round(tbytes/(1024*1024),2));
	dbms_output.put_line('.');
	dbms_output.put_line('Unused Blocks     = '||ublks);
	dbms_output.put_line('Unused Bytes      = '||ubytes);
	dbms_output.put_line('Unused MB         = '||round(ubytes/(1024*1024),2));
	dbms_output.put_line('.');
	dbms_output.put_line('HWM Blocks        = '||(tblks - ublks));
	dbms_output.put_line('HWM MB            = '||round((tbytes - ubytes) / (1024*1024),2) );
	dbms_output.put_line('HWM Pct           = '||round((tbytes - ubytes) / tbytes * 100,2) );
END;
/

undef tab_owner
undef tab_name
