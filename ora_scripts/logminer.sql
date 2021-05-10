
-- Build dictionary in flat file
BEGIN
sys.DBMS_LOGMNR_D.BUILD ( dictionary_filename  => 'dictionary.ora'
                        , dictionary_location  => '/appl/oracle/admin/CALYPSOP/udump'
                        , options              => sys.DBMS_LOGMNR_D.STORE_IN_FLAT_FILE);
END;
/



-- Change Tablespace for Logminer tables
sys.DBMS_LOGMNR_D.SET_TABLESPACE('USERS');


-- Add archive redo log files
begin
for i in 42634 .. 42714
loop
 execute immediate 'begin sys.DBMS_LOGMNR.ADD_LOGFILE(''/orabackups/restore/CALYPSOP_log_' || i || '_1_546690336.arc''); end;';
end loop;
end;
/


-- Start Log mining session
sys.DBMS_LOGMNR.START_LOGMNR( 
   OPTIONS   => sys.DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG
 , startTime => to_date('30-NOV-07 12:00:00','DD-MON-YY HH24:MI:SS')
 , endTime   => to_date('30-NOV-07 23:59:59','DD-MON-YY HH24:MI:SS')
-- , startSCN => 1232
-- , endSCN   => 1234
-- , DictFileName => '',
);


/*
OPTIONS above can be

COMMITTED_DATA_ONLY
SKIP_CORRUPTION
DDL_DICT_TRACKING
DICT_FROM_ONLINE_CATALOG
DICT_FROM_REDO_LOGS
NO_SQL_DELIMITER
NO_ROWID_IN_STMT
PRINT_PRETTY_SQL
CONTINUOUS_MINE

*/


select * from  V$LOGMNR_CONTENTS;



sys.DBMS_LOGMNR.END_LOGMNR;








DECLARE
  LOGSEQ_LOW         NUMBER := 143025;
  LOGSEQ_HIGH        NUMBER := 144765;
  LOGS_BATCH_SIZE    NUMBER := 10;
BEGIN


   execute immediate 'truncate table logminer.MINED_LOGMNR_CONTENTS';


-- Change Tablespace for Logminer tables
-- sys.DBMS_LOGMNR_D.SET_TABLESPACE('LOGMINER');


FOR j in 0 .. CEIL((LOGSEQ_HIGH - LOGSEQ_LOW)/LOGS_BATCH_SIZE)
Loop

      -- Add archive redo log files
      For I In (Logseq_low + (J*Logs_batch_size) )  .. (Logseq_low + (J*Logs_batch_size) + Logs_batch_size - 1 )
      --for i in LOGSEQ_LOW .. LOGSEQ_HIGH
      loop
        Exit When I >=  Logseq_high;
        execute immediate 'begin sys.DBMS_LOGMNR.ADD_LOGFILE(''/OraData2/I981172/627394646_1_' || i || '.arc''); end;';
      end loop;


      -- Start Log mining session
      Sys.Dbms_logmnr.Start_logmnr(
         OPTIONS   => sys.DBMS_LOGMNR.PRINT_PRETTY_SQL
      --,  startTime => to_date('30-OCT-09 00:00:00','DD-MON-YY HH24:MI:SS')
      -- , endTime   => to_date('30-OCT-09 00:01:00','DD-MON-YY HH24:MI:SS')
      -- , startSCN => 1232
      -- , endSCN   => 1234
       , DictFileName => '/OraData2/I981172/dictionary.ora'
      );




      insert /*+ APPEND */into logminer.MINED_LOGMNR_CONTENTS
      select * from  V$LOGMNR_CONTENTS where SEG_OWNER = 'RABO' AND TABLE_NAME IN ('PREFERENCES','USERPREFSLR');
      commit;

      sys.DBMS_LOGMNR.END_LOGMNR;

End Loop;

End;
/

