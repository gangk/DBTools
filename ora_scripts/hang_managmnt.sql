set pagesize 1000
set numwidth 4
column HID format 999
column numofsess heading "# of|Sess"
column "Hang Status" heading "Hang|Status"
column "Hang Resolution Time" format a15
column "Hang Resolution Time" heading "Hang Resolution|Time"
column "Ignored" heading "I|G|N|D"
column "KillAttempted" heading "K|A|P|T"
column "Global" heading "G|B|L"
column "Escalated" heading "E|S|C"
column "Resolution Action" format a20
column HngCnf heading "Hang|Conf"
break on HID skip 1

select hid,
numsess "NumofSess",
decode(HNGSTS, 0, 'Valid',
1, 'Invalid',
2, 'Needs Verify',
3, 'Verified Hang',
4, 'Victim Selected',
5, 'Hang Resolved',
6, 'Pending Self-Res',
7, 'Self-Resolved',
8, 'Unresolvable',
9, 'RCFG: Prior Hang', 'Unknown') "Hang Status",
decode(HNGSTS, 5, to_char(HNGRELTM, 'HH24:MI:SS'),
7, to_char(HNGRELTM, 'HH24:MI:SS'),
to_char(HNGRESTM, 'HH24:MI:SS')) "Hang Resolution Time",
decode(bitand(HNGRSSTS,1), 0, 'N', 'Y') "Ignored",
decode(bitand(HNGRSSTS,2), 0, 'N', 'Y') "KillAttempted",
decode(bitand(HNGRSSTS,4), 0, 'N', 'Y') "Global",
decode(bitand(HNGRSSTS,16), 0, 'N', 'Y') "Escalated",
decode(HNGCONF, 1, 'LOW',
2, 'MEDIUM',
3, 'HIGH') "HngCnf",
decode(VFYSTS, 0, 'Not Verified',
1, 'Verified Hung',
2, 'Verified Not Hung',
3, 'In Doubt') "Verify Status",
decode(HNGSTS, 6, 'Not Applicable',
7, 'Not Applicable',
8, 'Not Applicable',
decode(bitand(VCTYP,2), 0, 'Process Termination',
'Instance Termination')) "Resolution Action"
from x$kjznhangs a;

column INST heading "Inst|Num "
column INST format 999
column OSPID format a7
column SNO heading "Ses|Ser|Num"
column SNO format 99999
column "Background" heading "B|K|G|D"
column "Root" heading "R|O|O|T"
column "Wait Event" format a30 truncate
column BLKR heading "BLKR|SID"
column "Time in Wt" format a10

select a.HID,
a.INST,
SID,
SNO,
OSPID,
decode(bitand(FLGS,2), 0, 'N', 'Y') "Background",
decode(bitand(FLGS,4), 0, 'N', 'Y') "Root",
decode(a.WTEVT, 4294967295, 'not in a wait', b.name) "Wait Event",
BLKR
from x$kjznhangses a, v$event_name b, x$kjznhangs c
where a.WTEVT=b.event#(+)
and a.HID = c.HID
order by a.hid asc, a.INDX asc; 