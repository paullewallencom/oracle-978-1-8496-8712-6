CREATE OR REPLACE PACKAGE APPS.XXINO_VEH_MASS_UPDATE_PKG IS

---------------------------------------------------------------------------------------------------------------------------
--
--            NAME:   XXINO_VEH_MASS_UPDATE_PKG
--            TYPE:   Package Specification
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   04/08/2012
--
--     DESCRIPTION:
--
--        This package contains the API's related to mass vehicle update
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  ------------- ---------------- --------  -------------------------------------------------------------------
--     1.0      04/08/2012    Andy Penver       N/A       Initial Version
----------------------------------------------------------------------------------------------------------------------------
 v_logfile			 		  NUMBER   := fnd_file.LOG;
 v_outfile		 	 		  NUMBER   := fnd_file.output;
 g_Debug   		 	 		  BOOLEAN  := TRUE; 
 g_success_count      NUMBER := 0;
 g_total_count        NUMBER := 0;
 g_fail_count         NUMBER := 0;
 
 -- Global Constants
 gc_success             NUMBER   := 0;
 gc_warning             NUMBER   := 1;
 gc_failed              NUMBER   := 2;
 gc_error               NUMBER   := 3; 
 gShowFailed            BOOLEAN  := FALSE;
 
  -- Global Variables
  gv_request_id          NUMBER        := -1;
  gv_user_id             NUMBER        := -1;
  gv_login_id            NUMBER        := -1;
  
  -- Global PL/SQL tables
  TYPE msg_tbl_type IS TABLE OF VARCHAR2(10000) INDEX BY BINARY_INTEGER;
  g_success_tbl          msg_tbl_type;
  g_failed_tbl           msg_tbl_type;
 
 g_sr_note         VARCHAR2(4000) := null;
   -- -------------------------------------------------------------------------
   -- PROCEDURE: process_update
   -- -------------------------------------------------------------------------
   -- This procedure fetches all of the records from the mass update temporary table
   -- and performs the following updates
   --
   --    * Update Service Request with Vehicle Registration Number
   --    * Update Service Request Notes with Vehicle Details
   --    * Create or Update Customer Installation Site
   --    * Create or Update Customer Contacts
   -- -------------------------------------------------------------------------

   PROCEDURE process_update(p_errbuf  OUT VARCHAR2
                           ,p_retcode OUT NUMBER);

END XXINO_VEH_MASS_UPDATE_PKG;
/
