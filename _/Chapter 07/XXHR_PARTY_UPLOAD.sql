DROP TABLE XXHR.XXHR_PARTY_UPLOAD CASCADE CONSTRAINTS;

CREATE TABLE XXHR.XXHR_PARTY_UPLOAD
( TXN_ID                NUMBER, 
  PARTY_TYPE            VARCHAR2(30 BYTE),
  ORG_NAME              VARCHAR2(200 BYTE),
  PERSON_TITLE          VARCHAR2(10 BYTE),
  PERSON_FIRST_NAME     VARCHAR2(100 BYTE),
  PERSON_LAST_NAME      VARCHAR2(100 BYTE),
  PHONE_TYPE            VARCHAR2(30 BYTE),
  PHONE                 VARCHAR2(40 BYTE),
  EMAIL                 VARCHAR2(200 BYTE),
  ADDRESS_TYPE          VARCHAR2(30  byte),
  ADDRESS_LINE_1        VARCHAR2(240 BYTE),
  ADDRESS_LINE_2        VARCHAR2(240 BYTE),
  ADDRESS_LINE_3        VARCHAR2(240 BYTE),
  CITY                  VARCHAR2(30 BYTE),
  COUNTY                VARCHAR2(60 BYTE),  
  POSTAL_CODE           VARCHAR2(30 BYTE),
  COUNTRY               VARCHAR2(60 BYTE),  
  TXN_STATUS            VARCHAR2(30 BYTE),
  TXN_MSG               VARCHAR2(4000 BYTE),
  TXN_DATE              DATE
);


DROP SYNONYM APPS.XXHR_PARTY_UPLOAD;

CREATE SYNONYM APPS.XXHR_PARTY_UPLOAD FOR XXHR.XXHR_PARTY_UPLOAD;