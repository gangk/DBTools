SELECT
	pg_get_indexdef(ss.indexrelid, (ss.iopc).n, TRUE) AS IndexColumn
	,amop.amopopr::regoperator AS IndexableOperators
FROM pg_opclass opc, pg_amop amop,
(SELECT indexrelid, information_schema._pg_expandarray(indclass) AS iopc
FROM pg_index
WHERE indexrelid = 'Your_Index_Name'::regclass) ss
WHERE amop.amopfamily = opc.opcfamily 
	AND opc.oid = (ss.iopc).x
ORDER BY IndexableOperators;
