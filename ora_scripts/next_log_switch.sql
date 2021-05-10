SELECT indx, lenum group#, leseq sequence#, archived,
DECODE (leflg, 8, 'CURRENT') curstatus,
CASE WHEN leseq = minseq AND indx = minind THEN 'NEXT'
END NEXT
FROM (SELECT indx, lenum, leseq, leflg,
DECODE (BITAND (leflg, 1), 0, 'NO', 'YES') archived,
FIRST_VALUE (leseq) OVER (ORDER BY leseq, indx,BITAND (leflg, 1) DESC) minseq,
FIRST_VALUE (indx) OVER (ORDER BY leseq, indx, BITAND (leflg, 1) DESC) minind
FROM x$kccle
WHERE lesiz != 0 AND inst_id = USERENV ('instance'))
ORDER BY indx