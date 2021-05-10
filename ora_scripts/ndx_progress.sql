declare
/* Name       :-    ndx-progress.sql */
/* DB Version :-    11.1.0.7  */
/* Author     :-    Sumit Bhatia */
/* Version    :-    1.1
/* Purpose    :-    To track the progress of index and find blocking sessions */
/* Input      :-    Sid of the session runing index rebuild */
/*declare local variables */
/*capture the session information*/
 mysid                v$session.sid%type;
 myserial             v$session.serial#%type;
 mylastcall           v$session.last_call_et%type;
 mymodule             v$session.module%type;
 mymachine            v$session.machine%type;
 myusername           v$session.username%type;
 myosuser             v$session.osuser%type;
 v_command            v$session.command%type;
 v_sql_id             v$session.sql_id%type;
 v_event              v$session.event%type;
 v_sql_text           v$sql.sql_text%type;
 v_cpu_time           v$sql.cpu_time%type;
 v_elapsed_time       v$sql.elapsed_time%type;
 v_table_name         dba_objects.object_name%type;
 v_index_name         dba_objects.object_name%type; 
 v_journal_name       dba_objects.object_name%type;
 v_journal_index      dba_objects.object_name%type; 
 v_index_id           dba_objects.object_id%type; 
 v_opname             v$session_longops.opname%type;
 v_table_owner        dba_objects.owner%type;
 v_index_owner        dba_objects.owner%type;
 v_total_waits        v$session_event.total_waits%type;
 v_total_timeouts     v$session_event.total_timeouts%type;
 v_time_waited        v$session_event.time_waited%type;
 v_average_wait       v$session_event.average_wait%type;
 v_max_wait           v$session_event.max_wait%type;
 
 
/*find if rebuilding or cleaning is in progress*/
 operation_id         number; 
 
/* longops details */
    longops_count        number; --find if session is there in longops
 
 
/*capture the current state*/ 
 status_id            number;
 event_id             number;
 opname_id            number;
 
/*Description of current stage*/
 stage                varchar2(4000);
 progress             varchar2(4000);
    
 
/* Parallel and Slave process tracking */ 
 
 parallel_id          number;    --to find if parallelism is used or not
    parallel_check       number;    --number of parallel process spawned by this sid as per longops
 slave_count          number;    --number of slave spawned as per px_session
 
/*journal table details*/
 count_journal        number; --to find number of rows in journal table
 
 
/* declare type variables to find for blocking and parallel sessions */
 type type_sid is table of v$session.sid%type;
 type type_serial is table of v$session.serial#%type;
 type type_status is table of v$session.status%type;
 type type_last_call_et is table of v$session.last_call_et%type;
 type type_command is table of v$session.command%type;
 type type_module is table of v$session.module%type;
 type type_machine is table of v$session.machine%type;
 type type_sql_id is table of v$session.sql_id%type;
 type type_prev_sql_id is table of v$session.prev_sql_id%type; 
 type type_event is table of v$session_wait.event%type;
 type type_opname is table of v$session_longops.opname%type;
 type type_sofar is table of v$session_longops.sofar%type;
 type type_totalwork is table of v$session_longops.totalwork%type;
 type type_time_remaining is table of v$session_longops.time_remaining%type;
 type type_elapsed_seconds is table of v$session_longops.elapsed_seconds%type;
 type type_degree is table of v$px_session.degree%type;
 type type_req_degree is table of v$px_session.req_degree%type;
 
 
/* declare blocking variables*/
 blocking_sid type_sid;
 blocking_serial type_serial;
 blocking_status type_status;
 blocking_last_call_et type_last_call_et;
 blocking_command type_command;
 blocking_module type_module;
 blocking_machine type_machine;
 blocking_sql_id type_sql_id;
 blocking_prev_sql_id type_prev_sql_id; 
 
 
 
 /* Declare slave process */
 slave_sid type_sid;
 slave_serial type_serial;
    slave_event type_event;
 slave_totalwork type_totalwork;
 slave_sofar type_sofar;
 slave_opname type_opname;
 slave_degree type_degree;
 slave_req_degree type_req_degree;
 slave_time_remaining type_time_remaining;
 slave_elapsed_seconds type_elapsed_seconds;
begin
/* initialize */
/* operation_id =0 -->index build in progress
   operation_id =1 -->index cleanup in progress
*/
/*
 parallel_id =0 -->no parallel
 parallel_id =1 -->parallel 1 clause used
 parallel_id =2 --> parallel clause being used
*/ 
/* 
   status_id =0    -->waiting for first latch
   status_id =1    -->first latch acquired and sequential read going on to merge journal table entries before FTS.
   status_id =2    -->FTS going on
   status_id =3    -->Sequential Read going on after FTS to merge journal table entries.
   status_id =4    -->Direct path read temp going on
   status_id =10   -->waiting for ending latch   
   status_id =11   -->parallel processing going on
*/
/*
  event_id =0      -->enq: TX - row lock contention
  event_id =1      -->db file scattered read
  event_id =2      -->db file sequential read
  event_id =3      -->direct path read temp
  event_id =11     -->PX Deq: Execute Reply
  event_id =100    -->others 
*/ 

