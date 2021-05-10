set serveroutput on
declare
  banner           VARCHAR2(64);
  c1               sys_refcursor;
  cpus             NUMBER;
  db_name          VARCHAR2(9);
  def_servers_max  NUMBER;
  granule_size     NUMBER;
  large_pool       NUMBER;
  large_pool_abs   NUMBER;
  large_pool_asmm  NUMBER;
  large_pool_smax  NUMBER;
  large_pool_smin  NUMBER;
  lp_servers       NUMBER;
  mfactor          NUMBER;
  min_msg_pool     NUMBER;
  msg_size         NUMBER;
  nam              VARCHAR2(512);
  parbuf_hwm       NUMBER;
  parbuf_hwm_mem   NUMBER;
  pga_agg          NUMBER;
  ptpcpu           NUMBER;
  servers_max      NUMBER;
  servers_min      NUMBER;
  sga_tgt          NUMBER;
  subpools         NUMBER;
  use_lp           VARCHAR2(5);
  val              VARCHAR2(512);
begin
  /* Get db ID */
  select distinct NAME into db_name from v$database;
  select distinct BANNER into banner from V$version where banner like 'Oracle Database%';
  /* Get 10.2-11.1 parameters */
  open c1 for select nam.ksppinm NAME, val.KSPPSTVL VALUE from x$ksppi nam, x$ksppsv val where nam.indx = val.indx and nam.ksppinm in ('_PX_use_large_pool','_kghdsidx_count','_ksmg_granule_size','_parallel_min_message_pool','cpu_count','large_pool_size','parallel_execution_message_size','parallel_max_servers','parallel_min_servers','parallel_threads_per_cpu','pga_aggregate_target','sga_target') order by 1;
  fetch c1 into nam, val;
  use_lp          := val;
  fetch c1 into nam, val;
  subpools        := val;
  fetch c1 into nam, val;
  granule_size    := val;
  fetch c1 into nam, val;
  min_msg_pool     :=val;
  fetch c1 into nam, val;
  cpus            := val;
  fetch c1 into nam, val;
  large_pool      := val;
  fetch c1 into nam, val;
  msg_size        := val;
  fetch c1 into nam, val;
  servers_max     := val;
  fetch c1 into nam, val;
  servers_min     := val;
  fetch c1 into nam, val;
  ptpcpu          := val;
  fetch c1 into nam, val;
  pga_agg         := val;
  fetch c1 into nam, val;
  sga_tgt         := val;
  close c1;
  /* Get Parallel processing statistics */
  open c1 for select value from v$px_process_sysstat where statistic like 'Buffers HWM%';
  fetch c1 into val;
  parbuf_hwm      := val;
  close c1;
  /* Get dynamic settings */
  open c1 for select current_size from v$sga_dynamic_components where component = 'large pool';
  fetch c1 into val;
  large_pool_asmm := val;
  close c1;
  /* Perform calculations and display results */
  dbms_output.put_line('10gR2: CALCULATIONS for the LARGE_POOL_SIZE with Parallel processing.');
  dbms_output.put_line('Version 1.0, 2012.');
  dbms_output.put_line('Database Identification:');
  dbms_output.put_line('The database name is ' || db_name || '.');
  dbms_output.put_line('Version: ' || banner );
  dbms_output.put_line('LARGE_POOL_SIZE:');
  large_pool := large_pool/1024/1024;
  dbms_output.put_line('The initial setting is ' || large_pool || 'Mb.');
  if large_pool = 0 then
     dbms_output.put('If set, the ');
  else
     dbms_output.put('The ');
  end if;
  large_pool_abs := (granule_size * subpools)/1024/1024;
  dbms_output.put_line('absolute minimum is ' || large_pool_abs || 'Mb (a lower non-0 value is over-ridden).');
  large_pool_asmm := large_pool_asmm/1024/1024;
  if sga_tgt > 0 then
     dbms_output.put_line('The current dynamic size is ' || large_pool_asmm || 'Mb.');
  end if;
  /* Parallel processing */
  dbms_output.put_line('Parallel Processing:');
  if servers_min > 0 then
     large_pool_smin := (granule_size * (servers_min + 2))/1024/1024; /* From unpublished Bug 13096841 */
     dbms_output.put_line('For parallel_min_servers=' || servers_min || ', the minimum Large Pool is ' || large_pool_smin || 'Mb.');
  else
     dbms_output.put_line('The parallel_min_servers setting is 0.');
  end if;
  /* Calculate the default for parallel_max_servers */
  /* 10.2 Data Warehousing formula: (CPU_COUNT x PARALLEL_THREADS_PER_CPU x (2 if PGA_AGGREGATE_TARGET > 0; otherwise 1) x 5) */
  if pga_agg > 0 then
     mfactor := 10;
  else
     mfactor := 5;
  end if;
  def_servers_max := cpus * ptpcpu * mfactor;
  /* Calculate Large Pool usage (theoretical) */
  if servers_max > 0 then
     lp_servers := servers_max;
  else
     lp_servers := def_servers_max;
  end if;
  large_pool_smax := (granule_size * lp_servers)/1024/1024/2; /* assume 2 servers use 1 granule */
  if servers_max > 0 then
     dbms_output.put('For parallel_max_servers=' || servers_max );
  else
     dbms_output.put_line('No Parallelism because parallel_max_servers=0.');
     dbms_output.put('If enabled');
  end if;
  dbms_output.put_line(', the Large Pool may grow to ' || large_pool_smax || 'Mb.');
  dbms_output.put_line('The DEFAULT for parallel_max_servers is ' || def_servers_max || '.');
  /* Additional PX information */
  dbms_output.put_line('Additional:');
  dbms_output.put('This instance will put the "PX msg pool" allocation in the ');
  if sga_tgt = 0 and use_lp != 'TRUE' then
     dbms_output.put_line('Shared Pool.');
  else
     dbms_output.put_line('Large Pool.');
  end if;
  if min_msg_pool > 0 then
     dbms_output.put_line('The initial size of the "PX msg pool" allocation is ' || min_msg_pool || ' bytes.');
  end if;
  if parbuf_hwm > 0 then
     dbms_output.put_line('The Parallel Buffers High Water Mark is ' || parbuf_hwm || ' buffers,');
     parbuf_hwm_mem := parbuf_hwm * msg_size;
     dbms_output.put_line('that required ' || parbuf_hwm_mem || ' bytes of memory.');
  else
     dbms_output.put_line('No Parallel Buffers High Water Mark detected.');
  end if;
end;
/

