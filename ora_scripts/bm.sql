WITH OPE as
              (SELECT /*+ FULL(ope) */ DISTINCT event_shipment_id
               FROM order_pipeline_events ope
               WHERE day_of_week = trunc(MOD(TO_NUMBER(to_char(to_date('2017-12-18', 'YYYY-MM-DD'), 'J')), 70)/7) +1
                 AND ope.event_date   >= to_date('2017-12-18', 'YYYY-MM-DD')
                 AND ope.event_date    < to_date('2017-12-19', 'YYYY-MM-DD')
                 AND ope.event_id_new  = 1013
                 AND ope.event_id_old <> 1032
              ),
          CCS as
              (SELECT ccs.shipment_id sh_id ,
                     ccs.fulfillment_brand_code fbc
             FROM OPE,
               completed_customer_shipments ccs
             WHERE ccs.shipment_id = ope.event_shipment_id
             GROUP BY ccs.shipment_id,
               ccs.fulfillment_brand_code),
          FCS as
              (SELECT /*+ MATERIALIZE */ fcs.fulfillment_brand_code fbc,
                   fcsp.completed_shipment_package_id pi
                 FROM OPE,
                   fc_completed_shipments fcs,
                   fc_completed_shipment_packages fcsp
                 WHERE fcs.completed_shipment_id    = ope.event_shipment_id
                 AND fcs.completed_shipment_id      = fcsp.completed_shipment_id
                 AND fcs.shipment_source_type_code <> 'RNTL'
                 AND fcs.fulfillment_brand_code LIKE 'RMVL%'
                 GROUP BY fcsp.completed_shipment_package_id,
                   fcs.fulfillment_brand_code
                 ),
          PCS as
              (SELECT /*+ MATERIALIZE */ NVL(SUM(pcs.total_quantity), 0) quant,
                       pcs.marketplace_id,
                       pcs.fulfillment_brand_code
                     FROM OPE,
                       pending_customer_shipments pcs
                     WHERE pcs.shipment_id = ope.event_shipment_id
                     GROUP BY pcs.marketplace_id,
                       pcs.fulfillment_brand_code
                     )
          SELECT SUM(quant) qty,
           fbc fbc
          FROM (
                   (SELECT NVL(SUM(quantity), 0) quant, fbc
                   FROM customer_shipment_items csi, CCS
                   WHERE CCS.sh_id = csi.shipment_id
                   GROUP BY fbc
                   )
          UNION ALL
                   (SELECT NVL(SUM(quantity), 0) quant,
                     fbc
                   FROM fc_completed_shipment_pkgitems fcspi, FCS
                   WHERE FCS.pi = fcspi.completed_shipment_package_id
                   GROUP BY fbc
                  )
          UNION
               (SELECT NVL(SUM(quant), 0) q,
                 fulfillment_brand_code fbc
               FROM
                     PCS
               GROUP BY fulfillment_brand_code
               ) )
             GROUP BY fbc;
