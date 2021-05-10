set echo on
spool find_dup
select asin,product_attribute_id,property_value,language_code  from  item_property_values a
where a.rowid >
	( select min(b.rowid)
 	  from item_property_values b
	  where 
	      a.asin = b.asin
	  and a.product_attribute_id = b.product_attribute_id
	  and a.property_value = b.property_value
          and a.language_code = b.language_code
	)
;
spool off
