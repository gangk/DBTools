--
-- OraLatencyMap_event, a tool to visualize Oracle event latency using Heat Maps
--
-- Luca.Canali@cern.ch, v1.0, May 2013
--
-- Credits: Brendan Gregg for "Visualizing System Latency", Communications of the ACM, July 2010
--          Tanel Poder (snapper, moats, sqlplus and color), Marcin Przepiorowski (topass)
--
--
-- Notes: This script needs to be run from sqlplus from a terminal supporting ANSI escape codes. 
--        For Oracle 11g or higher. Tested on 11.2.0.3, Linux. 
--        Run from a privileged user (need to access v$event_histogram and execute dbms_lock.sleep)
--
-- Use: @OraLatencyMap_event <refresh time in sec> "<event name>" 
--      Example: @OraLatencyMap_event 3 "log file sync"
--      Note: run from sql*plus. Better not use rlwrap when running this, or graphics smootheness will suffer
--
--
-- Output: 2 latency heat maps of the given wait event
--         The top map represents the number of waits per second and per latency bucket
--         The bottom map represented the estimated time waited per second and per latency bucket
-- 
--         
-- Related: OraLatencyMap  -> this is a wrapper for this script limited to db file sequential read event
--          OraLatencyMap_internal -> the slave script where all the computation and visualization is done
--
-- Todo:   input validation
--

set lines 2000
set pages 100
set feedback off
set verify off
set heading off
set long 100000
set longchunksize 100000

var var_dump_wait_count  clob
var var_dump_time_waited clob
var var_screen clob

var var_dump_latest_wait_count varchar2(1000)
var var_dump_latest_time_waited varchar2(1000)
var var_dump_latest_time_sec number

var var_number_iterations number

begin
  :var_number_iterations :=0;
  :var_dump_wait_count :='';
  :var_dump_time_waited :='';
end;
/

define sleep_interval=&1
define wait_event='&2'
define num_bins=11
define num_rows=90

prompt OraLatencyMap collecting first datapoints, please wait.
prompt Note: this tool requires a terminal supporting ANSI escape code (examples: xterm, putty)

--The actual code is in the OraLatencyMap_internal script. 
--We jump through hoops to avoid creating objects in the DB

@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal
@@OraLatencyMap_internal


