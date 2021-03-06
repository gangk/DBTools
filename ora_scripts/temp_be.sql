CREATE TABLE "BOOKER"."BINEDIT_ENTRIES_NEW"
   (	"ENTRY_DATE" DATE DEFAULT sysdate,
	"OPERATION" CHAR(1),
	"OLD_BIN_ID" VARCHAR2(14),
	"NEW_BIN_ID" VARCHAR2(14),
	"ISBN" CHAR(10),
	"OLD_OWNER" VARCHAR2(19),
	"NEW_OWNER" VARCHAR2(19),
	"SOURCE" VARCHAR2(27),
	"QUANTITY" NUMBER(8,0),
	"PERSON" VARCHAR2(8),
	"DISTRIBUTOR_ORDER_ID" VARCHAR2(19),
	"OLD_DESCRIPTION_CODE" NUMBER(3,0),
	"NEW_DESCRIPTION_CODE" NUMBER(3,0),
	"WAREHOUSE_ID" CHAR(4),
	"BINEDIT_ENTRY_ID" NUMBER NOT NULL ENABLE,
	"ORDER_TYPE" NUMBER(2,0),
	"REASON_CODE" CHAR(1),
	 CONSTRAINT "PK_BINEDIT_ENTRIES_NEW" PRIMARY KEY ("BINEDIT_ENTRY_ID", "ENTRY_DATE")
  USING INDEX PCTFREE 5 INITRANS 8 MAXTRANS 255
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX"  LOCAL
 (PARTITION "BEE_20161231"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170331"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170630"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170930"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" )  ENABLE
   ) PCTFREE 5 PCTUSED 40 INITRANS 4 MAXTRANS 255
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS"
  PARTITION BY RANGE ("ENTRY_DATE")
 (PARTITION "BEE_20161231"  VALUES LESS THAN (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) SEGMENT CREATION IMMEDIATE
  PCTFREE 5 PCTUSED 40 INITRANS 4 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS" ,
 PARTITION "BEE_20170331"  VALUES LESS THAN (TO_DATE(' 2017-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) SEGMENT CREATION IMMEDIATE
  PCTFREE 5 PCTUSED 40 INITRANS 4 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS" ,
 PARTITION "BEE_20170630"  VALUES LESS THAN (TO_DATE(' 2017-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) SEGMENT CREATION IMMEDIATE
  PCTFREE 5 PCTUSED 40 INITRANS 4 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS" ,
 PARTITION "BEE_20170930"  VALUES LESS THAN (TO_DATE(' 2017-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) SEGMENT CREATION DEFERRED
  PCTFREE 5 PCTUSED 40 INITRANS 4 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS" );


--
CREATE INDEX "BOOKER"."I_BE_ENTRY_DATE_N" ON "BOOKER"."BINEDIT_ENTRIES_NEW" ("ENTRY_DATE")
  PCTFREE 5 INITRANS 8 MAXTRANS 255
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX"  LOCAL
 (PARTITION "BEE_20161231"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170331"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170630"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170930"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" );

--
CREATE INDEX "BOOKER"."I_BE_ISBN_DATE_OPER_DO_ID_N" ON "BOOKER"."BINEDIT_ENTRIES_NEW" ("ISBN", "ENTRY_DATE", "OPERATION", "DISTRIBUTOR_ORDER_ID")
  PCTFREE 5 INITRANS 8 MAXTRANS 255
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX"  LOCAL
 (PARTITION "BEE_20161231"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170331"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170630"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170930"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" );

--
CREATE INDEX "BOOKER"."I_BE_NEW_BIN_ID_N" ON "BOOKER"."BINEDIT_ENTRIES_NEW" ("NEW_BIN_ID")
  PCTFREE 5 INITRANS 8 MAXTRANS 255
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX"  LOCAL
 (PARTITION "BEE_20161231"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170331"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170630"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170930"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" );

--
CREATE INDEX "BOOKER"."I_BE_O_BIN_ENT_DT_ISBN_PERS_N" ON "BOOKER"."BINEDIT_ENTRIES_NEW" ("OLD_BIN_ID", "ENTRY_DATE", "ISBN", "PERSON")
  PCTFREE 5 INITRANS 8 MAXTRANS 255
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX"  LOCAL
 (PARTITION "BEE_20161231"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170331"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170630"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170930"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" );


--
CREATE INDEX "BOOKER"."I_BE_PER_DOI_OP_EDATE_N" ON "BOOKER"."BINEDIT_ENTRIES_NEW"("PERSON", "DISTRIBUTOR_ORDER_ID", "OPERATION", "ENTRY_DATE")
  PCTFREE 5 INITRANS 8 MAXTRANS 255
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX"  LOCAL
 (PARTITION "BEE_20161231"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170331"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170630"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 4194304 NEXT 4194304 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" ,
 PARTITION "BEE_20170930"
  PCTFREE 5 INITRANS 8 MAXTRANS 255 LOGGING
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DC_OPS_IDX" );