/*
  opname_id =0    -->Not started
  opname_id =1    -->FULL Scan
  opname_id =2    -->Sort output
  opname_id =3    -->Operation completed
  opname_id =4    -->Row id Scan
  opname_id =100  -->others
  
*/
/* GATHER SESSION INFO AND SQL INFO */
  select sid,serial#,last_call_et,sql_id ,event,command,module,machine,username,osuser into mysid,myserial,mylastcall,v_sql_id,v_event,v_command,mymodule,mymachine,myusername,myosuser from v$session where sid=&sid;
  select sql_text,cpu_time,elapsed_time into v_sql_text,v_cpu_time,v_elapsed_time from v$sql where sql_id=v_sql_id and rownum<2;
  select count(*) into parallel_check from v$sql where sql_id=v_sql_id and upper(sql_text) like '% PARALLEL %';
  
/* check if index cleanup is running or index rebuild in running */
 
 if v_event<>'index (re)build online cleanup'
 then
  operation_id:=0;
 else
  operation_id:=1;
 end if; 
 /*if index rebuild is in progress then....*/
 if operation_id=0 
 then
  
  /*extract object info */
  select object_name ,substr(object_name,13) into v_journal_name,v_index_id from v$locked_object lo,dba_objects do,v$lock l where lo.OBJECT_ID = do.OBJECT_ID AND l.SID = lo.SESSION_ID and l.sid=mysid and object_name like '%SYS_JOURNAL%' group by object_name,substr(object_name,13);
  select object_name into v_table_name from v$locked_object lo,dba_objects do,v$lock l where lo.OBJECT_ID = do.OBJECT_ID AND l.SID = lo.SESSION_ID and l.sid=mysid and object_name not like '%SYS_JOURNAL%' group by object_name;
  select object_name,owner into v_index_name,v_index_owner from dba_objects where object_id=v_index_id;
  
  /*check if parallel processing is going on */
  if parallel_check=0 
  then
   parallel_id:=0;
  else
   parallel_id:=2;
  end if;
  
  /*print object info*/
      dbms_output.put_line(CHR(9));
   dbms_output.put_line('SID              ---->'||mysid);
   dbms_output.put_line('SERIAL           ---->'||myserial);
   dbms_output.put_line('MODULE           ---->'||mymodule);
   dbms_output.put_line('MACHINE          ---->'||mymachine);
   dbms_output.put_line('USERNAME         ---->'||myusername);
   dbms_output.put_line('OSUSER           ---->'||myosuser);
   dbms_output.put_line('SQL TEXT         ---->'||v_sql_text);
   dbms_output.put_line('SQL ID           ---->'||v_sql_id);
   dbms_output.put_line('JOURNAL NAME     ---->'||v_journal_name);
   dbms_output.put_line('TABLE NAME       ---->'||v_table_name);
   dbms_output.put_line('EVENT_NAME       ---->'||v_event);
   dbms_output.put_line('IDLE SINCE       ---->'||mylastcall);
   dbms_output.put_line('CPU TIME         ---->'||v_cpu_time);
   dbms_output.put_line('ELAPSED TIME     ---->'||v_elapsed_time);
   
  if parallel_id=0 /*no parallel is used */
  then
