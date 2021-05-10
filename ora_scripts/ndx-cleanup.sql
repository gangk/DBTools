declare
 
/* Name :- ndx-cleanup.sql */
/* DB Version :- 11.1.0.7 */
/* Author :- Sumit Bhatia */
/* Version :- 1.1
/* Purpose :- To cleanup the journal entries */
/* Input :- owner and index name */
 
/*declare variables*/
index_name dba_objects.object_name%type;
index_owner dba_objects.owner%type;
index_id dba_objects.object_id%type;
index_status dba_objects.status%type;
journal_name dba_objects.object_name%type;
retval boolean;
wait_for_lock binary_integer;
 
begin
/* INITIALIZE */
journal_name:='NONE_NONE';
 
/*check if index exists*/
 begin
select object_name,owner,object_id,status into index_name,index_owner,index_id,index_status from dba_objects where owner=upper('&owner') and object_name=upper('&index_name') and object_type='INDEX';
 exception
 WHEN NO_DATA_FOUND THEN
 dbms_output.put_line('INDEX NOT FOUND');
 raise;
 end;
 
/*check if index is stuck in journal*/
 begin
 select object_name into journal_name from dba_objects where object_name=concat('SYS_JOURNAL_',index_id);
 exception
 WHEN NO_DATA_FOUND THEN
 journal_name:='NONE_NONE';
 end;
 
dbms_output.put_line('OBJECT ID OF INDEX IS -----------> '||index_id);
if journal_name ='NONE_NONE'
then
 dbms_output.put_line('No journal table found. Index is clean');
else
 dbms_output.put_line('JOURNAL TABLE IS -----------> '||journal_name);
 dbms_output.put_line('CURRENT INDEX STATUS -----------> '||index_status);
 
 wait_for_lock := NULL;
 retval:=sys.dbms_repair.online_index_clean(index_id);
 case
 when retval then dbms_output.put_line('INDEX CLEANUP COMPLETED');
 when not retval then dbms_output.put_line('INDEX COULD NOT BE CLEANED');
 end case;
 
 commit;
end if;
 
/*confirm that journal entry has been cleared */
begin
 select object_name into journal_name from dba_objects where object_name=concat('SYS_JOURNAL_',index_id);
 exception
 WHEN NO_DATA_FOUND THEN
 dbms_output.put_line('NO JOURNAL TABLE FOUND');
 end;
 
end;
/
