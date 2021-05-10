ALTER TABLE BOOKER.PPR_REPORT_LINEITEM_AGGS ADD WAREHOUSE_ID char(4) default 'ZZZ8' not null;
ALTER TABLE BOOKER.PPR_REPORT_LINEITEM_AGGS ADD START_DATE_UTC DATE default '12-MAY-05' not null;

CREATE OR REPLACE TRIGGER "BOOKER"."WID_PPR_REPORT_LINEITEM_AGGS"
BEFORE INSERT
ON booker.PPR_REPORT_LINEITEM_AGGS
FOR EACH ROW
BEGIN
   select WAREHOUSE_ID, START_DATE_UTC INTO :new.WAREHOUSE_ID, :new.START_DATE_UTC FROM BOOKER.PPR_REPORT_AGGS WHERE PPR_REPORT_ID=:new.PPR_REPORT_ID;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
    SELECT 'ZZZ9', '13-MAY-05' INTO :new.WAREHOUSE_ID, :new.START_DATE_UTC FROM dual;
    WHEN OTHERS THEN
     raise_application_error(-20505, 'wid_ppr_report_lineitem_aggs trigger failed. Rolling back.'  || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER "BOOKER"."AUD_PPR_REPORT_LINEITEM_AGGS"
BEFORE INSERT OR UPDATE
ON BOOKER.PPR_REPORT_LINEITEM_AGGS
REFERENCING NEW AS NEW FOR EACH ROW
DECLARE osuser VARCHAR2(8);
BEGIN
  --
  -- get who is making the DML change from the session
  --
  osuser := session_info.osuser;
  --
  IF (NOT (dbms_snapshot.i_am_a_refresh) AND dbms_reputil.replication_is_on AND osuser <> 'xunzhan') THEN
    IF NOT dbms_reputil.from_remote THEN
      IF INSERTING THEN
        :new.created_by := osuser;
        :new.created_date_utc := sysdate - time_util.local_time_offset_from_utc();
      END IF;
      :new.last_updated_by := osuser;
      :new.last_updated_date_utc := sysdate - time_util.local_time_offset_from_utc();
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- raise error if we cannot set auditing fields
    raise_application_error(-20505, 'BOOKER.AUD_PPR_REPORT_LINEITEM_AGGS Failed. Rolling Back.' || SQLERRM);
END;
/

ALTER TABLE BOOKER.WORK_AREA_PROCESS_FUNCTIONS ADD WAREHOUSE_ID char(4) default 'ZZZ8' not null;

CREATE OR REPLACE TRIGGER "BOOKER"."WORKAREA_PROCFUNC_WHIDS"
BEFORE INSERT
ON booker.WORK_AREA_PROCESS_FUNCTIONS
FOR EACH ROW
BEGIN
   select WAREHOUSE_ID INTO :new.WAREHOUSE_ID FROM BOOKER.WORK_AREAS WHERE WORK_AREA_ID=:new.work_area_id;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
    SELECT 'ZZZ9' INTO :new.WAREHOUSE_ID FROM dual;
    WHEN OTHERS THEN
     raise_application_error(-20505, 'workarea_procfunc_whids trigger failed. Rolling back.'  || SQLERRM);
END;
/

ALTER TABLE BOOKER.DATA_PROC_RESOURCE_VERSIONS ADD WAREHOUSE_ID char(4) default 'ZZZ8' not null;

CREATE OR REPLACE TRIGGER "BOOKER"."DATAPROC_RESCVER_WHIDS"
BEFORE INSERT
ON booker.DATA_PROC_RESOURCE_VERSIONS
FOR EACH ROW
BEGIN
   :new.WAREHOUSE_ID := SUBSTR(:new.resource_key, 1, 4);
   EXCEPTION
    WHEN OTHERS THEN
     -- raise error if we cannot set the warehouse_id
     raise_application_error(-20505, 'dataproc_rescver_whids trigger failed. Rolling back.'  || SQLERRM);
END;
/

ALTER TABLE BOOKER.DATA_PROC_RESOURCE_TIMESTAMPS ADD WAREHOUSE_ID char(4) default 'ZZZ8' not null;

CREATE OR REPLACE TRIGGER "BOOKER"."DATAPROC_RESCTIME_WHIDS"
BEFORE INSERT
ON booker.DATA_PROC_RESOURCE_TIMESTAMPS
FOR EACH ROW
BEGIN
 :new.WAREHOUSE_ID := (CASE :new.RESOURCE_CLASS WHEN 'amazon.fclm.processlabor.dataprocessing.support.UpdatableTimestampResourceWrapper' THEN substr(:new.resource_key, instr(:new.resource_key, '-')+1, 4) ELSE substr(:new.resource_key, 0, 4) END);
   EXCEPTION
    WHEN OTHERS THEN
     -- raise error if we cannot set the warehouse_id
     raise_application_error(-20505, 'dataproc_resctime_whids trigger failed. Rolling back.'  || SQLERRM);
END;
/


CREATE OR REPLACE TRIGGER "BOOKER"."DATA_PROC_RES_TIMESTAMPS_RVN"
BEFORE INSERT OR UPDATE ON BOOKER.DATA_PROC_RESOURCE_TIMESTAMPS
FOR EACH ROW
DECLARE osuser VARCHAR2(8);
begin
  osuser := session_info.osuser;
  IF (NOT (dbms_snapshot.i_am_a_refresh) AND dbms_reputil.replication_is_on AND osuser<>'xunzhan') THEN
    IF NOT dbms_reputil.from_remote THEN
      if INSERTING then
        if :new.record_version_number is not null then
          raise_application_error(-20001, 'RVN trigger: Application may not insert record_version_number');
        else
          :new.record_version_number:=1;
        end if;
      end if;
      if UPDATING then
        if :new.record_version_number != :old.record_version_number then
          raise_application_error(-20001, 'RVN trigger: Application may not update record_version_number');
        else
          :new.record_version_number:=nvl(:old.record_version_number,1)+1;
        end if;
      end if;
    end if;
  end if;
end;
/
