--Max and min columns should be close to each other for balanced files.
SELECT group_kffxp Group#
  , number_kffxp file#
  , MAX(count1) MAX
  , MIN(count1) MIN
FROM
    (SELECT group_kffxp
         ,  number_kffxp
         , disk_kffxp
         , COUNT(XNUM_KFFXP) count1
    FROM x$kffxp
    WHERE group_kffxp = &diskgroup_number
    ANd disk_kffxp != 65534
    GROUP BY group_kffxp, number_kffxp, disk_kffxp
    ORDER BY group_kffxp
           , number_kffxp
           , disk_kffxp
    )
GROUP BY group_kffxp, number_kffxp;