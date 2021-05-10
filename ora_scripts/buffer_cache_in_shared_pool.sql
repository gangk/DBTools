select
 s.ksmchptr SP_CHUNK, 
 s.ksmchsiz CH_SIZE,
 b.obj DATAOBJ#,
 b.ba BLOCKADDR,
 b.blsiz BLKSIZE,
 decode(b.class,
 1,'data block',
 2,'sort block',
 3,'save undo block',
 4,'segment header',
 5,'save undo header',
 6,'free list',
 7,'extent map',
 8,'1st level bmb',
 9,'2nd level bmb',
 10,'3rd level bmb',
 11,'bitmap block',
 12,'bitmap index block',
 13,'file header block',
 14,'unused',
 15,'system undo header',
 16,'system undo block',
 17,'undo header',
 18,'undo block',
 class) BLKTYPE,
 decode (b.state,
 0,'free',1,'xcur',2,'scur',3,'cr', 4,'read',
 5,'mrec',6,'irec',7,'write',8,'pi', 9,'memory',
 10,'mwrite',11,'donated',b.state) BLKSTATE
 from
 x$bh b,
 x$ksmsp s
 where (
 b.ba >= s.ksmchptr
 and to_number(b.ba, 'XXXXXXXXXXXXXXXX') + b.blsiz <
to_number(ksmchptr, 'XXXXXXXXXXXXXXXX') + ksmchsiz )
 and s.ksmchcom = 'KGH: NO ACCESS'
 order by s.ksmchptr, b.ba;