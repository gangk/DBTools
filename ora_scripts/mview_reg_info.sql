column snapid   format 99999
column snaptime format a30
column snapsite format a30
column snapname format a30

select r.name snapname, snapid, nvl(r.snapshot_site, 'not registered') snapsite,to_char(snaptime,'DD-MON-YY HH24:MI:Ss')snaptime from sys.slog$ s, dba_registered_snapshots r where  s.snapid=r.snapshot_id(+) and mowner like upper('&owner_name') and master like upper('%&table_name%');

            

              
