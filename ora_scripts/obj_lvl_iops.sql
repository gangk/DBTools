CREATE TABLE admin.obj_iops
(
     collection_timestamp date,
     collection_id NUMBER,
     obj_name VARCHAR2(30),
     obj_type VARCHAR2(18),
     stat_name VARCHAR2(64),
     stat_value NUMBER
);
 
DECLARE
     run_duration number := 300;
     capture_gap number := 15;
     loop_count number :=run_duration/capture_gap;
    
BEGIN
     FOR i in 1..loop_count LOOP
    
           FOR r IN (SELECT sysdate as TS, OBJECT_NAME, OBJECT_TYPE, STATISTIC_NAME, sum(VALUE) as val
                           FROM v$segment_statistics
                        WHERE OWNER = 'BOOKER'
                           AND STATISTIC_NAME like '%physical%'
                        GROUP BY sysdate, OWNER, OBJECT_NAME, OBJECT_TYPE, STATISTIC_NAME
                       HAVING sum(VALUE) > 0
                     ORDER BY OBJECT_NAME, OBJECT_TYPE, STATISTIC_NAME)
           LOOP
          
                INSERT INTO admin.obj_iops
                (
                     collection_timestamp,
                     collection_id,
                     obj_name,
                     obj_type,
                     stat_name,
                     stat_value
                )
                VALUES
                (r.TS, i, r.OBJECT_NAME, r.OBJECT_TYPE, r.STATISTIC_NAME, r.val);
 
--              DBMS_OUTPUT.PUT_LINE('Number of row added: ' || TO_CHAR(SQL%ROWCOUNT));
           END LOOP;
          
           COMMIT;
           DBMS_LOCK.SLEEP(capture_gap);
    END LOOP;
    
EXCEPTION 
WHEN OTHERS THEN
ROLLBACK;
END;
/
 
SELECT n.collection_timestamp, n.obj_name, n.obj_type, n.stat_name, (n.stat_value - o.stat_value)/15 As IOPS
  FROM admin.obj_iops o, admin.obj_iops n
WHERE (o.collection_id + 1) = n.collection_id
   AND o.obj_name = n.obj_name
   AND o.obj_type = n.obj_type
   AND o.stat_name = n.stat_name
   AND (n.stat_value - o.stat_value) > 0
ORDER BY 1,2,3;
