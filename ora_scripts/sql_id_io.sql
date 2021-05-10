select
       plan_hash_value,
       child_number,
       executions,
       PX_SERVERS_EXECUTIONS pxe,
       cpu_time/1000 cpu_ms,
       elapsed_time/1000 ela_ms,
       (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_ela,
       IO_INTERCONNECT_BYTES/1024/1024/1024 io_inter_gb,
       PHYSICAL_READ_BYTES/1024/1024/1024 PHYSICAL_READ_GB,
      PHYSICAL_READ_BYTES/1024/1024/decode(nvl(executions,0),0,1,executions) PIO_MB_PE,
      buffer_gets/decode(nvl(executions,0),0,1,executions) LIOS_PE,
      disk_reads/decode(nvl(executions,0),0,1,executions) PIOS_PE
   from
      v$sql
   where
      sql_id = ('&sql_id')
   order BY
      sql_id,
      plan_hash_value,
    child_number
    /
