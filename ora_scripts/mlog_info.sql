column log format a35
col oldest for a20
col youngest for a20

select mowner,log, to_char(least(oldest,oldest_pk),'DD-MON-YY HH24:MI:SS')oldest,to_char(youngest,'DD-MON-YY HH24:MI:SS')youngest,to_char(mtime,'DD-MON-YY HH24:MI:SS')mtime from sys.mlog$ where mowner like upper('&owner_name') and master like upper('%&table_name%');