/* =========================================================================
   Module Name: XXHR_PARTY_UPLOAD_SEQ.sql

   Description: Sequence for Party upload transaction identifier

   =========================================================================
   Amendments:

   Amended By    Date       Version  Reason
   ------------  ---------  -------  ------
   A PENVER      05-JAN-12  1.0      Initial creation
   =======================================================================*/

DROP SEQUENCE XXHR.XXHR_PARTY_UPLOAD_SEQ;

DROP SYNONYM XXHR_PARTY_UPLOAD_SEQ;

CREATE SEQUENCE XXHR.XXHR_PARTY_UPLOAD_SEQ
INCREMENT BY  1
START WITH    1000
MAXVALUE      9999999
NOCACHE;

CREATE SYNONYM XXHR_PARTY_UPLOAD_SEQ FOR XXHR.XXHR_PARTY_UPLOAD_SEQ;