col shipment_id for 999999999999999999999 
select count(1) from (
WITH OPE as
                  (SELECT /*+ FULL(ope) */ DISTINCT to_number(event_shipment_id,999999999999999999) ship_id
                   FROM order_pipeline_events ope
                   WHERE day_of_week = trunc(MOD(TO_NUMBER(to_char(to_date('2017-12-18', 'YYYY-MM-DD'), 'J')), 70)/7) +1
                     AND ope.event_date   >= sysdate-5/24
                     AND ope.event_id_new  = 1013
                     AND ope.event_id_old <> 1032
                  ),
              CCS as
                  (SELECT ccs.shipment_id sh_id
                 FROM OPE,
                   completed_customer_shipments ccs
                 WHERE ccs.shipment_id = OPE.ship_id
                 ),
              FCS as
                  (SELECT /*+ MATERIALIZE */ OPE.ship_id sh_id, fcsp.completed_shipment_package_id pi                    
                     FROM OPE,
                       fc_completed_shipments fcs,
                       fc_completed_shipment_packages fcsp
                     WHERE fcs.completed_shipment_id    = OPE.ship_id
                     AND fcs.completed_shipment_id      = fcsp.completed_shipment_id
                     AND fcs.shipment_source_type_code <> 'RNTL'
                     AND fcs.fulfillment_brand_code LIKE 'RMVL%'
                     ),
              PCS as
                  (SELECT /*+ MATERIALIZE */ pcs.shipment_id
                         FROM OPE,
                           pending_customer_shipments pcs
                         WHERE pcs.shipment_id = OPE.ship_id
                         )
SELECT csi.shipment_id
                       FROM customer_shipment_items csi, CCS
                       WHERE CCS.sh_id = csi.shipment_id
              UNION ALL
                       (SELECT FCS.sh_id
                       FROM fc_completed_shipment_pkgitems fcspi, FCS
                       WHERE FCS.sh_id = fcspi.completed_shipment_package_id
                      )
              UNION
                   (select PCS.shipment_id
                   FROM
                         PCS
)
);

