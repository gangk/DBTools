set termout off
select /*+ gather_plan_statistics */
	warehouse_id,asin
FROM le101.inventory_level_by_owner_rt
WHERE inventory_condition_code='SELLABLE'
and on_hand_quantity>=0 
and allocated_quantity>=0 
and unallocated_customer_demand >=0
and nvl (inventory_owner_group_id, 1)  in ( 1,2)
group by warehouse_id,asin 
having sum(on_hand_quantity -allocated_quantity -unallocated_customer_demand) < 0
;
set termout on
select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));        
