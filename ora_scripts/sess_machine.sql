set headsep !
col machine format a70 head "Machine"
col inst1 format a1 head "I!*"
col total format 9999 head "Total"
col spacer format a1 head "|!| "
col active format 9999 head "Active"
col inactive format 9999 head "In-!Active"
col five format 9999 head "<5!Min"
col fifteen format 9999 head "<15!Min"
col sixty format 9999 head "<60!Min"
col hourplus format 9999 head "60+!Min"
col dedicated format 9999 head "Dedi-!cated"
col shared format 9999 head "Shar-!ed"

ttitle off

clear computes
clear breaks
compute sum label "I-Tot" of total active inactive five fifteen sixty hourplus dedicated shared on inst1
compute sum label "Totals" -
  of total active inactive five fifteen sixty hourplus dedicated shared on report
break on inst1 nodup on report

select decode(instr(machine,'.'),
              0,rtrim(machine,chr(0)),
              substr(machine,1,instr(machine,'.') - 1)) machine,
       ltrim(to_char(inst_id,'9'),' ') inst1,
       count(*) total,
       '|' spacer,
       sum(decode(status,'ACTIVE',1,0)) active,
       sum(decode(status,'ACTIVE',0,1)) inactive,
       '|' spacer,
       sum(decode(least(5,trunc((sysdate - logon_time)*1440)),5,0,1)) five,
       sum(decode(least(15,trunc((sysdate - logon_time)*1440)),
                  15,0,
                  decode(greatest(4,trunc((sysdate - logon_time)*1440)),
                         4,0,1))) fifteen,
       sum(decode(least(60,trunc((sysdate - logon_time)*1440)),
                  60,0,
                  decode(greatest(14,trunc((sysdate - logon_time)*1440)),
                         14,0,1))) sixty,
       sum(decode(greatest(59,trunc((sysdate - logon_time)*1440)),
                  59,0,1)) hourplus,
       '|' spacer,
       sum(decode(server,'DEDICATED',1,0)) dedicated,
       sum(decode(server,'SHARED',1,'NONE',1,0)) shared
  from gv$session
 group by inst_id,
       decode(instr(machine,'.'),
              0,rtrim(machine,chr(0)),
              substr(machine,1,instr(machine,'.') - 1));

set headsep |


