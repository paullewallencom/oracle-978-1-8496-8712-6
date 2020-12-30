CREATE OR REPLACE PACKAGE BODY XXHR_PARTY_UPLOAD_PKG IS

/* =========================================================================

   Module Name: XXHR_PARTY_UPLOAD_PKG.sql

   Description: This package is used to uplaod party records using desktop integrator.

   =========================================================================
   Module History:

   Name                         Object     Type     Added  Return Type
  ---------------------------  ---------  -------  -----  -----------
  update_details               Procedure  Public   1.0    N/A
  =========================================================================

   Amendments:

   Amended By    Date       Version  Reason
  ----------    ---------  -------  ------
  A Penver     30-SEP-12  1.0      Initial creation
   =======================================================================*/

-- ************************
-- DEFINE PRIVATE VARIABLES
-- ************************

   G_EXCEPTION EXCEPTION;
   g_message_text VARCHAR2 (2000);


-- **********************************
-- DEFINE PUBLIC FUNCTIONS/PROCEDURES
-- **********************************

/* =========================================================================
  PROCEDURE:   update_details
  =========================================================================
  DESCRIPTION: This procedure controls the uploading of mass vehicle update details.
  =========================================================================
  PARAMETERS:
  =======================================================================*/

   FUNCTION UPLOAD_DATA
    (  P_PARTY_TYPE       IN XXHR_PARTY_UPLOAD.PARTY_TYPE%TYPE,
       P_ORG_NAME         IN XXHR_PARTY_UPLOAD.ORG_NAME%TYPE,
       P_PERSON_TITLE     IN XXHR_PARTY_UPLOAD.PERSON_TITLE%TYPE,
       P_PERSON_FIRST_NAME    IN XXHR_PARTY_UPLOAD.PERSON_FIRST_NAME%TYPE,
       P_PERSON_LAST_NAME     IN XXHR_PARTY_UPLOAD.PERSON_LAST_NAME %TYPE,
       P_PHONE_TYPE       IN XXHR_PARTY_UPLOAD.PHONE_TYPE%TYPE,
       P_PHONE            IN XXHR_PARTY_UPLOAD.PHONE%TYPE,
       P_EMAIL            IN XXHR_PARTY_UPLOAD.EMAIL%TYPE,
       P_ADDRESS_TYPE     IN XXHR_PARTY_UPLOAD.ADDRESS_TYPE%TYPE,
       P_ADDRESS_LINE_1   IN XXHR_PARTY_UPLOAD.ADDRESS_LINE_1%TYPE,
       P_ADDRESS_LINE_2   IN XXHR_PARTY_UPLOAD.ADDRESS_LINE_2%TYPE,
       P_ADDRESS_LINE_3   IN XXHR_PARTY_UPLOAD.ADDRESS_LINE_3%TYPE,
       P_CITY             IN XXHR_PARTY_UPLOAD.CITY %TYPE,
       P_COUNTY           IN XXHR_PARTY_UPLOAD.COUNTY%TYPE,  
       P_POSTAL_CODE      IN XXHR_PARTY_UPLOAD.POSTAL_CODE%TYPE,
       P_COUNTRY          IN XXHR_PARTY_UPLOAD.COUNTRY%TYPE) RETURN VARCHAR2 IS

     
   BEGIN

      INSERT INTO XXHR_PARTY_UPLOAD
       (TXN_ID, 
        PARTY_TYPE,
        ORG_NAME,
        PERSON_TITLE,
        PERSON_FIRST_NAME,
        PERSON_LAST_NAME,
        PHONE_TYPE,
        PHONE,
        EMAIL,
        ADDRESS_TYPE,
        ADDRESS_LINE_1,
        ADDRESS_LINE_2,
        ADDRESS_LINE_3,
        CITY,
        COUNTY,  
        POSTAL_CODE,
        COUNTRY,  
        TXN_STATUS,
        TXN_MSG,
        TXN_DATE)
    VALUES
       (XXHR_PARTY_UPLOAD_SEQ.NEXTVAL,
        P_PARTY_TYPE,
        P_ORG_NAME,
        P_PERSON_TITLE,
        P_PERSON_FIRST_NAME,
        P_PERSON_LAST_NAME,
        P_PHONE_TYPE,
        P_PHONE,
        P_EMAIL,
        P_ADDRESS_TYPE,
        P_ADDRESS_LINE_1,
        P_ADDRESS_LINE_2,
        P_ADDRESS_LINE_3,
        P_CITY,
        P_COUNTY,  
        P_POSTAL_CODE,
        P_COUNTRY,  
        'LOADED',
        NULL,
        NULL);
      
      RETURN NULL;
   EXCEPTION WHEN OTHERS THEN

       RETURN sqlerrm;

   END upload_data;

END XXHR_PARTY_UPLOAD_PKG;