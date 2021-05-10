SELECT disk "Disk", count(number_kfdpartner) "Number of partners"
FROM x$kfdpartner
WHERE grp=&grp_number
GROUP BY disk
ORDER BY 1;