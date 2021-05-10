--
-- OraLatencyMap, a tool to visualize Oracle I/O latency using Heat Maps
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
-- Use: @OraLatencyMap 
--      Note: run from sql*plus. Better not use rlwrap when running this, or graphics smootheness will suffer
--
-- Output: 2 latency heat map of the "db file sequential read" wait event refreshed every few seconds.      
--         The top map represents the number of waits per second and per latency bucket
--         The bottom map represented the estimated time waited per second and per latency bucket
-- 
-- Scope:  Performance investigations of single block read latency
--         Examples: the latency bucket 1(ms) gives the details of 'fast reads', likely from the storage cache.
--         Latency buckets around 10 ms range would typically give details on physical reads from spindles
--         IO 'outliers' with latency higher than a few tens of ms can be sign of a problem that needs further 
--         investigations.
--         
-- Related: OraLatencyMap_event -> this is the main script for generic investigation of event latency with heat maps
--          OraLatencyMap_internal -> the slave script where all the computation and visualization is done

@@OraLatencyMap_event 3 "db file sequential read"
