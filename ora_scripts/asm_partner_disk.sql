column p format a80
variable group_number number
exec :group_number := 1;

PL/SQL procedure successfully completed.

SQL> select d||' => '||listagg(p, ',') within group (order by p) p
from (
select ad1.failgroup||'('||to_char(ad1.disk_number, 'fm00')||')' d,
 ad2.failgroup||'('||listagg(to_char(p.number_kfdpartner, 'fm00'), ',') within group (order by ad1.disk_number)||')' p
 from v$asm_disk ad1, x$kfdpartner p, v$asm_disk ad2
 where ad1.disk_number = p.disk
  and p.number_kfdpartner=ad2.disk_number
  and ad1.group_number = p.grp
  and ad2.group_number = p.grp
  and p.grp = :group_number
 group by ad1.failgroup, ad1.disk_number, ad2.failgroup
) group by d
order by d;