CREATE OR REPLACE PACKAGE XXHR_PARTY_UPLOAD_PKG IS

/* =========================================================================
   Module Name: XXHR_UPLOAD_PARTY_PKG.sql
   Description: This package is used to bulk upload data to a temporary table 
                using desktop integration.
   =========================================================================

   Public Module Description:
   Name                         Description
   ---------------------------  --------------------------------------------
   update_details               This procedure controls the updating of
                                party record details.
   =========================================================================

   Amendments:
   Amended By    Date       Version  Reason
   ----------    -----------  -------  ------
   A Penver      12-SEP-2012  1.0      Initial creation
   =======================================================================*/

-- **********************************

-- DEFINE PUBLIC FUNCTIONS/PROCEDURES

-- **********************************

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
       P_COUNTRY          IN XXHR_PARTY_UPLOAD.COUNTRY%TYPE) RETURN VARCHAR2;

END XXHR_PARTY_UPLOAD_PKG;
/
