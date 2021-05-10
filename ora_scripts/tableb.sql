set time on;
set timing on;
set echo on;
set head on;
set tail on;


CREATE TABLE BOOKER.PAQ_MESSAGES_01B
   (    MESSAGE_ID VARCHAR2(256) NOT NULL ENABLE,
        REALM_NAME VARCHAR2(64) NOT NULL ENABLE,
        SERVICE_NAME VARCHAR2(64) NOT NULL ENABLE,
        QUEUE_NAME VARCHAR2(64) NOT NULL ENABLE,
        SUBJECT_KEY VARCHAR2(256) NOT NULL ENABLE,
        MESSAGE_REALM_NAME VARCHAR2(64) NOT NULL ENABLE,
        PAYLOAD BLOB NOT NULL ENABLE,
        MESSAGE_STATUS NUMBER(4,0) NOT NULL ENABLE,
        CURRENT_REDRIVE_COUNT NUMBER(10,0) NOT NULL ENABLE,
        REDRIVE_TIMEOUT_SECONDS NUMBER(10,0) NOT NULL ENABLE,
        BASE_REDRIVE_INTERVAL_SECONDS NUMBER(10,0) NOT NULL ENABLE,
        REDRIVE_START_DATE_UTC DATE,
        REDRIVE_FINISHED_DATE_UTC DATE,
        NEXT_REDRIVE_DATE_UTC DATE,
        REDRIVE_ERROR_DATE_UTC DATE,
        RECORD_VERSION_NUMBER NUMBER(38,0) NOT NULL ENABLE,
        CREATION_DATE DATE DEFAULT SYSDATE NOT NULL ENABLE,
        LAST_UPDATED DATE NOT NULL ENABLE,
        DOMAIN VARCHAR2(64) NOT NULL ENABLE,
        PRIORITY NUMBER,
         CONSTRAINT CK_PM01B_REDRIVE_COUNT CHECK (current_redrive_count >= 0) ENABLE,
         CONSTRAINT CK_PM01B_TIMEOUT_SEC CHECK (redrive_timeout_seconds >= 0) ENABLE,
         CONSTRAINT CK_PM01B_INTERVAL_SEC CHECK (base_redrive_interval_seconds >= 0) ENABLE
   ) 
PCTFREE 10 PCTUSED 80 INITRANS 8 MAXTRANS 255 NOCOMPRESS LOGGING
TABLESPACE REPLICATION
 LOB (PAYLOAD) STORE AS LOB_PAQ_MESSAGES_01B(
  TABLESPACE REPLICATION ENABLE 
  STORAGE IN ROW CHUNK 8192 PCTVERSION 1
  NOCACHE LOGGING
  )
/


create or replace public synonym PAQ_MESSAGES_01B for BOOKER.PAQ_MESSAGES_01B
/



CREATE INDEX BOOKER.I_PAQM_01B_ALL_NOLONG 
ON BOOKER.PAQ_MESSAGES_01B (MESSAGE_ID, REALM_NAME, SERVICE_NAME, QUEUE_NAME, MESSAGE_STATUS,
 NEXT_REDRIVE_DATE_UTC, SUBJECT_KEY, MESSAGE_REALM_NAME, CURRENT_REDRIVE_COUNT, REDRIVE_TIMEOUT_SECONDS, BASE_REDRIVE_INTERVAL_SECONDS
, REDRIVE_START_DATE_UTC, REDRIVE_FINISHED_DATE_UTC, REDRIVE_ERROR_DATE_UTC, RECORD_VERSION_NUMBER, LAST_UPDATED,CREATION_DATE,DOMAIN,PRIORITY)
PCTFREE 5 INITRANS 24 MAXTRANS 255   TABLESPACE REPLICATION_IDX
/



CREATE INDEX BOOKER.I_PAQM_01B_SWIDE ON 
BOOKER.PAQ_MESSAGES_01B (MESSAGE_STATUS, QUEUE_NAME, REALM_NAME, SERVICE_NAME, DOMAIN, 
			 NEXT_REDRIVE_DATE_UTC, REDRIVE_FINISHED_DATE_UTC,
 			 MESSAGE_ID, SUBJECT_KEY, MESSAGE_REALM_NAME, CURRENT_REDRIVE_COUNT, 
			 REDRIVE_TIMEOUT_SECONDS, BASE_REDRIVE_INTERVAL_SECONDS, RECORD_VERSION_NUMBER, 
			 REDRIVE_START_DATE_UTC, REDRIVE_ERROR_DATE_UTC)
PCTFREE 10 INITRANS 32 MAXTRANS 255 TABLESPACE REPLICATION_IDX
/



CREATE OR REPLACE TRIGGER BOOKER.RTST_PAQ_MESSAGES_01B
BEFORE INSERT OR UPDATE
ON BOOKER.PAQ_MESSAGES_01B
FOR EACH ROW
BEGIN
  --
  -- The LAST_UPDATED column is in UTC time
  --
  :new.last_updated :=
     sysdate - time_util.local_time_offset_from_utc();
EXCEPTION
  WHEN OTHERS THEN
    -- raise error if we cannot set the last_updated date
    raise_application_error(-20505, 'RTST_PAQ_MESSAGES_01B
    trigger failed.  Rolling back.'  || SQLERRM);
END;
/


ALTER TRIGGER BOOKER.RTST_PAQ_MESSAGES_01B ENABLE
/

CREATE OR REPLACE TRIGGER BOOKER.RVN_PAQ_MESSAGES_01B
   BEFORE INSERT OR UPDATE
   on BOOKER.PAQ_MESSAGES_01B
FOR EACH ROW
begin
 IF (NOT (dbms_snapshot.i_am_a_refresh) AND dbms_reputil.replication_is_on) THEN
   IF NOT dbms_reputil.from_remote THEN
      if INSERTING then
         if :new.record_version_number is not null then
            raise_application_error(-20001,
                'RVN trigger: Application may not insert record_version_number');
         else
            :new.record_version_number:=1;
         end if;
      end if;
      if UPDATING then
         if :new.record_version_number != :old.record_version_number then
            raise_application_error(-20001,
                'RVN trigger: Application may not update record_version_number');
         else
            :new.record_version_number:=nvl(:old.record_version_number,1)+1;
         end if;
      end if;
   end if;
 end if;
end;
/

ALTER TRIGGER BOOKER.RVN_PAQ_MESSAGES_01B ENABLE
/






