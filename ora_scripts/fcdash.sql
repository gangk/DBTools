SELECT  NVL(SUM(quant), 0) q,
         marketplace_id mid
 FROM (
     SELECT  NVL(SUM(pcs.total_quantity), 0) quant,
             pcs.marketplace_id
     FROM    order_pipeline_events ope,
             pending_customer_shipments pcs 
     WHERE   pcs.shipment_id = ope.event_shipment_id AND
             ope.event_date >= TO_DATE('2017/12/18 00:00:00', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_date < TO_DATE('2017/12/19 00:00:00', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_id_new = 1013 AND
             ope.event_id_old <> 1032
     GROUP BY pcs.marketplace_id
     UNION ALL
     SELECT  NVL(SUM(fmcsi.quantity), 0) quant,
             fmcs.marketplace_id
     FROM    order_pipeline_events ope,
             fc_merch_completed_shipments fmcs,
             fc_merch_completed_ship_items fmcsi
     WHERE   fmcs.shipment_id = ope.event_shipment_id AND
             fmcsi.shipment_id = fmcs.shipment_id AND
             ope.event_date >= TO_DATE('2017/12/18 00:00:00', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_date < TO_DATE('2017/12/19 00:00:00', 'YYYY/MM/DD HH:MI:SS') AND
             ope.event_id_new = 1013 AND
             ope.event_id_old <> 1032
     GROUP BY fmcs.marketplace_id
     )
 GROUP BY marketplace_id;
