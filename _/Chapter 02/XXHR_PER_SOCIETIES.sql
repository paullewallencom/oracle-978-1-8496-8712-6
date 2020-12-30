-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_PER_SOCIETIES
--            TYPE:   Create Table SCript
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/05/2012
--
--     DESCRIPTION:
--
--        This creates a table for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
-----------------------------------------------------------------------------------------------------
CREATE TABLE XXHR.XXHR_PER_SOCIETIES
  ( SOCIETY_ID 			NUMBER NOT NULL ENABLE,
    CODE       			VARCHAR2(20 BYTE) NOT NULL ENABLE,
    DATE_START 			DATE,
    DATE_END 			DATE,
    SUBS_AMOUNT        VARCHAR2(20 BYTE),
    SUBS_PERIOD        VARCHAR2(20 BYTE),
    SUBS_TOTAL         VARCHAR2(20 BYTE),
    SUBS_HOLD          VARCHAR2(10 BYTE),
    ATTRIBUTE_CATEGORY VARCHAR2(30 BYTE),
    ATTRIBUTE1         VARCHAR2(150 BYTE),
    ATTRIBUTE2         VARCHAR2(150 BYTE),
    ATTRIBUTE3         VARCHAR2(150 BYTE),
    ATTRIBUTE4         VARCHAR2(150 BYTE),
    ATTRIBUTE5         VARCHAR2(150 BYTE),
    ATTRIBUTE6         VARCHAR2(150 BYTE),
    ATTRIBUTE7         VARCHAR2(150 BYTE),
    ATTRIBUTE8         VARCHAR2(150 BYTE),
    ATTRIBUTE9         VARCHAR2(150 BYTE),
    ATTRIBUTE10        VARCHAR2(150 BYTE),
    ATTRIBUTE11        VARCHAR2(150 BYTE),
    ATTRIBUTE12        VARCHAR2(150 BYTE),
    ATTRIBUTE13        VARCHAR2(150 BYTE),
    ATTRIBUTE14        VARCHAR2(150 BYTE),
    ATTRIBUTE15        VARCHAR2(150 BYTE),
    ATTRIBUTE16        VARCHAR2(150 BYTE),
    ATTRIBUTE17        VARCHAR2(150 BYTE),
    ATTRIBUTE18        VARCHAR2(150 BYTE),
    ATTRIBUTE19        VARCHAR2(150 BYTE),
    ATTRIBUTE20        VARCHAR2(150 BYTE),
    LAST_UPDATE_DATE 	DATE,
    LAST_UPDATED_BY   NUMBER(15,0),
    LAST_UPDATE_LOGIN NUMBER(15,0),
    CREATED_BY        NUMBER(15,0),
    CREATION_DATE 	DATE,
	PERSON_ID 		NUMBER(10, 0)
  )
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
  )
  TABLESPACE XXHR ;