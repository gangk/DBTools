query #1:

WITH OPE as (SELECT DISTINCT event_shipment_id
               FROM order_pipeline_events ope
                 WHERE ope.event_date   >= TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS')
                 AND ope.event_date    < TO_DATE('2017/12/20', 'YYYY/MM/DD HH:MI:SS')
                 AND ope.event_id_new  = 1013
                 AND ope.event_id_old <> 1032 )               
SELECT  NVL(SUM(quant), 0) q      
 FROM (
     SELECT  NVL(SUM(pcs.total_quantity), 0) quant,
             pcs.marketplace_id
     FROM    OPE,
             pending_customer_shipments pcs 
     WHERE   pcs.shipment_id = ope.event_shipment_id
     GROUP BY pcs.marketplace_id
     UNION
     SELECT  NVL(SUM(fmcsi.quantity), 0) quant,
             fmcs.marketplace_id
     FROM    OPE,
             fc_merch_completed_shipments fmcs,
             fc_merch_completed_ship_items fmcsi
     WHERE   fmcs.shipment_id = ope.event_shipment_id AND
             fmcsi.shipment_id = fmcs.shipment_id             
     GROUP BY fmcs.marketplace_id
     );


query #2:

WITH OPE as (SELECT DISTINCT event_shipment_id
               FROM order_pipeline_events ope
                 WHERE ope.event_date   >= TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS')
                 AND ope.event_date    < TO_DATE('2017/12/20', 'YYYY/MM/DD HH:MI:SS')
                 AND ope.event_id_new  = 1013
                 AND ope.event_id_old <> 1032 )     
SELECT  NVL(SUM(quant), 0) quant
 FROM
     (
         (
             SELECT  NVL(SUM(quantity), 0) quant
             FROM  fc_completed_shipment_pkgitems fcspi,
                   (
                       SELECT  fcsp.completed_shipment_package_id pkgsid
                       FROM    OPE,
                               fc_completed_shipments fcs,
                               fc_completed_shipment_packages fcsp
                       WHERE   fcs.completed_shipment_id = ope.event_shipment_id AND
                               fcs.completed_shipment_id = fcsp.completed_shipment_id AND
                               fcs.shipment_source_type_code <> 'RNTL' AND
                               fcs.fulfillment_brand_code LIKE 'RMVL%'
                       GROUP BY fcsp.completed_shipment_package_id
                   )
             WHERE pkgsid = fcspi.completed_shipment_package_id
         )
         UNION ALL
         (
             SELECT  NVL(SUM(quantity), 0) quant
             FROM  customer_shipment_items csi,
                   (
                       SELECT ccs.shipment_id shipmentid
                       FROM  OPE,
                             completed_customer_shipments ccs
                       WHERE ccs.shipment_id = ope.event_shipment_id 
                       GROUP BY ccs.shipment_id
                   )
             WHERE shipmentid = csi.shipment_id
             GROUP BY csi.inventory_owner_group_id
         )
     );

--big gulp

WITH OPE as
              (SELECT /*+ FULL(ope) */ DISTINCT event_shipment_id
               FROM order_pipeline_events ope
               WHERE day_of_week = trunc(MOD(TO_NUMBER(to_char(to_date('2017-12-19', 'YYYY-MM-DD'), 'J')), 70)/7) +1
                 AND ope.event_date   >= TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS')
                 AND ope.event_date    < TO_DATE('2017/12/20', 'YYYY/MM/DD HH:MI:SS')
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
