col event for a35
col P1text for a15
col P2text for a15
col P3text for a15
col file_name for a55
col segment_name for a20



Prompt*****************************************************SESSION WAIT********************************************************************************************

select sid,seq#,event,p1 file#,p2 block#,p3 "reason code",wait_time from v$session_wait;

Prompt**************************************************FILE NAME******************************************************************************************************

SELECT tablespace_name, file_name  FROM dba_data_files WHERE file_id = &AFN;


Prompt*****************************************BLOCK DETAILS*************************************************************************************************************

SELECT  owner , segment_name , segment_type  FROM  dba_extents WHERE  file_id = &AFN AND  &BLOCKNO BETWEEN block_id AND block_id + blocks -1;


