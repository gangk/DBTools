column mowner   format a20
column snapid   format 99999
column snaptime format a30
column master format a30
column snapsite format a30

select mowner, master, snapid,  nvl(r.snapsite, 'not registered') snapsite,to_char(snaptime,'DD-MON-YY HH24:MI:SS') snaptime from sys.slog$ s, sys.reg_snap$ r where  s.snapid=r.snapshot_id(+) and s.snaptime < (sysdate-&number_of_days);

