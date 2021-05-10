REM Program     : response_time_analysis.sql
REM Purpose     : List components of database response time for an Oracle 10g database.
REM Author      : Daniel W. Fink OptimalDBA.com
REM Created     : January 23, 2007
REM Update      : 
REM Parameters  : Not Used
REM Exit Codes  : Not Used
REM Comments    : This works for 10g ONLY!
REM Disclaimer  : No warranty is provided for any use of the script, statements or logic included. 
REM               This script, statements and logic are for personal use only and may not be included as part of a commercial product. 
REM               This comment block and all lines above must be included.
REM               Please address any comments to script_feedback@optimaldba.com

SET LINESIZE 132 PAGESIZE 100  FEEDBACK OFF
COLUMN time_sum       NOPRINT
COLUMN total_time     NOPRINT
COLUMN wait_class     FORMAT A15                  HEADING 'Class'
COLUMN event          FORMAT A40                  HEADING 'Event'
COLUMN wait_seconds   FORMAT 999,999,999,999.99   HEADING 'Wait Seconds'
COLUMN wait_pct       FORMAT 99.999999            HEADING '% of T' NOPRINT
COLUMN nonidle_pct    FORMAT 99.999999            HEADING '% of R'

BREAK ON wait_class SKIP PAGE
COMPUTE SUM OF wait_seconds nonidle_pct ON wait_class

TTITLE LEFT "*** Response Time Components by Class ***"

SELECT vswc.time_waited time_sum,
       ven.wait_class,
       vse.event,       
       ROUND((vse.time_waited_micro/1000000),4) wait_seconds,
       instime.time_waited total_time,
       (ROUND((vse.time_waited_micro/1000000),6)/(instime.time_waited/100))*100 wait_pct,
       TO_NUMBER(DECODE(vswc.wait_class, 'Idle', NULL, 'Network', NULL, 
                        (ROUND((vse.time_waited_micro/1000000),6)/
                              ((instime.time_waited - idletime.time_waited)/100))*100)) nonidle_pct
FROM v$system_event vse,
     v$event_name ven,
     v$system_wait_class vswc,
     (SELECT SUM(time_waited) time_waited
      FROM (SELECT time_waited
            FROM v$system_wait_class
            UNION
            SELECT value
            FROM v$sysstat
            WHERE name = 'CPU used when call started')) instime,
     (SELECT SUM(time_waited) time_waited
      FROM v$system_wait_class
      WHERE wait_class IN ('Idle', 'Network')) idletime
WHERE ven.event_id = vse.event_id
  AND vswc.wait_class = ven.wait_class
UNION
SELECT vss.value time_sum,
       'CPU Utilization' wait_class,
       NULL,
       vss.value/100 wait_seconds,
       instime.time_waited total_time,
       (ROUND((vss.value/100),6)/(instime.time_waited/100))*100 wait_pct,
       ((ROUND((vss.value/100),6)/((instime.time_waited - idletime.time_waited)/100))*100) nonidle_pct
FROM v$sysstat vss,
     (SELECT SUM(time_waited) time_waited
      FROM (SELECT time_waited
            FROM v$system_wait_class
            UNION
            SELECT value
            FROM v$sysstat
            WHERE name = 'CPU used when call started')) instime,
     (SELECT SUM(time_waited) time_waited
      FROM v$system_wait_class
      WHERE wait_class IN ('Idle', 'Network')) idletime
WHERE vss.name = 'CPU used when call started'
ORDER BY time_sum, wait_class, wait_seconds DESC
/

CLEAR BREAK
CLEAR COMPUTE

TTITLE LEFT "*** Response Time Components by Time ***"

SELECT vse.event,       
       ROUND((vse.time_waited_micro/1000000),4) wait_seconds,
       (ROUND((vse.time_waited_micro/1000000),6)/((nonidletime.time_waited)/100))*100 nonidle_pct
FROM v$system_event vse,
     v$event_name ven,
     v$system_wait_class vswc,
     (SELECT SUM(time_waited) time_waited
      FROM (SELECT time_waited
            FROM v$system_wait_class
            WHERE wait_class NOT IN ('Idle', 'Network')
            UNION
            SELECT value
            FROM v$sysstat
            WHERE name = 'CPU used when call started')) nonidletime
WHERE ven.event_id = vse.event_id
  AND vswc.wait_class = ven.wait_class
  AND vswc.wait_class NOT IN ('Idle', 'Network')
UNION
SELECT 'CPU Utilization' wait_class,
       vss.value/100 wait_seconds,
       (ROUND((vss.value/100),6)/((nonidletime.time_waited)/100))*100 nonidle_pct
FROM v$sysstat vss,
     (SELECT SUM(time_waited) time_waited
      FROM (SELECT time_waited
            FROM v$system_wait_class
            WHERE wait_class NOT IN ('Idle', 'Network')
            UNION
            SELECT value
            FROM v$sysstat
            WHERE name = 'CPU used when call started')) nonidletime
WHERE vss.name = 'CPU used when call started'
ORDER BY wait_seconds DESC
/


