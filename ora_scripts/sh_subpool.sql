select count(distinct kghluidx) num_subpools
    from x$kghlu
    where kghlushrpool = 1;
