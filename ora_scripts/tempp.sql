SELECT  NVL(SUM(quant), 0) q
          FROM (
     SELECT  NVL(SUM(pcs.total_quantity), 0) quant
     FROM    order_pipeline_events ope,
             pending_customer_shipments pcs 
     WHERE   pcs.shipment_id = ope.event_shipment_id AND
             ope.event_date >= TO_DATE('2017/12/18', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_date < TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_id_new = 1013 AND
             ope.event_id_old <> 1032
     UNION
     SELECT  NVL(SUM(fmcsi.quantity), 0) quant
     FROM    order_pipeline_events ope,
             fc_merch_completed_shipments fmcs,
             fc_merch_completed_ship_items fmcsi
     WHERE   fmcs.shipment_id = ope.event_shipment_id AND
             fmcsi.shipment_id = fmcs.shipment_id AND
             ope.event_date >= TO_DATE('2017/12/18', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_date < TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_id_new = 1013 AND
             ope.event_id_old <> 1032 );

--


SELECT NVL(SUM(quant),0) quant
 FROM
     (
         (
             SELECT  NVL(SUM(quantity), 0) quant
             FROM  fc_completed_shipment_pkgitems fcspi,
                   (
                       SELECT fcsp.completed_shipment_package_id pkgsid
                       FROM  order_pipeline_events ope,
                             fc_completed_shipments fcs,
                             fc_completed_shipment_packages fcsp
                       WHERE fcs.completed_shipment_id = ope.event_shipment_id AND
                             fcs.completed_shipment_id = fcsp.completed_shipment_id AND
                             ope.event_date >= TO_DATE('2017/12/18', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_date < TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS') AND
                             fcs.promised_arrival_date_utc >= TO_DATE('2017/11/01', 'YYYY/MM/DD HH:MI:SS') AND
                             fcs.promised_arrival_date_utc < TO_DATE('2017/12/25', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_id_new = 1013 AND
                             ope.event_id_old <> 1032 AND
                             fcs.shipment_source_type_code <> 'RNTL' AND
                             fcs.fulfillment_brand_code LIKE 'RMVL%'
                       GROUP BY fcsp.completed_shipment_package_id
                   )
             WHERE pkgsid = fcspi.completed_shipment_package_id
         )
         UNION 
         (
             SELECT  NVL(SUM(quantity), 0) quant
             FROM  customer_shipment_items csi,
                   (
                       SELECT ccs.shipment_id shipmentid
                       FROM  order_pipeline_events ope,
                             completed_customer_shipments ccs
                       WHERE ccs.shipment_id = ope.event_shipment_id AND
                             ope.event_date >= TO_DATE('2017/12/18', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_date < TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS') AND
                             ccs.promised_arrival_date >= TO_DATE('2017/11/01', 'YYYY/MM/DD HH:MI:SS') AND
                             ccs.promised_arrival_date < TO_DATE('2017/12/25', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_id_new  = 1013 AND
                             ope.event_id_old <> 1032
                       GROUP BY ccs.shipment_id
                   )
             WHERE  shipmentid = csi.shipment_id
         )
     );



SELECT NVL(SUM(quant),0) quant
 FROM
     (
         (
             SELECT  NVL(SUM(quantity), 0) quant
             FROM  fc_completed_shipment_pkgitems fcspi,
                   (
                       SELECT fcsp.completed_shipment_package_id pkgsid
                       FROM  order_pipeline_events ope,
                             fc_completed_shipments fcs,
                             fc_completed_shipment_packages fcsp
                       WHERE fcs.completed_shipment_id = ope.event_shipment_id AND
                             fcs.completed_shipment_id = fcsp.completed_shipment_id AND
                             ope.event_date >= TO_DATE('2017/12/18', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_date < TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS') AND
                             fcs.promised_arrival_date_utc >= TO_DATE('2017/11/01', 'YYYY/MM/DD HH:MI:SS') AND
                             fcs.promised_arrival_date_utc < TO_DATE('2017/12/25', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_id_new = 1013 AND
                             ope.event_id_old <> 1032 AND
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
                       FROM  order_pipeline_events ope,
                             completed_customer_shipments ccs
                       WHERE ccs.shipment_id = ope.event_shipment_id AND
                             ope.event_date >= TO_DATE('2017/12/18', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_date < TO_DATE('2017/12/19', 'YYYY/MM/DD HH:MI:SS') AND
                             ccs.promised_arrival_date >= TO_DATE('2017/11/01', 'YYYY/MM/DD HH:MI:SS') AND
                             ccs.promised_arrival_date < TO_DATE('2017/12/25', 'YYYY/MM/DD HH:MI:SS') AND
                             ope.event_id_new  = 1013 AND
                             ope.event_id_old <> 1032
                       GROUP BY ccs.shipment_id
                   )
             WHERE  shipmentid = csi.shipment_id
         )
     );