/*SECTION FOR NO PARALLEL*/  
   /*check if session is present in longops */
   select nvl(count(*),0) into longops_count from v$session_longops where sid=mysid and serial#=myserial and sql_id=v_sql_id;
   
   /*if session is present in longops capture its last operation */
   if longops_count>0
   then
    select  opname into v_opname from (select opname  from v$session_longops where sid=mysid and serial#=myserial and sql_id=v_sql_id order by opname) where rownum <2;
   else
    v_opname:='INDEX REBUILD NOT STARTED YET';
   end if;
   
   /*check event info*/
   if v_event='enq: TX - row lock contention'
   then
    event_id:=0;
   elsif v_event='db file scattered read'
   then 
    event_id:=1;
   elsif v_event='db file sequential read'
   then
    event_id:=2;
   elsif   v_event='direct path read temp'
   then
    event_id:=3;   
   else
    event_id:=100;
   end if; 
   
   
   /*Compute the operation stage*/
   if v_opname ='Table Scan' and event_id <>0       --scattered read going on
   then
    opname_id:=1;
   elsif v_opname='Sort Output' and event_id <> 0   --sort output going on
   then
    opname_id:=2;
   elsif v_opname ='Sort Output' and event_id =0    --sort output completed and waiting for last latch
   then
    opname_id:=3;
   elsif v_opname='INDEX REBUILD NOT STARTED YET' and event_id=0       --first latch not acquired
   then
    opname_id:=0;
   else
    opname_id:=100; 
   end if;
   
   execute immediate 'select count(*) from '||v_index_owner||'.'||v_journal_name into count_journal;
      dbms_output.put_line('JOURNAL COUNT    ---->'||count_journal);
   
   /* compute status*/
   if event_id=0 and opname_id>0 /*enq Tx row contention and there is entry into longops then its last latch */
   then
    status_id:=10;
    stage:='Operation completed.Waiting for ending latch';
    progress:='Tx started now will not cause any blocking or entry into journal table';
   elsif event_id=0 and opname_id=0
   then
    status_id:=0; /*enq Tx row contention and no entry into longops then its waiting for first latch */
    stage:='Waiting for first latch.';
   elsif event_id=1
   then
    status_id:=2;
    stage:='First latch acquired. FTS going on';
   elsif event_id=2
   then
        /* Check if session has already perfomred scattered reador not */
    select count(*) into longops_count from v$session_longops where sid=mysid and serial#=myserial and sql_id=v_sql_id and opname='Table Scan';
    
    /*if there is no scattered read then journal table is getting merged */
    if longops_count =0
    then
     status_id:=1;
     stage:='first latch acquired and sequential read going on to merge journal table entries before FTS.';
    /*else FTS completed and sequential read to merge journal entries captured during scattered read*/
    else
     status_id:=3;
     stage:='Sequential Read going on after FTS to merge journal table entries.';
    end if;
   elsif event_id =3
   then
    status_id:=4;
    stage:='First latch acquired.FTS and sequential read completed.Direct path read temp going on.';  
   elsif event_id=100
   then
    status_id:=10;
       stage:='waiting for other wait event';
   end if;
   
   /*check what happened to Transaction during index rebuild */
   if status_id=0 and count_journal=0
   then
    progress:='No Tx started after index rebuild has commited yet. There are 0 rows in journal table';
   elsif status_id=0 and count_journal >0
   then
    progress:='Few Tx started after index rebuild command have been commited and there is/are '||count_journal||' rows into journal table';
   elsif status_id=1 and count_journal=0
   then
    progress:='Completed merging journal table entries before starting scattered read';
   elsif status_id=1 and count_journal>0
   then
    progress:='merging journal table entries before starting scattered read. There are still '||count_journal||' rows to be merged';
   elsif status_id=2 and count_journal=0
   then
    progress:='No Tx commited since Scattered read started. 0 rows in journal table';
   elsif status_id=2 and count_journal>0
   then
    progress:='Tx have committed while scattered read going on.There are still '||count_journal||' rows to be merged once FTS complete.';
   elsif status_id=3 and count_journal=0
   then
    progress:='Merging of journal entries just completed after FTS.';
   elsif status_id=3 and count_journal>0
   then
    progress:='Merging of journal entries after FTS is going on.There are still '||count_journal||' rows to be merged once FTS complete.';
   elsif status_id=4 and count_journal=0
   then
    progress:=' Sorting going on. This is last step and there are 0 rows in journal table';
   elsif status_id=4 and count_journal>0
   then
    progress:=' Sorting going on. Some transactions have again committed during this and again have to do sequential read. Currently '|| count_journal|| ' rows in journal';
   elsif status_id=10 and count_journal=0
   then
    progress:=' Waiting for Tx to complete. Entries wont go into journal table now.';
   elsif status_id=10 and count_journal>0
   then
    progress:=' Waiting for Tx to complete. Currently '|| count_journal|| ' rows in journal';
   end if;
   
   /*print status info */
   dbms_output.put_line('STAGE            ---->'||stage);
   dbms_output.put_line('LONGOPS          ---->'||v_opname);
   dbms_output.put_line('PROGRESS         ---->'||progress);
   
   /*if first latch is not acquired then what sesisons are blocking it */
   if status_id=0
   then
    select 
     s.sid,s.serial#,s.status,s.last_call_et,s.command,s.module,s.machine,nvl(s.sql_id,'NONE'),NVL(s.prev_sql_id,'NONE') 
    bulk collect into 
     blocking_sid,blocking_serial,blocking_status,blocking_last_call_et,blocking_command,blocking_module,blocking_machine,blocking_sql_id,blocking_prev_sql_id
    from
     v$transaction t,v$session s
    where 
     t.addr=s.taddr
    and
     s.sid in 
     (
      select 
       l.sid 
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where 
             (l.type='TM' and l.lmode=3 )   
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name
      INTERSECT   
      select
       l.sid
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where   
       (l.type='TX' and l.lmode=6 )
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name    
      INTERSECT
      select
       l.sid
      from  
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type not in ('OD','DL') and l.lmode IN (4,3))
      and
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       (do.object_name=v_table_name)  
     )
    and 
    t.start_time < (select start_time from v$transaction,v$session where sid  = mysid and serial#=myserial and addr=taddr);
    dbms_output.put_line(CHR(9));
    dbms_output.put_line(CHR(9));
    dbms_output.put_line('------------SESSIONS BLOCKING FIRST LATCH ARE-------------');
    dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'STATUS'||CHR(9)||CHR(9)||'LAST_CALL_ET'||CHR(9)||CHR(9)||'COMMAND'||CHR(9)||CHR(9)||'SQL_ID'||CHR(9)||CHR(9)||'PREV_SQL_ID'||CHR(9)||CHR(9)||'MODULE'||CHR(9)||CHR(9)||'MACHINE');
    for i in blocking_sid.first ..blocking_sid.last 
    loop
     dbms_output.put_line(blocking_sid(i)||CHR(9)||blocking_serial(i)||CHR(9)||blocking_status(i)||CHR(9)||CHR(9)||blocking_last_call_et(i)||CHR(9)||CHR(9)||blocking_command(i)||CHR(9)||CHR(9)||blocking_sql_id(i)||CHR(9)||CHR(9)||blocking_prev_sql_id(i)||CHR(9)||CHR(9)||blocking_module(i)||CHR(9)||blocking_machine(i));
    end loop;
    
    /* check potential blockers for ending latch */
    
    select 
     s.sid,s.serial#,s.status,s.last_call_et,s.command,s.module,s.machine,nvl(s.sql_id,'NONE'),NVL(s.prev_sql_id,'NONE') 
    bulk collect into 
     blocking_sid,blocking_serial,blocking_status,blocking_last_call_et,blocking_command,blocking_module,blocking_machine,blocking_sql_id,blocking_prev_sql_id
    from
     v$transaction t,v$session s
    where 
     t.addr=s.taddr
    and
     s.sid in 
     (
      select 
       l.sid 
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type='TM' and l.lmode=3 )   
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and 
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name
      INTERSECT   
      select
       l.sid
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where   
       (l.type='TX' and l.lmode=6 )
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name    
      INTERSECT
      select
       l.sid
      from  
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type not in ('OD','DL') and l.lmode IN (4,3))
      and
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       (do.object_name=v_table_name)  
     )
    and 
    t.start_time > (select start_time from v$transaction,v$session where sid  = mysid and serial#=myserial and addr=taddr)
    and s.last_call_et > 300;
     
     /*INNER BLOCK for exception handling */
     BEGIN
      dbms_output.put_line(CHR(9));
      dbms_output.put_line(CHR(9));
      dbms_output.put_line('------------SESSIONS THAT MAY BLOCK LAST LATCH ARE-------------');
      dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'STATUS'||CHR(9)||CHR(9)||'LAST_CALL_ET'||CHR(9)||CHR(9)||'COMMAND'||CHR(9)||CHR(9)||'SQL_ID'||CHR(9)||CHR(9)||'PREV_SQL_ID'||CHR(9)||CHR(9)||'MODULE'||CHR(9)||CHR(9)||'MACHINE');
      for i in blocking_sid.first ..blocking_sid.last 
      loop
       dbms_output.put_line(blocking_sid(i)||CHR(9)||blocking_serial(i)||CHR(9)||blocking_status(i)||CHR(9)||CHR(9)||blocking_last_call_et(i)||CHR(9)||CHR(9)||blocking_command(i)||CHR(9)||CHR(9)||blocking_sql_id(i)||CHR(9)||CHR(9)||blocking_prev_sql_id(i)||CHR(9)||CHR(9)||blocking_module(i)||CHR(9)||blocking_machine(i));
       dbms_output.put_line(CHR(9));
       dbms_output.put_line(CHR(9));
      end loop;
     EXCEPTION
     WHEN OTHERS THEN
         dbms_output.put_line(CHR(9));
      dbms_output.put_line('NO POTENTIAL BLOCKERS FOUND FOR THE LAST LATCH');
      dbms_output.put_line(CHR(9));
      dbms_output.put_line(CHR(9));
     END;                   
   elsif status_id=10
   then
    select 
     s.sid,s.serial#,s.status,s.last_call_et,s.command,s.module,s.machine,nvl(s.sql_id,'NONE'),NVL(s.prev_sql_id,'NONE') 
    bulk collect into 
     blocking_sid,blocking_serial,blocking_status,blocking_last_call_et,blocking_command,blocking_module,blocking_machine,blocking_sql_id,blocking_prev_sql_id
    from
     v$transaction t,v$session s
    where 
     t.addr=s.taddr
    and
     s.sid in 
     (
      select 
       l.sid 
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type='TM' and l.lmode=3 )   
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and 
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name
      INTERSECT   
      select
       l.sid
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where   
       (l.type='TX' and l.lmode=6 )
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name    
      INTERSECT
      select
       l.sid
      from  
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type not in ('OD','DL') and l.lmode IN (4,3))
      and
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       (do.object_name=v_table_name)  
     )
    and 
    t.start_time > (select start_time from v$transaction,v$session where sid  = mysid and serial#=myserial and addr=taddr);    
    dbms_output.put_line(CHR(9));
    dbms_output.put_line(CHR(9));
    dbms_output.put_line('------------SESSIONS BLOCKING LAST LATCH ARE-------------');
    dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'STATUS'||CHR(9)||CHR(9)||'LAST_CALL_ET'||CHR(9)||CHR(9)||'COMMAND'||CHR(9)||CHR(9)||'SQL_ID'||CHR(9)||CHR(9)||'PREV_SQL_ID'||CHR(9)||CHR(9)||'MODULE'||CHR(9)||CHR(9)||'MACHINE');
    for i in blocking_sid.first ..blocking_sid.last 
    loop
     dbms_output.put_line(blocking_sid(i)||CHR(9)||blocking_serial(i)||CHR(9)||blocking_status(i)||CHR(9)||CHR(9)||blocking_last_call_et(i)||CHR(9)||CHR(9)||blocking_command(i)||CHR(9)||CHR(9)||blocking_sql_id(i)||CHR(9)||CHR(9)||blocking_prev_sql_id(i)||CHR(9)||CHR(9)||blocking_module(i)||CHR(9)||blocking_machine(i));
    end loop;    
   end if;
