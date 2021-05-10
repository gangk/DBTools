SELECT a.constraint_name, a.table_name, a.column_name,  c.owner,
       c_pk.table_name r_table_name,  b.column_name r_column_name
  FROM dba_cons_columns a
  JOIN dba_constraints c ON a.owner = c.owner
       AND a.constraint_name = c.constraint_name
  JOIN dba_constraints c_pk ON c.r_owner = c_pk.owner
       AND c.r_constraint_name = c_pk.constraint_name
  JOIN dba_cons_columns b ON C_PK.owner = b.owner
       AND  C_PK.CONSTRAINT_NAME = b.constraint_name AND b.POSITION = a.POSITION
 WHERE c.constraint_type = 'R' and a.owner='BOOKER' and a.table_name in ('TRANSFER_MANIFESTS','TRANSFER_MANIFEST_ITEMS','TRANSFER_OUTBD_CONTAINERS','TRANSFER_OUTBD_CONTAINER_ITEMS','TRANSFER_ITEM_FINANCE_SUPPL','DMS_EDIT_REQUESTS','TRANSFER_DELIVERIES','TRANSFER_DELIVERY_ITEMS','TDI_ICI_IDS','TRANSFER_INBD_CONTAINERS','TRANSFER_INBD_CONTAINER_ITEMS','TRANSFER_RECEIVE_ACTIONS');
