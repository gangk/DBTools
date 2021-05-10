accept STATEMENT_ID prompt "Enter Statement Id set for explain plan :"

SELECT     LEVEL,
              operation
           || DECODE (options, NULL, '', ' ' || options)
           || DECODE (ID,
                      0, DECODE (optimizer,
                                 NULL, '',
                                 ' Optimizer Mode=' || optimizer
                                )
                     ),
           DECODE (object_name,
                   NULL, ' ',
                   object_owner || '.' || object_name
                  ),
           DECODE (cardinality,
                   NULL, '  ',
                   DECODE (SIGN (cardinality - 1000),
                           -1, cardinality || '  ',
                           DECODE (SIGN (cardinality - 1000000),
                                   -1, TRUNC (cardinality / 1000) || ' K',
                                   DECODE (SIGN (cardinality - 1000000000),
                                           -1, TRUNC (cardinality / 1000000)
                                            || ' M',
                                              TRUNC (cardinality / 1000000000)
                                           || ' G'
                                          )
                                  )
                          )
                  ) numrows,
           DECODE (BYTES,
                   NULL, ' ',
                   DECODE (SIGN (BYTES - 1024),
                           -1, BYTES || '  ',
                           DECODE (SIGN (BYTES - 1048576),
                                   -1, TRUNC (BYTES / 1024) || ' K',
                                   DECODE (SIGN (BYTES - 1073741824),
                                           -1, TRUNC (BYTES / 1048576) || ' M',
                                           TRUNC (BYTES / 1073741824) || 'G'
                                          )
                                  )
                          )
                  ) BYTES,
           DECODE (COST,
                   NULL, ' ',
                   DECODE (SIGN (COST - 10000000),
                           -1, COST || '  ',
                           DECODE (SIGN (COST - 1000000000),
                                   -1, TRUNC (COST / 1000000) || ' M',
                                   TRUNC (COST / 1000000000) || ' G'
                                  )
                          )
                  ) COST,
           DECODE (object_node, NULL, ' ', object_node) tq,
           LPAD
              (   DECODE
                     (other_tag,
                      NULL, ' ',
                      DECODE
                         (other_tag,
                          'PARALLEL_TO_SERIAL', ' P->S',
                          DECODE
                             (other_tag,
                              'PARALLEL_TO_PARALLEL', ' P->P',
                              DECODE
                                 (other_tag,
                                  'PARALLEL_COMBINED_WITH_PARENT', ' PCWP',
                                  DECODE
                                      (other_tag,
                                       'PARALLEL_FROM_SERIAL', ' S->P',
                                       DECODE (other_tag,
                                               'PARALLEL_COMBINED_WITH_CHILD', 
' PCWC',
                                               DECODE (other_tag,
                                                       NULL, ' ',
                                                       other_tag
                                                      )
                                              )
                                      )
                                 )
                             )
                         )
                     )
               || ' ',
               6,
               ' '
              ),
              RPAD
                 (   ' '
                  || DECODE (distribution,
                             NULL, ' ',
                             DECODE (distribution,
                                     'PARTITION (ROWID)', 'PART (RID)',
                                     DECODE (distribution,
                                             'PARTITION (KEY)', 'PART (KEY)',
                                             DECODE (distribution,
                                                     'ROUND-ROBIN', 'RND-ROBIN',
                                                     DECODE (distribution,
                                                             'BROADCAST', 
'BROADCAST',
                                                             distribution
                                                            )
                                                    )
                                            )
                                    )
                            ),
                  12,
                  ' '
                 )
           || DECODE
                 (partition_start,
                  'ROW LOCATION', 'ROWID',
                  DECODE
                     (partition_start,
                      'KEY', 'KEY',
                      DECODE
                           (partition_start,
                            'KEY(INLIST)', 'KEY(I)',
                            DECODE (SUBSTR (partition_start, 1, 6),
                                    'NUMBER', SUBSTR
                                            (SUBSTR (partition_start, 8, 10),
                                             1,
                                               LENGTH
                                                     (SUBSTR (partition_start,
                                                              8,
                                                              10
                                                             )
                                                     )
                                             - 1
                                            ),
                                    DECODE (partition_start,
                                            NULL, ' ',
                                            partition_start
                                           )
                                   )
                           )
                     )
                 ) pstart,
           DECODE
              (partition_stop,
               'ROW LOCATION', 'ROW L',
               DECODE
                    (partition_stop,
                     'KEY', 'KEY',
                     DECODE (partition_stop,
                             'KEY(INLIST)', 'KEY(I)',
                             DECODE (SUBSTR (partition_stop, 1, 6),
                                     'NUMBER', SUBSTR
                                             (SUBSTR (partition_stop, 8, 10),
                                              1,
                                                LENGTH
                                                      (SUBSTR (partition_stop,
                                                               8,
                                                               10
                                                              )
                                                      )
                                              - 1
                                             ),
                                     DECODE (partition_stop,
                                             NULL, ' ',
                                             partition_stop
                                            )
                                    )
                            )
                    )
              ) pstop
      FROM plan_table
START WITH ID = 0 AND STATEMENT_ID = &STATEMENT_ID
CONNECT BY PRIOR ID = parent_id AND STATEMENT_ID = &STATEMENT_ID
  ORDER BY ID, POSITIONs