/* NO PARALLEL SECTION ENDS HERE */   
  else
/* SECTION FOR PARALLEL PROCESSING STARTED  */  
   /*check event info of parallel process*/
   if v_event='enq: TX - row lock contention'
   then
    event_id:=0;
   elsif v_event='db file scattered read' /*this event will only occur if parallel 1 is used */
   then 
    event_id:=1;
   elsif v_event='db file sequential read'
   then
    event_id:=2;
   elsif   v_event='direct path read temp'
   then
    event_id:=3;   
   elsif   v_event='PX Deq: Execute Reply'
   then
    event_id:=11;   
   else
    event_id:=100;
   end if; 
   
   execute immediate 'select count(*) from '||v_index_owner||'.'||v_journal_name into count_journal;
   dbms_output.put_line('JOURNAL COUNT    ---->'||count_journal);
   
   if event_id=0  /*in case of enq Tx contention */
   then
    /*check if child process is present in in longops or not */
    select count(*) into longops_count from v$session_longops where qcsid=mysid and sql_id=v_sql_id;
    
    if longops_count > 0 /*if there were child slaves earlier then its waiting on last latch */
    then
     status_id:=10;
     stage:='Operation completed.Waiting for ending latch';
    else
     select count(*) into longops_count from v$session_longops where sid=mysid and serial#=myserial and sql_id=v_sql_id; /*check if paralel 1 clause being used */
      if longops_count > 0
      then
       status_id:=10;
       stage:='Operation completed.Waiting for ending latch';
      else
          status_id:=0;
       stage:='Waiting for first latch.';
      end if;
    end if;
   elsif event_id=1
   then
    status_id:=2;
    stage:='Parallel 1 clause being used. Scattered read going on';
   elsif event_id=2
   then
    select count(*) into longops_count from v$session_longops where qcsid=mysid and sql_id=v_sql_id; /*if there were child earlier it means its merging journal after FTS*/
    if longops_count > 0
    then
     status_id:=3;
     stage:='Sequential Read going on for merging journal table entries after FTS';
    else
     select count(*) into longops_count from v$session_longops where sid=mysid and serial#=myserial and sql_id=v_sql_id; 
     if longops_count > 0
      then
       status_id:=3;
       stage:='Parallel 1 clause used. Sequential Read going on to merge journal table entries after FTS';
     else
          status_id:=0;
       stage:='Sequential Read going on to merge journal entries before FTS.';
     end if;
    end if;
   elsif event_id=3
   then
    status_id:=4;
    stage:='Direct Path read temp going on after merging journal table entries';
   elsif event_id=11
   then
    status_id:=11;
    stage:='First Latch acquired.Parallel Processing going on'; 
   end if; 
   
   /* Check the progress*/
   if status_id=0 and count_journal=0
   then
    progress:='No Tx started after index rebuild has commited yet. There are 0 rows in journal table';
   elsif status_id=0 and count_journal >0
   then
    progress:='Few Tx started after index rebuild command have been commited and there is/are '||count_journal||' rows into journal table';
   elsif status_id=1 and count_journal=0
   then
    progress:='Completed merging journal table entries before starting scattered read';
   elsif status_id=1 and count_journal>0
   then
    progress:='merging journal table entries before starting scattered read. There are still '||count_journal||' rows to be merged';
   elsif status_id=2 and count_journal=0
   then
    progress:='No Tx commited since Scattered read started. 0 rows in journal table';
   elsif status_id=2 and count_journal>0
   then
    progress:='Tx have committed while scattered read going on.There are still '||count_journal||' rows to be merged once FTS complete.';
   elsif status_id=3 and count_journal=0
   then
    progress:='Merging of journal entries just completed after FTS';
   elsif status_id=3 and count_journal>0
   then
    progress:='Merging of journal entries after FTS is going on.There are still '||count_journal||' rows to be merged once FTS complete.';
   elsif status_id=4 and count_journal=0
   then
    progress:=' Sorting going on. This is last step and there are 0 rows in journal table';
   elsif status_id=4 and count_journal>0
   then
    progress:=' Sorting going on. Some transactions have again committed during this and again have to do sequential read. Currently '|| count_journal|| ' rows in journal';
   elsif status_id=10 and count_journal=0
   then
    progress:=' Waiting for Tx to complete. Entries wont go into journal table now.';
   elsif status_id=10 and count_journal>0
   then
    progress:=' Waiting for Tx to complete. Currently '|| count_journal|| ' rows in journal';
   elsif status_id=11 and count_journal=0
   then
    progress:=' check slave process opname for current status';
   elsif status_id=11 and count_journal>0
   then
    progress:=' check slave process opname for current status. Few Tx hhave again commited while parallel proceesing going on. Currently '|| count_journal|| ' rows in journal';
   end if;
   
   dbms_output.put_line('STAGE            ---->'||stage);
   dbms_output.put_line('PROGRESS         ---->'||progress);
   
   /* Check the locking */
   if status_id=0
   then
    select 
     s.sid,s.serial#,s.status,s.last_call_et,s.command,s.module,s.machine,nvl(s.sql_id,'NONE'),NVL(s.prev_sql_id,'NONE') 
    bulk collect into 
     blocking_sid,blocking_serial,blocking_status,blocking_last_call_et,blocking_command,blocking_module,blocking_machine,blocking_sql_id,blocking_prev_sql_id
    from
     v$transaction t,v$session s
    where 
     t.addr=s.taddr
    and
     s.sid in 
     (
      select 
       l.sid 
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where 
             (l.type='TM' and l.lmode=3 )   
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name
      INTERSECT   
      select
       l.sid
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where   
       (l.type='TX' and l.lmode=6 )
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name    
      INTERSECT
      select
       l.sid
      from  
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type not in ('OD','DL') and l.lmode IN (4,3))
      and
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       (do.object_name=v_table_name)  
     )
    and 
    t.start_time < (select start_time from v$transaction,v$session where sid  = mysid and serial#=myserial and addr=taddr);
    dbms_output.put_line(CHR(9));
    dbms_output.put_line(CHR(9));
    dbms_output.put_line('------------SESSIONS BLOCKING FIRST LATCH ARE-------------');
    dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'STATUS'||CHR(9)||CHR(9)||'LAST_CALL_ET'||CHR(9)||CHR(9)||'COMMAND'||CHR(9)||CHR(9)||'SQL_ID'||CHR(9)||CHR(9)||'PREV_SQL_ID'||CHR(9)||CHR(9)||'MODULE'||CHR(9)||CHR(9)||'MACHINE');
    for i in blocking_sid.first ..blocking_sid.last 
    loop
     dbms_output.put_line(blocking_sid(i)||CHR(9)||blocking_serial(i)||CHR(9)||blocking_status(i)||CHR(9)||CHR(9)||blocking_last_call_et(i)||CHR(9)||CHR(9)||blocking_command(i)||CHR(9)||CHR(9)||blocking_sql_id(i)||CHR(9)||CHR(9)||blocking_prev_sql_id(i)||CHR(9)||CHR(9)||blocking_module(i)||CHR(9)||blocking_machine(i));
    end loop;
    
    /* check potential blockers for ending latch */
    
    select 
     s.sid,s.serial#,s.status,s.last_call_et,s.command,s.module,s.machine,nvl(s.sql_id,'NONE'),NVL(s.prev_sql_id,'NONE') 
    bulk collect into 
     blocking_sid,blocking_serial,blocking_status,blocking_last_call_et,blocking_command,blocking_module,blocking_machine,blocking_sql_id,blocking_prev_sql_id
    from
     v$transaction t,v$session s
    where 
     t.addr=s.taddr
    and
     s.sid in 
     (
      select 
       l.sid 
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type='TM' and l.lmode=3 )   
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and 
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name
      INTERSECT   
      select
       l.sid
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where   
       (l.type='TX' and l.lmode=6 )
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name    
      INTERSECT
      select
       l.sid
      from  
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type not in ('OD','DL') and l.lmode IN (4,3))
      and
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       (do.object_name=v_table_name)  
     )
    and 
    t.start_time > (select start_time from v$transaction,v$session where sid  = mysid and serial#=myserial and addr=taddr)
    and s.last_call_et > 300;
     
     /*INNER BLOCK for exception handling */
     BEGIN
      dbms_output.put_line(CHR(9));
      dbms_output.put_line(CHR(9));
      dbms_output.put_line('------------SESSIONS THAT MAY BLOCK LAST LATCH ARE-------------');
      dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'STATUS'||CHR(9)||CHR(9)||'LAST_CALL_ET'||CHR(9)||CHR(9)||'COMMAND'||CHR(9)||CHR(9)||'SQL_ID'||CHR(9)||CHR(9)||'PREV_SQL_ID'||CHR(9)||CHR(9)||'MODULE'||CHR(9)||CHR(9)||'MACHINE');
      for i in blocking_sid.first ..blocking_sid.last 
      loop
       dbms_output.put_line(blocking_sid(i)||CHR(9)||blocking_serial(i)||CHR(9)||blocking_status(i)||CHR(9)||CHR(9)||blocking_last_call_et(i)||CHR(9)||CHR(9)||blocking_command(i)||CHR(9)||CHR(9)||blocking_sql_id(i)||CHR(9)||CHR(9)||blocking_prev_sql_id(i)||CHR(9)||CHR(9)||blocking_module(i)||CHR(9)||blocking_machine(i));
       dbms_output.put_line(CHR(9));
       dbms_output.put_line(CHR(9));
      end loop;
     EXCEPTION
     WHEN OTHERS THEN
         dbms_output.put_line(CHR(9));
      dbms_output.put_line('NO POTENTIAL BLOCKERS FOUND FOR THE LAST LATCH');
      dbms_output.put_line(CHR(9));
      dbms_output.put_line(CHR(9));
     END;
   elsif status_id=10
   then
    select 
     s.sid,s.serial#,s.status,s.last_call_et,s.command,s.module,s.machine,nvl(s.sql_id,'NONE'),NVL(s.prev_sql_id,'NONE') 
    bulk collect into 
     blocking_sid,blocking_serial,blocking_status,blocking_last_call_et,blocking_command,blocking_module,blocking_machine,blocking_sql_id,blocking_prev_sql_id
    from
     v$transaction t,v$session s
    where 
     t.addr=s.taddr
    and
     s.sid in 
     (
      select 
       l.sid 
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type='TM' and l.lmode=3 )   
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and 
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name
      INTERSECT   
      select
       l.sid
      from 
       v$locked_object lo,dba_objects do,v$lock l
      where   
       (l.type='TX' and l.lmode=6 )
      and 
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       do.object_name=v_table_name    
      INTERSECT
      select
       l.sid
      from  
       v$locked_object lo,dba_objects do,v$lock l
      where 
       (l.type not in ('OD','DL') and l.lmode IN (4,3))
      and
       lo.OBJECT_ID = do.OBJECT_ID
      and
       l.SID = lo.SESSION_ID
      and
       (do.object_name=v_table_name)  
     )
    and 
    t.start_time > (select start_time from v$transaction,v$session where sid  = mysid and serial#=myserial and addr=taddr);    
    dbms_output.put_line(CHR(9));
    dbms_output.put_line(CHR(9));
    dbms_output.put_line('------------SESSIONS BLOCKING LAST LATCH ARE-------------');
    dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'STATUS'||CHR(9)||CHR(9)||'LAST_CALL_ET'||CHR(9)||CHR(9)||'COMMAND'||CHR(9)||CHR(9)||'SQL_ID'||CHR(9)||CHR(9)||'PREV_SQL_ID'||CHR(9)||CHR(9)||'MODULE'||CHR(9)||CHR(9)||'MACHINE');
    for i in blocking_sid.first ..blocking_sid.last 
    loop
     dbms_output.put_line(blocking_sid(i)||CHR(9)||blocking_serial(i)||CHR(9)||blocking_status(i)||CHR(9)||CHR(9)||blocking_last_call_et(i)||CHR(9)||CHR(9)||blocking_command(i)||CHR(9)||CHR(9)||blocking_sql_id(i)||CHR(9)||CHR(9)||blocking_prev_sql_id(i)||CHR(9)||CHR(9)||blocking_module(i)||CHR(9)||blocking_machine(i));
    end loop;
   elsif status_id=11
   then
    select p.sid,p.serial#,p.degree,p.req_degree,s.event bulk collect into slave_sid,slave_serial,slave_degree,slave_req_degree,slave_event from v$px_session p,v$session s where p.qcsid=mysid and p.sid<>mysid and p.sid=s.sid and p.serial#=s.serial#;
    dbms_output.put_line(CHR(9));
    dbms_output.put_line(CHR(9));
    dbms_output.put_line('------------TOTAL SLAVES ARE-------------');
    dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'DEGREE'||CHR(9)||CHR(9)||'REQ_DEGREE'||CHR(9)||CHR(9)||'EVENT');
    
    for i in slave_sid.first ..slave_sid.last 
    loop
     dbms_output.put_line(slave_sid(i)||CHR(9)||slave_serial(i)||CHR(9)||slave_degree(i)||CHR(9)||CHR(9)||slave_req_degree(i)||CHR(9)||CHR(9)||slave_event(i));
    end loop;    
    
