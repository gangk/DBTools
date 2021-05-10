REM ------------------------------------------------------------------------------------------------
REM $Id: idx-hwm.sql,v 1.1 2002/04/01 22:34:40 hien Exp $
REM Author     : hien
REM #DESC      : Show index high water mark and unused blocks
REM Usage      : Input parameter: idx_owner & idx_name
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

accept idx_owner	prompt 'Enter Index Owner: ' 
accept idx_name  	prompt 'Enter Index Name : ' 

prompt ;
prompt ;
prompt -- INDEX HWM --;
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
	dbms_space.unused_space(upper('&&idx_owner'),upper('&&idx_name'),'INDEX',
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

undef idx_owner
undef idx_name
