select inst_id, handle, grant_level, request_level, resource_name1, resource_name2, pid , transaction_id0, transaction_id1,owner_node, 
blocked, blocker, state from gv$ges_blocking_enqueue
/