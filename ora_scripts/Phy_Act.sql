set pages 80
set lines 120
set time off
set timing off

SET UNDERLINE OFF
col HOST_NAME format a20
col HOST_IP format a20
spool D:\Dailychkup\scripts\Physical_Actual.txt

conn ctpl_operations/ctpl_operations@LOADTRC
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;

SET HEADING OFF

conn SYS/SYS@ONEVIEW AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@boi
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@MXPDB_128.5.22.138 
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn  ctpl_operations/ctpl_operations@HRAPPSDB 
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys@LOYALTYSVR as sysdba
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@NEWVIAPPDB 
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn sys/sys123@dbtest as sysdba
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@TECHDB
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@FEED2
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@NTB
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@IDBIACQ
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@MEBILING57
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@VIGL
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn SYS/SYS@ACQUIRERDR_79 AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@BOIACQ80
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@INSIGHT79
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@LOYALTYSVR
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@applydb
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn ctpl_operations/ctpl_operations@BOIBILL as sysdba
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys@CSDBTEST as sysdba
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys@dbuat as sysdba
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@orcl
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@histdb
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys123@dbtest as sysdba
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@FEED_17
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@FEED124
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@CQDB1
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@CQDB_80
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@FEED as sysdba
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



#conn sys/sys123@selectsys_121 AS SYSDBA
#Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;

conn SYS/SYS123@SELECSYS2  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/SYS123@SELECSYS_120  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/SYS123@SELECSYS_121  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/SYS@APPLYDBDR_79  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/cl0ver123@INSIGHTDR_35  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/cl0ver123@INSIGHTDR_34 AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@NTBLIVE AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


#conn SYS/sys@FEED_LIN AS SYSDBA
#Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;

#icici
#MAHE
#ACQUIRER_17
#FEED_LINUX
#mxpdb
#INSIGHTDRS
#FEED_17
#ONEVIEWDR_34


conn SYS/sys@APPLYDBDR_34 AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;



conn SYS/sys@ACQUIRERDR_33  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@FEED_101  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys123@SELECSYSDR_26  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@CSDBTESTDMP  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys123@CCARD11 AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;

conn SYS/sys123@SELECSYS_EPSILON AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@CQDBDR_34 AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys123@LOADTRC_33 AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@FEED_34  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@LOADTRC   AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@BOIACQDR_33  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@BOI_DRS   AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@INFY AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@ACQ AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@NTBTEST AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@HISTDB_27  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


#conn SYS/sys@INSIGHT_DR  AS SYSDBA
#Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;

conn SYS/sys@NTBACQ  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@SELECSYS_ZETA  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@MXPDB57  AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@MEBILING35   AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@ORCL_18   AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@SUDHEER   AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn SYS/sys@CQDB1_18   AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn ctpl_operations/ctpl_operations@CQDB1   AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys123@BOIACQ80    AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys@PCIDB    AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys@ORADB    AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;


conn sys/sys@corpbank_28    AS SYSDBA
Select (Select Name from V$Database) Database_Name,(Select Host_Name from V$INSTANCE) HOST_NAME,(Select utl_inaddr.get_host_address(Host_Name) from V$INSTANCE) HOST_IP,(Select Sum(Bytes) from DBA_DATA_FILES)/1024/1024/1024 Physical_Size,(Select Sum(Bytes)/1024/1024/1024 from DBA_SEGMENTS) Actual_Size from DUAL;

spool off;


exit




