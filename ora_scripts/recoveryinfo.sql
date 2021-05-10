set lines 500
select usn, state, undoblockstotal "Total", undoblocksdone "Done", undoblockstotal-undoblocksdone "ToDo", undoblocksdone / undoblockstotal * 100 "Pct Done",
             decode(cputime,0,'unknown',sysdate+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400)) 
              "Estimated time to complete",pid ,xid transaction_id,pxid parent_pid 
   from v$fast_start_transactions; 

Prompt Internal Info
  select ktuxeusn, to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Time", ktuxesiz, ktuxesta 
   from x$ktuxe 
   where ktuxecfl = 'DEAD'; 

Prompt No. of processes performing recovery
select * from v$fast_start_servers; 
