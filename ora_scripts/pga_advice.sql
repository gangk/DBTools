1- Make a first estimate for PGA_AGGREGATE_TARGET  based on the following rule 

         - For OLTP systems 

   PGA_AGGREGATE_TARGET  = (<Total Physical Memory > * 80%) * 20%


          - For DSS systems 

   PGA_AGGREGATE_TARGET  = (<Total Physical Memory > * 80%) * 50%



SELECT LOW_OPTIMAL_SIZE/1024 low_kb,(HIGH_OPTIMAL_SIZE+1)/1024 high_kb,
       optimal_executions, onepass_executions, multipasses_executions
FROM   v$sql_workarea_histogram
WHERE  total_executions != 0;






SELECT optimal_count, round(optimal_count*100/total, 2) optimal_perc,
       onepass_count, round(onepass_count*100/total, 2) onepass_perc,
       multipass_count, round(multipass_count*100/total, 2) multipass_perc
FROM
       (SELECT decode(sum(total_executions), 0, 1, sum(total_executions)) total,
               sum(OPTIMAL_EXECUTIONS) optimal_count,
               sum(ONEPASS_EXECUTIONS) onepass_count,
               sum(MULTIPASSES_EXECUTIONS) multipass_count
        FROM   v$sql_workarea_histogram
        WHERE  low_optimal_size > 64*1024);   



SELECT to_number(decode(SID, 65535, NULL, SID)) sid,
       operation_type OPERATION,trunc(EXPECTED_SIZE/1024) ESIZE,
       trunc(ACTUAL_MEM_USED/1024) MEM, trunc(MAX_MEM_USED/1024) "MAX MEM",
       NUMBER_PASSES PASS, trunc(TEMPSEG_SIZE/1024) TSIZE
FROM V$SQL_WORKAREA_ACTIVE
ORDER BY 1,2;


SELECT round(PGA_TARGET_FOR_ESTIMATE/1024/1024) target_mb,
       ESTD_PGA_CACHE_HIT_PERCENTAGE cache_hit_perc,
       ESTD_OVERALLOC_COUNT
FROM   v$pga_target_advice;





1. Finding top ten work areas requiring the most cache memory:

select * 
from
	(select workarea_address, operation_type, policy, estimated_optimal_size
  	 from v$sql_workarea
 	order by estimated_optimal_size DESC)
where ROWNUM <=10;



2. Finding the top ten biggest work areas currently allocated in the system:

select c.sql_text, w.operation_type, top_ten.wasize
From (Select *
      From (Select workarea_address, actual_mem_used wasize
            from v$sql_workarea_active
            Order by actual_mem_used)
      Where ROWNUM <=10) top_ten,
      v$sql_workarea w,
      v$sql c
Where    w.workarea_address=top_ten.workarea_address
        And c.address=w.address
        And c.child_number = w.child_number
        And c.hash_value=w.hash_value;     


3. Finding the percentage of memory that is over and under allocated:

select  total_used,
        under*100/(total_used+1) percent_under_use,
        over*100/(total_used+1)   percent_over_used
From
        ( Select
                sum(case when expected_size > actual_mem_used 
                                       then actual_mem_used else 0 end) under,
                sum(case when expected_size<> actual_mem_used 
                                       then actual_mem_used else 0 end) over,
                sum(actual_mem_used) total_used
        From v$sql_workarea_active
        Where policy='AUTO') usage; 

     


