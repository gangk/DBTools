drop index booker.I_MLOG$_ASI_SNAPTIME;

alter table booker.MLOG$_AMAZON_STANDARD_ITEM move;

create index booker.I_MLOG$_ASI_SNAPTIME on booker.MLOG$_AMAZON_STANDARD_ITEM(snaptime$$) online tablespace replication;

drop index booker.I_MLOG$_IR_SNAPTIME;

alter table booker.MLOG$_ITEM_RELATIONSHIPS move;

create index booker.I_MLOG$_IR_SNAPTIME on MLOG$_ITEM_RELATIONSHIPS(snaptime$$) online tablespace replication;

drop index booker.I_MLOG$_ASI_CHANGES;

alter table booker.MLOG$_ASI_CHANGES move;


create index booker.I_MLOG$_ASI_CHANGES on booker.MLOG$_ASI_CHANGES(snaptime$$) online tablespace replication;


drop index booker.I_MLOG$_MSR_SNAPTIME;

alter table booker.MLOG$_MERCHANT_SKU_RELATIO move;

create index booker.I_MLOG$_MSR_SNAPTIME on booker.MLOG$_MERCHANT_SKU_RELATIO(snaptime$$) online tablespace replication;

