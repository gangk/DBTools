COL pvalid_default HEAD DEFAULT FOR A7
COL pvalid_value   HEAD VALUE   FOR A30
COL pvalid_name    HEAD PARAMETER FOR A50
COL pvalid_par#    HEAD PAR# FOR 99999

BREAK ON pvalid_par# skip 1

SELECT 
--	INST_ID, 
	PARNO_KSPVLD_VALUES     pvalid_par#,
	NAME_KSPVLD_VALUES      pvalid_name, 
--	ORDINAL_KSPVLD_VALUES, 
	VALUE_KSPVLD_VALUES	pvalid_value,
	DECODE(ISDEFAULT_KSPVLD_VALUES, 'FALSE', '', 'DEFAULT' ) pvalid_default
FROM 
	X$KSPVLD_VALUES 
WHERE 
	LOWER(NAME_KSPVLD_VALUES) LIKE LOWER('%&1%')
ORDER BY
	pvalid_par#,
	pvalid_default,
	pvalid_Value
/