/*    select count(*) into parallel_count from v$session_longops where qcsid=mysid and sql_id=v_sql_id; */
    select count(*) into longops_count from v$session_longops where qcsid=mysid and sql_id=v_sql_id; 
    
    BEGIN
     if longops_count=0
     then
       dbms_output.put_line('------------NO ENTRY IN LONGOPS YET FOR ANY SLAVE PROCESS-------------');
     else
      select l.sid,l.serial#,l.opname,l.totalwork,l.sofar,nvl(l.time_remaining,-100),nvl(l.elapsed_seconds,-100),s.event bulk collect into slave_sid,slave_serial,slave_opname,slave_totalwork,slave_sofar,slave_time_remaining,slave_elapsed_seconds,slave_event from v$session_longops l,v$session s where l.qcsid=mysid and l.qcsid<>l.sid and l.sql_id=v_sql_id and l.sofar<>l.totalwork and l.sid=s.sid and l.serial#=s.serial# and l.sid in (select sid from v$px_session);
      dbms_output.put_line(CHR(9));
      dbms_output.put_line(CHR(9));
      dbms_output.put_line('------------LONGOPS SLAVES ARE-------------');
      dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'TOTALWORK'||CHR(9)||CHR(9)||'SOFAR'||CHR(9)||CHR(9)||'TIME REMAINING'||CHR(9)||CHR(9)||CHR(9)||'ELAPSED SECONDS'||CHR(9)||CHR(9)||'OPNAME'||CHR(9)||CHR(9)||CHR(9)||'EVENT');
    
      for i in slave_sid.first ..slave_sid.last 
      loop
       dbms_output.put_line(slave_sid(i)||CHR(9)||slave_serial(i)||CHR(9)||slave_totalwork(i)||CHR(9)||CHR(9)||CHR(9)||slave_sofar(i)||CHR(9)||CHR(9)||slave_time_remaining(i)||CHR(9)||CHR(9)||CHR(9)||CHR(9)||slave_elapsed_seconds(i)||CHR(9)||CHR(9)||CHR(9)||slave_opname(i)||CHR(9)||CHR(9)||slave_event(i));
      end loop;    
     end if;
     EXCEPTION
     WHEN OTHERS THEN
      dbms_output.put_line('------------NO ENTRY IN LONGOPS YET FOR ANY SLAVE PROCESS-------------');
     end;
   end if;
  /* parallel */ 
  end if;
/*PARALLEL PROCESSING SECTION ENDS HERE */  
 else
/* SECTION FOR INDEX CLEANUP */ 
  /* In case its a cleaning process*/
  dbms_output.put_line('Index Rebuild has been cancelled. Cleaning going on');
  select o.object_name,i.index_name,i.owner,o.owner into v_table_name,v_index_name,v_index_owner,v_table_owner from dba_indexes i,dba_objects o,v$locked_object l,dba_tables t where o.object_name = t.table_name and o.object_id = l.object_id and i.table_name=t.table_name and session_id=mysid;
  select serial#,sql_id,event into myserial,v_sql_id,v_event from v$session where sid=mysid;
  select sql_text into v_sql_text from v$sql where sql_id=v_sql_id and rownum<2;
  select 'SYS_JOURNAL_'||object_id into v_journal_name from dba_objects where object_name=v_index_name;
  execute immediate 'select count(*) from '||v_index_owner||'.'||v_journal_name into count_journal;
   dbms_output.put_line('SID              ---->'||mysid);
   dbms_output.put_line('SERIAL           ---->'||myserial);
   dbms_output.put_line('MODULE           ---->'||mymodule);
   dbms_output.put_line('MACHINE          ---->'||mymachine);
   dbms_output.put_line('USERNAME         ---->'||myusername);
   dbms_output.put_line('OSUSER           ---->'||myosuser);
   dbms_output.put_line('SQL TEXT         ---->'||v_sql_text);
   dbms_output.put_line('SQL ID           ---->'||v_sql_id);
   dbms_output.put_line('JOURNAL NAME     ---->'||v_journal_name);
   dbms_output.put_line('TABLE NAME       ---->'||v_table_name);
   dbms_output.put_line('EVENT_NAME       ---->'||v_event);
   dbms_output.put_line('IDLE SINCE       ---->'||mylastcall);
   dbms_output.put_line('CPU TIME         ---->'||v_cpu_time);
   dbms_output.put_line('ELAPSED TIME     ---->'||v_elapsed_time);
   dbms_output.put_line('JOURNAL COUNT    ---->'||count_journal);
    
  select 
   s.sid,s.serial#,s.status,s.last_call_et,s.command,s.module,s.machine,nvl(s.sql_id,'NONE'),NVL(s.prev_sql_id,'NONE') 
  bulk collect into 
   blocking_sid,blocking_serial,blocking_status,blocking_last_call_et,blocking_command,blocking_module,blocking_machine,blocking_sql_id,blocking_prev_sql_id
  from
   v$transaction t,v$session s
  where 
   t.addr=s.taddr
  and
   s.sid in 
     (
      select
       l.session_id
      from
       dba_indexes i,dba_objects o,v$locked_object l,dba_tables t
      where 
       o.object_name = t.table_name
      and 
       i.index_name =v_index_name
      and 
       i.owner = v_index_owner
      and 
       o.owner= v_table_owner
      and 
       o.object_id = l.object_id
      and 
       i.table_name=t.table_name
     );
  /*INNER BLOCK for exception handling */
  BEGIN
   dbms_output.put_line(CHR(9));
   dbms_output.put_line(CHR(9));
   dbms_output.put_line('------------SESSIONS BLOCKING CLEANING PROCESS-------------');
   dbms_output.put_line('SID'||CHR(9)||'SERIAL'||CHR(9)||'STATUS'||CHR(9)||CHR(9)||'LAST_CALL_ET'||CHR(9)||CHR(9)||'COMMAND'||CHR(9)||CHR(9)||'SQL_ID'||CHR(9)||CHR(9)||'PREV_SQL_ID'||CHR(9)||CHR(9)||'MODULE'||CHR(9)||CHR(9)||'MACHINE');   
       
   for i in blocking_sid.first ..blocking_sid.last 
    loop
     dbms_output.put_line(blocking_sid(i)||CHR(9)||blocking_serial(i)||CHR(9)||blocking_status(i)||CHR(9)||CHR(9)||blocking_last_call_et(i)||CHR(9)||CHR(9)||blocking_command(i)||CHR(9)||CHR(9)||blocking_sql_id(i)||CHR(9)||CHR(9)||blocking_prev_sql_id(i)||CHR(9)||CHR(9)||blocking_module(i)||CHR(9)||blocking_machine(i));
     dbms_output.put_line(CHR(9));
    end loop;
   select event,total_waits,total_timeouts,time_waited,average_wait,max_wait into v_event,v_total_waits,v_total_timeouts,v_time_waited,v_average_wait,v_max_wait from v$session_event where sid=mysid and event='index (re)build online cleanup';
   dbms_output.put_line(chr(9));
   dbms_output.put_line('------------CLEANUP PROCESS TIMOUT-------------');
   dbms_output.put_line('EVENT'||CHR(9)||CHR(9)||CHR(9)||CHR(9)||chr(9)||'TOTAL WAITS'||CHR(9)||CHR(9)||'TOTAL TIMEOUTS'||CHR(9)||CHR(9)||'TIME WAITED'||CHR(9)||CHR(9)||'AVG WAIT'||CHR(9)||CHR(9)||'MAX WAIT');
      dbms_output.put_line(v_event||CHR(9)||CHR(9)||v_total_waits||CHR(9)||CHR(9)||CHR(9)||v_total_timeouts||CHR(9)||CHR(9)||CHR(9)||v_time_waited||CHR(9)||CHR(9)||CHR(9)||v_average_wait||CHR(9)||CHR(9)||CHR(9)||v_max_wait);
  EXCEPTION
   WHEN OTHERS THEN
    dbms_output.put_line(CHR(9));
    dbms_output.put_line('NO POTENTIAL BLOCKERS FOUND. Cleaning GOING ON SMOOTHLY');
    dbms_output.put_line(CHR(9));
    dbms_output.put_line(CHR(9));
  END;  
 end if;
 dbms_output.put_line(CHR(9)); 
EXCEPTION
 WHEN OTHERS THEN
 dbms_output.put_line(CHR(9)); 
 dbms_output.put_line('UNKNOWN CONDITION. CHECK IF JOB COMPLETES.');
 dbms_output.put_line(CHR(9));  
end;
/ 
