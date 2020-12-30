CREATE OR REPLACE PACKAGE BODY APPS.XXINO_VEH_MASS_UPDATE_PKG IS

---------------------------------------------------------------------------------------------------------------------------
--
--            NAME:   XXINO_VEH_MASS_UPDATE_PKG
--            TYPE:   Package Body
-- ORIGINAL AUTHOR:   Andy Penver 
--            DATE:   06/08/2012
--
--     DESCRIPTION:
--
--        This package contains the API's related to ORT Opt In/Out Notification generation
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL      DESCRIPTION
--     -------  ------------- ---------------- --------   -------------------------------------------------------------------
--     1.0      24/11/2011    Andy Penver      N/A        Initial Version
----------------------------------------------------------------------------------------------------------------------------


    -- Local Procedure
    -- This procedure clears down the message tables used in the pack generation programs

    --************************************--
    --*                                  *--
    --* PROCEDURE NAME : INITIALIZE_MSG  *--
    --*                                  *--
    --************************************--
    PROCEDURE initialize_msg (p_msg_tbl IN OUT Msg_Tbl_Type) IS
    BEGIN

        p_msg_tbl.DELETE;

    END;
    
    -- Local Procedure
    -- This procedure creates blank lines in the output file
    -- A parameter passed in creates the number of blank lines

    --************************************--
    --*                                  *--
    --* PROCEDURE NAME : add_lines       *--
    --*                                  *--
    --************************************--

    PROCEDURE add_lines (p_lines IN NUMBER DEFAULT 1) IS

    BEGIN

        FOR i IN 1..p_lines LOOP

                fnd_file.put_line(v_outfile,'');

        END LOOP;

    END;    
    
    
    -- LOCAL PROCEDURE
    --
    -- The add_msg procedure adds messages into a PL/SQL table
    -- There are two types of message table
    --
    -- 1. WARNINGS
    -- 2. ERRORS

    --************************************--
    --*                                  *--
    --* PROCEDURE NAME : ADD_MSG         *--
    --*                                  *--
    --************************************--

    PROCEDURE add_msg (msg IN VARCHAR2, p_msg_tbl IN OUT NOCOPY Msg_Tbl_Type) IS

     b_found BOOLEAN := FALSE;

    BEGIN
        FOR i in 1..p_msg_tbl.COUNT
        LOOP
            IF p_msg_tbl (i) = msg THEN
                b_found := TRUE;
            END IF;
        END LOOP;

        IF NOT b_found THEN
            p_msg_tbl (p_msg_tbl.count+1) := msg;
        END IF;
    END; 
    
    
    -- LOCAL PROCEDURE
    --
    -- The report_exceptions procedure shows the contents of the records written to the PL/SQL table
    -- if the boolean variables gShowWarnings or gShowFailed are set to TRUE

    --***************************************--
    --*                                     *--
    --* PROCEDURE NAME : REPORT_EXCEPTIONS  *--
    --*                                     *--
    --***************************************--

    PROCEDURE report_exceptions IS
    BEGIN

        -- Print the Successful Records
        FOR i IN 1..g_success_tbl.COUNT
        LOOP

            fnd_file.put_line(v_outfile,g_success_tbl(i));

        END LOOP;

        IF  gShowFailed THEN

            add_lines(3);

            -- Print the Failed Report
            FOR i IN 1..g_failed_tbl.COUNT
            LOOP

                fnd_file.put_line(v_outfile,g_failed_tbl(i));

            END LOOP;

        END IF;


    END;
    
    --************************************--
    --*                                  *--
    --* PROCEDURE NAME : REPORT_FOOTER   *--
    --*                                  *--
    --************************************--

    PROCEDURE report_footer IS
    BEGIN

        add_lines(2);
        fnd_file.put_line(v_outfile,'                   Total Successfully Processed Records : '||g_success_count);
        fnd_file.put_line(v_outfile,'                 Total Unsuccessfully Processed Records : '||g_fail_count);
        fnd_file.put_line(v_outfile,'                                Total Processed Records : '||g_total_count);
        add_lines(1);
        fnd_file.put_line(v_outfile,'                                                      *** End Of Report ***');

    END; 
    
    -- Local procedure
    -- The write_debug procedure writes to the concurrent program log file if the P_DEBUG parameter is set to Y

    --************************************--
    --*                                  *--
    --* PROCEDURE NAME : WRITE_DEBUG     *--
    --*                                  *--
    --************************************--

    PROCEDURE Write_Debug (p_logfile IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        -- Check the Debug profile option
        IF g_Debug THEN
            fnd_file.put_line (p_logfile, p_msg);
        END IF;
    END;    



    PROCEDURE create_mvu_header IS
    BEGIN


        add_lines(3);

       -- Heading for Failed Exception report
        add_msg('                                                *** Unsuccessfully Processed Records Requiring Team Action ***', g_failed_tbl);
        add_msg(' ', g_failed_tbl);
        add_msg('                                                  |Customer       |Service        |Vehicle      |Failed', g_failed_tbl);
        add_msg('Customer Name                                     |Account Number |Request Number |Reg          |Reason', g_failed_tbl);
        add_msg('--------------------------------------------------|---------------|---------------|-------------|-------------------------------', g_failed_tbl);

        -- Heading for Warning report for packs successfully sent
        fnd_file.put_line(v_outfile,'Run Date : ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') );
        fnd_file.put_line(v_outfile,'                                                                *** Mass Vehicle Update Report ***');
        add_lines(1);
        --fnd_file.put_line(v_outfile,'1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
        fnd_file.put_line(v_outfile,'                                                  |Customer       |Service        |Vehicle      |Vehicle   |Vehicle   |Address   |Contact   |');
        fnd_file.put_line(v_outfile,'Customer Name                                     |Account Number |Request Number |Reg          |Note Added|Reg Added |Updated   |Updated   |');
        fnd_file.put_line(v_outfile,'--------------------------------------------------|---------------|---------------|-------------|----------|----------|----------|----------|');

    END create_mvu_header;
    
    
    FUNCTION valid_incident_type (p_incident_type_id IN cs_incidents_all.incident_type_id%TYPE) RETURN BOOLEAN IS
    
        CURSOR Get_Incident_Type IS
        SELECT incident_type_id
          FROM cs_incident_types_vl
         WHERE UPPER(name) = 'INSTALLATION'; 
         
         v_incident_type_id cs_incidents_all.incident_type_id%TYPE;

    BEGIN
    
       OPEN Get_Incident_Type;
       FETCH Get_Incident_Type INTO v_incident_type_id;
       CLOSE Get_Incident_Type;
       
       IF v_incident_type_id = p_incident_type_id THEN
       
          RETURN TRUE;
          
       END IF;
       
       RETURN FALSE;
   EXCEPTION WHEN OTHERS THEN
   
      RETURN FALSE;

   END;
   
    FUNCTION invalid_incident_status (p_incident_status_id IN cs_incidents_all.incident_status_id%TYPE) RETURN BOOLEAN IS
    
        cursor get_incident_status is
        SELECT incident_status_id, name
          FROM cs_incident_statuses_vl
         WHERE UPPER(name) IN ('CLOSED', 'CANCELLED'); 
         
         v_incident_status_id cs_incidents_all.incident_status_id%TYPE;

    begin
              
       for status_rec in get_incident_status loop
 
         if status_rec.incident_status_id = p_incident_status_id then
            fnd_file.put_line(v_logfile,'FAILED - Status is '||status_rec.name);
            return TRUE;
         END IF;
       END LOOP;
       
       RETURN FALSE;
   EXCEPTION WHEN OTHERS THEN
   
      RETURN FALSE;

   END;   
   
   
   function address_exists_in_party_sites (p_address_1 in varchar2,
                                           p_postal_code IN VARCHAR2,
                                           p_city in varchar2,
                                           p_country in varchar2) return NUMBER is
                                           
      CURSOR get_location  is
      SELECT  MAX(party_site_id) party_site_id
         FROM HZ_PARTY_SITES HZS,
              hz_locations hzl
        where hzs.location_id = hzl.location_id
          and replace(upper(address1), ' ', '') = replace(upper(p_address_1), ' ', '')
          and replace(upper(postal_code), ' ', '') = replace(upper(p_postal_code), ' ', '')
          and replace(upper(city), ' ', '') = replace(upper(p_city), ' ', '')
          and replace(upper(country), ' ', '') = replace(upper(p_country), ' ', '')
          and hzs.status = 'A';

      
      v_party_site_id HZ_PARTY_SITES.PARTY_SITE_ID%TYPE;

   begin
   
      fnd_file.put_line(v_logfile,'110 - Parameters for address search -> '||p_address_1||p_postal_code||p_city||p_country);
   
      open get_location;
      fetch get_location into v_party_site_id;
      close get_location;
      
      if v_party_site_id is null then
      
         return 0;
      END if;
      
      return v_party_site_id;
   
   EXCEPTION WHEN OTHERS THEN
   
      RETURN 0;
   
   END;
   
    -- -------------------------------------------------------------------------
    -- PROCEDURE: update_service_request
    -- -------------------------------------------------------------------------  
    procedure update_service_request( p_incident_number   in cs_incidents.incident_number%type,
                                      p_incident_rec 	    in cs_servicerequest_pub.service_request_rec_type,
                                      p_notes_tbl	        in cs_servicerequest_pub.notes_table,
                                      p_contact_tbl	      in cs_servicerequest_pub.contacts_table,
                                      --p_resp_id           in number,
                                      x_return_status     out varchar2,
                                      x_error_msg         OUT VARCHAR2) IS
  
      cs_incident_out_rec   cs_servicerequest_pub.sr_update_out_rec_type;
      
      lx_return_status VARCHAR2(1);
      lx_msg_count number;
      lx_msg_data varchar2(2000);
      lx_request_id number;
      lx_request_number varchar2(50);
      lx_interaction_id number;
      lx_workflow_process_id NUMBER;
  
      lx_msg_index_out NUMBER;
      v_msg varchar2(240);
  
      v_sr_rec cs_servicerequest_pub.service_request_rec_type;
      v_api_version         NUMBER := 3.0;
      v_init_msg_List       VARCHAR2 (1)    := 'T';
      l_commit              VARCHAR2 (10)   := 'F';
      l_auto_assign         VARCHAR2  (10)  := 'N';
  
      v_object_version_number NUMBER;
      v_request_id NUMBER;
  
      CURSOR Get_resp_appl_id (cp_resp_id IN NUMBER) IS
      SELECT application_id
        FROM fnd_responsibility_vl
       WHERE responsibility_id = cp_resp_id;
  
       CURSOR Get_Incident_ID (cp_incident_number IN NUMBER) IS
       SELECT inc.incident_id, inc.object_version_number
         FROM cs_incidents_all_vl inc
        WHERE inc.incident_id = cp_incident_number;
  
  
     BEGIN
  
         OPEN Get_Incident_ID(p_incident_number);
         FETCH Get_Incident_ID INTO v_request_id, v_object_version_number;
         CLOSE Get_Incident_ID;
  
        /* calls the public API for creating service requests */
        cs_servicerequest_pub.update_servicerequest(p_api_version => 4.0, 
                                                    p_init_msg_list  => FND_API.G_TRUE,
                                                    p_commit  => FND_API.G_TRUE,
                                                    x_return_status => lx_return_status,
                                                    x_msg_count => lx_msg_count,
                                                    x_msg_data  => lx_msg_data,
                                                    p_request_id  => v_request_id,
                                                    p_request_number => p_incident_number,
                                                    p_object_version_number => v_object_version_number,
                                                    p_resp_appl_id  => FND_PROFILE.VALUE('RESP_APPL_ID'),
                                                    p_resp_id => FND_PROFILE.VALUE('RESP_ID'),
                                                    p_last_updated_by => FND_PROFILE.VALUE('USER_ID'),
                                                    p_last_update_date  => SYSDATE,
                                                    p_service_request_rec => p_incident_rec,
                                                    p_notes  => p_notes_tbl,
                                                    p_contacts => p_contact_tbl,
                                                    x_sr_update_out_rec	=> cs_incident_out_rec);
        /*cs_servicerequest_pub.Update_ServiceRequest(  p_api_version => 2.0,
                                                      p_init_msg_list => FND_API.G_TRUE,
                                                      p_commit => FND_API.G_TRUE,
                                                      x_return_status => lx_return_status,
                                                      x_msg_count => lx_msg_count,
                                                      x_msg_data  => lx_msg_data,
                                                      p_request_id => p_incident_id,
                                                      p_request_number => v_request_number,
                                                      p_object_version_number  => v_object_version_number,
                                                      p_resp_appl_id => FND_PROFILE.VALUE('RESP_APPL_ID'),
                                                      p_resp_id => FND_PROFILE.VALUE('RESP_ID'),
                                                      p_last_updated_by  => FND_PROFILE.VALUE('USER_ID'),
                                                      p_last_update_date  => sysdate,
                                                      p_service_request_rec => p_incident_rec,
                                                      p_notes => p_notes_tbl,
                                                      p_contacts => p_contact_tbl,
                                                      x_workflow_process_id => lx_workflow_process_id,
                                                      x_interaction_id => lx_interaction_id);*/
  
  
  
      x_return_status := lx_return_status;
  
  
      /* return the error message if there is a problem creating the service request */
      IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
          IF (FND_MSG_PUB.Count_Msg > 1) THEN
          FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
              fnd_msg_pub.get(p_msg_index => j,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
  
              IF lx_msg_data IS NOT NULL THEN
                 x_error_msg := lx_msg_data;
              END IF;
          END LOOP;
          ELSE
              fnd_msg_pub.get(p_msg_index => 1,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
              x_error_msg := lx_msg_data;
          END IF;
      END IF;
  
      commit;
    END;

    -- -------------------------------------------------------------------------
    -- PROCEDURE: create_location
    -- -------------------------------------------------------------------------  
    PROCEDURE create_location (p_location_rec      IN HZ_LOCATION_V2PUB.LOCATION_REC_TYPE,
                               x_location_id       OUT hz_locations.location_id%TYPE,
                               x_return_status     out VARCHAR2,
                               x_error_msg         OUT VARCHAR2) IS
    
        lx_return_status  VARCHAR2(2000);
        lx_msg_count number;
        lx_msg_data VARCHAR2(2000);
        lx_msg_index_out NUMBER;  
    BEGIN
  
       HZ_LOCATION_V2PUB.CREATE_LOCATION
                 ( p_init_msg_list => FND_API.G_TRUE,
                   p_location_rec  => p_location_rec,
                   x_location_id   => x_location_id,
                   x_return_status => lx_return_status,
                   x_msg_count     => lx_msg_count,
                   x_msg_data      => lx_msg_data);
  
      x_return_status := lx_return_status;
  
      IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
          IF (FND_MSG_PUB.Count_Msg > 1) THEN
          FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
              fnd_msg_pub.get(p_msg_index => j,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
  
              IF lx_msg_data IS NOT NULL THEN
                 x_error_msg := lx_msg_data;
              END IF;
          END LOOP;
          ELSE
              fnd_msg_pub.get(p_msg_index => 1,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
              x_error_msg := lx_msg_data;
          END IF;
       END IF;
       
       commit;     
    END;  
  
    -- -------------------------------------------------------------------------
    -- PROCEDURE: create_party_site
    -- -----------------------------------------------------------------------e
  
    PROCEDURE create_party_site (p_party_site_rec    IN HZ_PARTY_SITE_V2PUB.PARTY_SITE_REC_TYPE,
                                 x_party_site_id     OUT hz_party_sites.party_site_id%TYPE,
                                 x_party_site_number OUT hz_party_sites.party_site_number%TYPE,
                                 x_return_status     out VARCHAR2,
                                 x_error_msg         OUT VARCHAR2) IS
    
        lx_return_status  VARCHAR2(2000);
        lx_msg_count number;
        lx_msg_data VARCHAR2(2000);
        lx_msg_index_out NUMBER;  
    BEGIN
  
        HZ_PARTY_SITE_V2PUB.CREATE_PARTY_SITE (
                      p_init_msg_list     => FND_API.G_TRUE,
                      p_party_site_rec    => p_party_site_rec,
                      x_party_site_id     => x_party_site_id,
                      x_party_site_number => x_party_site_number,
                      x_return_status     => lx_return_status,
                      x_msg_count         => lx_msg_count,
                      x_msg_data          => lx_msg_data);
  
      x_return_status := lx_return_status;
  
      IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
          IF (FND_MSG_PUB.Count_Msg > 1) THEN
          FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
              fnd_msg_pub.get(p_msg_index => j,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
  
              IF lx_msg_data IS NOT NULL THEN
                 x_error_msg := lx_msg_data;
              END IF;
          END LOOP;
          ELSE
              fnd_msg_pub.get(p_msg_index => 1,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
              x_error_msg := lx_msg_data;
          END IF;
       END IF;
       
       COMMIT;     
    END;  
  
    -- -------------------------------------------------------------------------
    -- PROCEDURE: create_party_site_use
    -- -------------------------------------------------------------------------
  
    PROCEDURE create_party_site_use (p_party_site_use_rec  IN HZ_PARTY_SITE_V2PUB.PARTY_SITE_USE_REC_TYPE,
                                     x_party_site_use_id   OUT NUMBER,
                                     x_return_status     out VARCHAR2,
                                     x_error_msg         OUT VARCHAR2) IS
    
        lx_return_status  VARCHAR2(2000);
        lx_msg_count number;
        lx_msg_data VARCHAR2(2000);
        lx_msg_index_out NUMBER;  
    BEGIN
  
        HZ_PARTY_SITE_V2PUB.CREATE_PARTY_SITE_USE
                           (p_init_msg_list      => FND_API.G_TRUE,
                            p_party_site_use_rec => p_party_site_use_rec,
                            x_party_site_use_id  => x_party_site_use_id,
                            x_return_status      => lx_return_status,
                            x_msg_count          => lx_msg_count,
                            x_msg_data           => lx_msg_data);
      
       x_return_status := lx_return_status;
     
       IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
          IF (FND_MSG_PUB.Count_Msg > 1) THEN
          FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
              fnd_msg_pub.get(p_msg_index => j,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
  
              IF lx_msg_data IS NOT NULL THEN
                 x_error_msg := lx_msg_data;
              END IF;
          END LOOP;
          ELSE
              fnd_msg_pub.get(p_msg_index => 1,
                              p_encoded => 'F',
                              p_data => lx_msg_data,
                              p_msg_index_out => lx_msg_index_out);
              x_error_msg := lx_msg_data;
          END IF;
       END IF;
       
       COMMIT;     
    END;  
  
    -- -------------------------------------------------------------------------
    -- FUNCTION: sr_contact_exists
    -- -------------------------------------------------------------------------                           
    PROCEDURE sr_contact_exists (p_incident_id IN NUMBER,
                                 p_first_name in varchar2,
                                 p_last_name in varchar2,
                                 p_em_contact_point_id OUT NUMBER,
                                 p_em_sr_contact_point_id OUT NUMBER,
                                 p_ph_contact_point_id OUT NUMBER,
                                 p_ph_sr_contact_point_id OUT NUMBER,
                                 p_sr_party_id OUT NUMBER) is
                              
      cursor get_sr_contacts ( cp_incident_id in number,
                                cp_first_name in varchar2,
                                cp_last_name in varchar2) IS
       select sub_first_name,  sub_last_name, src.contact_point_id
             , src.sr_contact_point_id, src.party_id, contact_point_type
        from cs_sr_contact_points_v src 
       where src.incident_id = cp_incident_id
         and REPLACE(UPPER(sub_first_name), ' ','') = REPLACE(UPPER(cp_first_name), ' ','')
         and REPLACE(UPPER(sub_last_name), ' ','') = REPLACE(UPPER(cp_last_name), ' ','');
       
       v_em_contact_point_id NUMBER := 0;
       v_em_sr_contact_point_id NUMBER := 0;
       v_ph_contact_point_id NUMBER := 0;
       v_ph_sr_contact_point_id NUMBER := 0;       
       v_sr_party_id NUMBER := 0;
    
    BEGIN
    
      FOR contact_rec IN get_sr_contacts (p_incident_id, 
                                          p_first_name, 
                                          p_last_name) LOOP
      
         v_sr_party_id := contact_rec.party_id;

         IF contact_rec.contact_point_type = 'EMAIL' THEN
            v_em_contact_point_id := contact_rec.contact_point_id;
            v_em_sr_contact_point_id := contact_rec.sr_contact_point_id;
         ELSIF contact_rec.contact_point_type = 'PHONE' THEN
            v_ph_contact_point_id := contact_rec.contact_point_id;
            v_ph_sr_contact_point_id := contact_rec.sr_contact_point_id;
         END IF;
      
      END LOOP;
      
      p_em_contact_point_id := v_em_contact_point_id;
      p_em_sr_contact_point_id := v_em_sr_contact_point_id;
      p_ph_contact_point_id := v_ph_contact_point_id;
      p_ph_sr_contact_point_id := v_ph_sr_contact_point_id;            
      p_sr_party_id := v_sr_party_id;
      
    END;
    -- -------------------------------------------------------------------------
    -- PROCEDURE: update_contact_point
    -- -------------------------------------------------------------------------     
    procedure update_contact_point(p_contact_point_id  in hz_contact_points.contact_point_id%TYPE,
                                    p_email             in varchar2,
                                    p_phone             in varchar2,
                                    p_phone_type   in VARCHAR2,
                                    p_party_id          in hz_parties.party_id%type,
                                    x_return_status     out varchar2,
                                    x_error_msg         OUT VARCHAR2)IS
    
        l_phone_rec          HZ_CONTACT_POINT_V2PUB.phone_rec_type;  
        l_email_rec          HZ_CONTACT_POINT_V2PUB.email_rec_type;  
        l_contact_point_rec  HZ_CONTACT_POINT_V2PUB.contact_point_rec_type;    
        l_contact_point_type VARCHAR2(10); 
        l_primary_flag       VARCHAR2(1) := 'Y';  
        l_area_code          HZ_CONTACT_POINTS.phone_area_code%TYPE;
        l_phone_number       HZ_CONTACT_POINTS.phone_number%TYPE;  
        l_email              HZ_CONTACT_POINTS.email_address%TYPE;  
        l_obj_num            number;    
        lx_return_status  VARCHAR2(2000);
        lx_msg_count number;
        lx_msg_data VARCHAR2(2000);
        lx_msg_index_out NUMBER; 
        
        CURSOR Get_Contact_Point (cp_contact_point_id IN NUMBER) IS
        SELECT object_version_number
          FROM hz_contact_points
         WHERE contact_point_id = cp_contact_point_id;   
      
      BEGIN
      
          if p_email is not null then
            l_contact_point_type := 'EMAIL';
            l_email_rec.email_address := p_email;
            l_email_rec.email_format := 'MAILTEXT';
          else
            l_contact_point_type := 'PHONE';
            l_phone_rec.phone_country_code :=  SUBSTR(REPLACE(p_phone, ' ', ''), 1, 2);
            l_phone_rec.phone_area_code   := SUBSTR(REPLACE(p_phone, ' ', ''), 3, 4);  
            l_phone_rec.phone_number      := SUBSTR(REPLACE(p_phone, ' ', ''), 7, 10);  
            l_phone_rec.phone_line_type   := NVL(p_phone_type, 'GEN'); 
            l_contact_point_rec.primary_flag := 'Y';                     
          END IF;
          
          OPEN Get_Contact_Point (p_contact_point_id);
          FETCH Get_Contact_Point INTO l_obj_num;
          CLOSE Get_Contact_Point;
      
   
          l_contact_point_rec.contact_point_type  := l_contact_point_type;
                        
          
          --PHONE primary and secondary  
          l_contact_point_rec.status              := 'A';  
          --l_contact_point_rec.owner_table_name    := 'HZ_PARTIES';  
          --l_contact_point_rec.owner_table_id      := p_party_id;  
          l_contact_point_rec.primary_flag        := l_primary_flag;  
          l_contact_point_rec.content_source_type := 'USER_ENTERED';  
          l_contact_point_rec.contact_point_id    := p_contact_point_id;     
      
      
          hz_contact_point_v2pub.update_contact_point  ( p_init_msg_list          => fnd_api.g_false  , 
                                                         p_contact_point_rec      => l_contact_point_rec  , 
                                                         p_email_rec              => l_email_rec  , 
                                                         p_phone_rec              => l_phone_rec  , 
                                                         p_object_version_number  => l_obj_num  , 
                                                         x_return_status          => lx_return_status  , 
                                                         x_msg_count              => lx_msg_count  , 
                                                         x_msg_data               => lx_msg_data  );
                                                          
        x_return_status := lx_return_status;

        IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
            IF (FND_MSG_PUB.Count_Msg > 1) THEN
              FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
                  fnd_msg_pub.get(p_msg_index => j,
                                  p_encoded => 'F',
                                  p_data => lx_msg_data,
                                  p_msg_index_out => lx_msg_index_out);
      
                  IF lx_msg_data IS NOT NULL THEN
                     x_error_msg := lx_msg_data;
                  END IF;
              END LOOP;
            ELSE
                fnd_msg_pub.get(p_msg_index => 1,
                                p_encoded => 'F',
                                p_data => lx_msg_data,
                                p_msg_index_out => lx_msg_index_out);
                x_error_msg := lx_msg_data;
            END IF;
         END IF;
         
         COMMIT;     
    end;
    
    
    procedure create_contact_point (p_email             in varchar2,
                                    p_phone             in varchar2,
                                    p_phone_type        in VARCHAR2,
                                    p_party_id          in hz_parties.party_id%type,
                                    x_contact_point_id  out hz_contact_points.contact_point_id%TYPE,
                                    x_return_status     out varchar2,
                                    x_error_msg         OUT VARCHAR2)IS
                                    

        l_phone_rec          HZ_CONTACT_POINT_V2PUB.phone_rec_type;  
        l_email_rec          HZ_CONTACT_POINT_V2PUB.email_rec_type;  
        l_contact_point_rec  HZ_CONTACT_POINT_V2PUB.contact_point_rec_type;    
        l_contact_point_type VARCHAR2(10); 
        l_primary_flag       VARCHAR2(1) := 'Y';  
        l_area_code          HZ_CONTACT_POINTS.phone_area_code%TYPE;
        l_phone_number       HZ_CONTACT_POINTS.phone_number%TYPE;  
        l_email              HZ_CONTACT_POINTS.email_address%TYPE; 
        lx_return_status  VARCHAR2(2000);
        lx_msg_count number;
        lx_msg_data VARCHAR2(2000);
        lx_msg_index_out NUMBER; 
        lx_contact_point_id hz_contact_points.contact_point_id%TYPE;        
        
    BEGIN
    
       if p_email is not null then
         l_contact_point_type := 'EMAIL';
         l_email_rec.email_address := p_email;
         l_email_rec.email_format := 'MAILTEXT';
       else
         l_contact_point_type := 'PHONE';
         l_phone_rec.phone_country_code :=  SUBSTR(REPLACE(p_phone, ' ', ''), 1, 2);
         l_phone_rec.phone_area_code   := SUBSTR(REPLACE(p_phone, ' ', ''), 3, 4);  
         l_phone_rec.phone_number      := SUBSTR(REPLACE(p_phone, ' ', ''), 7, 10);  
         l_phone_rec.phone_line_type   := NVL(p_phone_type, 'GEN');   
         l_contact_point_rec.primary_flag := 'Y';                   
       END IF;
    
       l_contact_point_rec.contact_point_type  := l_contact_point_type;
                        
          
       --PHONE primary and secondary  
       l_contact_point_rec.status              := 'A';  
       l_contact_point_rec.owner_table_name    := 'HZ_PARTIES';  
       l_contact_point_rec.owner_table_id      := p_party_id;  
       l_contact_point_rec.primary_flag        := l_primary_flag;  
       l_contact_point_rec.content_source_type := 'USER_ENTERED';
       l_contact_point_rec.created_by_module := 'TCA_V2_API';

       hz_contact_point_v2pub.create_contact_point(p_init_msg_list          => fnd_api.g_false,   
                                                   p_contact_point_rec      => l_contact_point_rec  , 
                                                   p_email_rec              => l_email_rec  , 
                                                   p_phone_rec              => l_phone_rec  , 
                                                   x_contact_point_id       => lx_contact_point_id  , 
                                                   x_return_status          => lx_return_status  , 
                                                   x_msg_count              => lx_msg_count  , 
                                                   x_msg_data               => lx_msg_data  );
    
        x_return_status := lx_return_status;
        x_contact_point_id := lx_contact_point_id;

        IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
            IF (FND_MSG_PUB.Count_Msg > 1) THEN
              FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
                  fnd_msg_pub.get(p_msg_index => j,
                                  p_encoded => 'F',
                                  p_data => lx_msg_data,
                                  p_msg_index_out => lx_msg_index_out);
      
                  IF lx_msg_data IS NOT NULL THEN
                     x_error_msg := lx_msg_data;
                  END IF;
              END LOOP;
            ELSE
                fnd_msg_pub.get(p_msg_index => 1,
                                p_encoded => 'F',
                                p_data => lx_msg_data,
                                p_msg_index_out => lx_msg_index_out);
                x_error_msg := lx_msg_data;
            END IF;
         END IF;
         
         COMMIT;  
     END;
     
     
    -- -------------------------------------------------------------------------
    -- PROCEDURE: create_party
    -- -------------------------------------------------------------------------    
    procedure create_party (p_title in varchar2,
                            p_first_name in varchar2,
                            p_last_name in varchar2,
                            x_party_id OUT NUMBER,
                            x_return_status out varchar2,
                            x_error_msg OUT VARCHAR2) IS
    
     v_create_person_rec hz_party_v2pub.person_rec_type;
     lx_party_id number;
     lx_party_number varchar2(2000);
     lx_profile_id number;
     lx_return_status varchar2(2000);
     lx_msg_count number;
     lx_msg_data varchar2(2000);
     lx_msg_index_out NUMBER;
     
     l_title VARCHAR2(10);
     
    BEGIN

       v_create_person_rec.person_pre_name_adjunct := p_title;
       v_create_person_rec.person_first_name := p_first_name;
       v_create_person_rec.person_last_name := p_last_name;
       v_create_person_rec.created_by_module := 'TCA_V2_API';
       
        HZ_PARTY_V2PUB.create_person(fnd_api.g_false,
                                     v_create_person_rec,
                                     lx_party_id,
                                     lx_party_number,
                                     lx_profile_id,
                                     lx_return_status,
                                     lx_msg_count,
                                     lx_msg_data);
    
        x_return_status := lx_return_status;
        x_party_id := lx_party_id;

        IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
            IF (FND_MSG_PUB.Count_Msg > 1) THEN
              FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
                  fnd_msg_pub.get(p_msg_index => j,
                                  p_encoded => 'F',
                                  p_data => lx_msg_data,
                                  p_msg_index_out => lx_msg_index_out);
      
                  IF lx_msg_data IS NOT NULL THEN
                     x_error_msg := lx_msg_data;
                  END IF;
              END LOOP;
            ELSE
                fnd_msg_pub.get(p_msg_index => 1,
                                p_encoded => 'F',
                                p_data => lx_msg_data,
                                p_msg_index_out => lx_msg_index_out);
                x_error_msg := lx_msg_data;
            end if;
         END IF;
    END;
    
    -- -------------------------------------------------------------------------
    -- PROCEDURE: create_party_relationship
    -- -------------------------------------------------------------------------
    procedure create_party_relationship (p_per_party_id in number,
                                         p_org_party_id in number,
                                         x_party_id      out NUMBER,
                                         x_return_status out varchar2,
                                         x_error_msg OUT VARCHAR2) IS

      v_org_contact_rec hz_party_contact_v2pub.org_contact_rec_type;
      lx_org_contact_id number;
      lx_party_rel_id number;
      lx_party_id number;
      lx_party_number varchar2(2000);
      lx_return_status varchar2(2000);
      lx_msg_count number;
      lx_msg_data varchar2(2000);
      lx_msg_index_out NUMBER;       
    BEGIN
    
        v_org_contact_rec.created_by_module := 'TCA_V2_API';
        v_org_contact_rec.party_rel_rec.subject_id := p_per_party_id; --<<PERSON PARTY_ID>
        v_org_contact_rec.party_rel_rec.subject_type := 'PERSON';
        v_org_contact_rec.party_rel_rec.subject_table_name := 'HZ_PARTIES';
        v_org_contact_rec.party_rel_rec.object_id := p_org_party_id; --<<ORG PARTY_ID>
        v_org_contact_rec.party_rel_rec.object_type := 'ORGANIZATION';
        v_org_contact_rec.party_rel_rec.object_table_name := 'HZ_PARTIES';
        v_org_contact_rec.party_rel_rec.relationship_code := 'CONTACT_OF';
        v_org_contact_rec.party_rel_rec.relationship_type := 'CONTACT';
        v_org_contact_rec.party_rel_rec.start_date := SYSDATE;
        
        hz_party_contact_v2pub.create_org_contact(fnd_api.g_false,
                                                  v_org_contact_rec,
                                                  lx_org_contact_id,
                                                  lx_party_rel_id,
                                                  lx_party_id,
                                                  lx_party_number,
                                                  lx_return_status,
                                                  lx_msg_count,
                                                  lx_msg_data);

        x_return_status := lx_return_status;
        x_party_id := lx_party_id;

        IF (lx_return_status <> FND_API.G_RET_STS_SUCCESS) then
            IF (FND_MSG_PUB.Count_Msg > 1) THEN
            FOR j in 1 .. FND_MSG_PUB.Count_Msg LOOP
                fnd_msg_pub.get(p_msg_index => j,
                                p_encoded => 'F',
                                p_data => lx_msg_data,
                                p_msg_index_out => lx_msg_index_out);
    
                IF lx_msg_data IS NOT NULL THEN
                   x_error_msg := lx_msg_data;
                END IF;
            END LOOP;
            ELSE
                fnd_msg_pub.get(p_msg_index => 1,
                                p_encoded => 'F',
                                p_data => lx_msg_data,
                                p_msg_index_out => lx_msg_index_out);
                x_error_msg := lx_msg_data;
            end if;
        END IF;
    END;
    
    PROCEDURE update_processed (p_vmu_id IN xxino_veh_mass_upload.vmu_id%TYPE) IS
    
    BEGIN
      UPDATE xxino_veh_mass_upload 
         SET upload_status = 'Processed'
       WHERE vmu_id = p_vmu_id;
       
       commit;
    END;
    
    PROCEDURE delete_processed IS
    
    BEGIN
      DELETE FROM xxino_veh_mass_upload 
       WHERE upload_status IS NOT NULL;
       
       commit;
    END;    
    
   -- -------------------------------------------------------------------------
   -- PROCEDURE: process_update
   --
   -- **  This program is called from the Vehicle Mass Update concurrent program
   -- -------------------------------------------------------------------------
   -- This procedure fetches all of the records from the mass update temporary table
   -- and performs the following updates
   --
   --    * Update Service Request with Vehicle Registration Number if profile option is Y
   --    * Update Service Request Notes with Vehicle Details each time an update occurs
   --    * Update SR address with a one time address or ship to address
   --    * Create or Update SR with Customer Contacts
   --        -- if the customer exists then update the contact details
   --        -- if the cistomer does not exist then create a new contact
   -- -------------------------------------------------------------------------
  
   PROCEDURE process_update(p_errbuf  OUT VARCHAR2
                           ,p_retcode OUT NUMBER) IS

      lv_proc_name       VARCHAR2(100) := 'process_update';
      
      cs_incident_rec 	    cs_servicerequest_pub.service_request_rec_type;
      sr_notes_tbl			    cs_servicerequest_pub.notes_table;
      sr_contact_tbl	      cs_servicerequest_pub.contacts_table;
      v_location_rec        hz_location_v2pub.location_rec_type;
      v_party_site_rec      hz_party_site_v2pub.party_site_rec_type;
      v_party_site_use_rec  hz_party_site_v2pub.party_site_use_rec_type;
      
      lx_return_status varchar2(10);
      lx_error_msg     VARCHAR2(4000);
      
      CURSOR get_mass_vehicle IS
      SELECT *
        FROM xxino_veh_mass_upload
       WHERE upload_status IS NULL;
                
      CURSOR Get_SR_Details (cp_incident_number NUMBER) IS
      SELECT *
        FROM cs_incidents_all
       WHERE INCIDENT_NUMBER = CP_INCIDENT_NUMBER;
       
      CURSOR Check_Ship_To_Address (cp_party_site_id hz_party_sites.party_site_id%TYPE) IS
      SELECT PARTY_SITE_USE_ID 
        FROM HZ_PARTY_SITE_USES 
       WHERE Party_site_id IN (SELECT party_site_id 
                                 FROM hz_party_sites 
                                WHERE party_site_id = cp_party_site_id 
                                  AND (status = 'A' OR Status IS NULL)) AND primary_per_type = 'Y' AND (status = 'A' OR status IS NULL )
         AND site_use_type = 'SHIP_TO';
       
      v_incident_rec Get_SR_Details%ROWTYPE;
      v_incident_type_id cs_incident_types.incident_type_id%TYPE;
      v_party_site_id hz_party_sites.party_site_id%TYPE;
      v_party_site_use_id number;
      v_contact_records NUMBER := 0;
      v_buffer VARCHAR2(4000);
      v_ph_cont_point_id    NUMBER;
      v_sr_party_id      NUMBER;
      v_ph_sr_cont_id       NUMBER;
      v_em_cont_point_id    NUMBER;
      v_em_sr_cont_id       NUMBER;      
      v_external_ref        VARCHAR2(10) := 'No';
      v_address_updated     VARCHAR2(20) := 'None';
      v_contact_updated     VARCHAR2(20) := 'No';      
      lx_location_id        hz_locations.location_id%TYPE; 
      lx_loc_return_status  VARCHAR2(10);
      lx_loc_error_msg      VARCHAR2(4000);
      lx_cont_phone_status  VARCHAR2(10);
      lx_cont_phone_error   VARCHAR2(4000);
      lx_cont_email_status  VARCHAR2(10);
      lx_cont_email_error   VARCHAR2(4000);
      lx_party_site_id      hz_party_sites.party_site_id%TYPE; 
      lx_party_site_number  hz_party_sites.party_site_number%TYPE; 
      lx_ps_return_status  VARCHAR2(10);
      lx_ps_error_msg      VARCHAR2(4000);
      lx_party_site_use_id NUMBER; 
      lx_su_return_status  VARCHAR2(10);
      lx_su_error_msg      VARCHAR2(4000);
      lx_ph_contact_point_id hz_contact_points.contact_point_id%TYPE;
      lx_em_contact_point_id hz_contact_points.contact_point_id%TYPE; 
      lx_cont_point_status  VARCHAR2(10);
      lx_cont_point_error   VARCHAR2(4000);  
      x_party_id             NUMBER;
      lx_party_return_status  VARCHAR2(10);
      lx_party_error_msg      VARCHAR2(4000);
      lx_rel_party_id             NUMBER;
      lx_rel_return_status  VARCHAR2(10);
      lx_rel_error_msg      VARCHAR2(4000); 
      r_alreadyfailed            BOOLEAN := FALSE;
   BEGIN
      fnd_file.put_line(v_logfile,'Starting Mass Update....');
   
      initialize_msg (g_failed_tbl);
      initialize_msg (g_success_tbl);
      cs_servicerequest_pub.initialize_rec(cs_incident_rec);
      create_mvu_header;

      FOR mv_rec IN get_mass_vehicle LOOP
      
        fnd_file.put_line(v_logfile,'000 - g_total_count - '||g_total_count);
        fnd_file.put_line(v_logfile,'000 - g_success_count - '||g_success_count);
        fnd_file.put_line(v_logfile,'000 - g_fail_count - '||g_fail_count);
        g_total_count := g_total_count + 1;
        -- Reset local variables
        v_external_ref := 'No';
        v_address_updated := 'None';
        v_contact_records := 0;
        v_party_site_id := 0;
        lx_location_id := NULL;
        lx_party_site_id := NULL;
        lx_party_site_use_id := NULL;
        lx_ph_contact_point_id := NULL;
        lx_em_contact_point_id := NULL;
        x_party_id := NULL;
        lx_rel_party_id := NULL;
        r_alreadyfailed := FALSE;
        sr_notes_tbl.DELETE;
        sr_contact_tbl.DELETE;
        v_incident_rec := NULL;
        fnd_file.put_line(v_logfile,'100 - Processing Incident Number -> '||mv_rec.incident_number);

        OPEN Get_SR_Details(mv_rec.incident_number);
        FETCH Get_SR_Details INTO v_incident_rec;
        close get_sr_details;
        
        fnd_file.put_line(v_logfile,'110 - Processing Incident ID -> '||v_incident_rec.incident_id||' Summary -> '||v_incident_rec.summary);
        fnd_file.put_line(v_logfile,'115 - Processing Customer ID -> '||v_incident_rec.customer_id);

        -- -------------------------------------------------------------------------
        -- VALIDATE SR is type Installation
        -- VALIDATE SR is not Closed or Cancelled
        -- -------------------------------------------------------------------------
        cs_incident_rec.external_reference   := v_incident_rec.external_reference;
        cs_incident_rec.incident_location_id := v_incident_rec.incident_location_id;
        cs_incident_rec.incident_address     := v_incident_rec.incident_address;
        cs_incident_rec.incident_city        := v_incident_rec.incident_city;
        cs_incident_rec.incident_state       := v_incident_rec.incident_state;
        cs_incident_rec.incident_country     := v_incident_rec.incident_country;
        cs_incident_rec.incident_province    := v_incident_rec.incident_province;
        cs_incident_rec.incident_postal_code := v_incident_rec.incident_postal_code;
        cs_incident_rec.incident_county      := v_incident_rec.incident_county;
        cs_incident_rec.incident_address2    := v_incident_rec.incident_address2;
        cs_incident_rec.incident_address3    := v_incident_rec.incident_address3;
        cs_incident_rec.incident_address4    := v_incident_rec.incident_address4;        
        cs_incident_rec.ship_to_site_use_id  := v_incident_rec.ship_to_site_use_id;
        cs_incident_rec.ship_to_site_id      := v_incident_rec.ship_to_site_id;
        cs_incident_rec.ship_to_party_id     := v_incident_rec.ship_to_party_id;
        cs_incident_rec.customer_product_id  := v_incident_rec.customer_product_id;                 

        IF v_incident_rec.incident_number IS NULL THEN
        
            v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                        rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                        rpad(mv_rec.incident_number, 15)||'|'||
                        RPAD(mv_rec.veh_reg, 13)||'|'||'SR number does not exist';
            add_msg(v_buffer, g_failed_tbl);
            g_fail_count := g_fail_count + 1;
            gshowfailed := TRUE;
            r_alreadyfailed := TRUE;
        ELSIF NOT valid_incident_type(v_incident_rec.incident_type_id) THEN
        
            v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                        rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                        rpad(mv_rec.incident_number, 15)||'|'||
                        RPAD(mv_rec.veh_reg, 13)||'|'||'Invalid incident type';
            add_msg(v_buffer, g_failed_tbl);
            g_fail_count := g_fail_count + 1;
            gshowfailed := TRUE;
            r_alreadyfailed := TRUE;
        elsif invalid_incident_status(v_incident_rec.incident_status_id) then
            v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                        rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                        rpad(mv_rec.incident_number, 15)||'|'||
                        RPAD(mv_rec.veh_reg, 13)||'|'||'Incident status is either Closed or Cancelled';
            add_msg(v_buffer, g_failed_tbl);
            g_fail_count := g_fail_count + 1;
            gshowfailed := TRUE;
            r_alreadyfailed := TRUE;
        end if;
        
        if fnd_profile.value('XXINO_VEHICLE_UPDATE_IB') = 'Y' then
           fnd_file.put_line(v_logfile,'120 - Adding external reference (vehicle registration) -> '||mv_rec.veh_reg);
           cs_incident_rec.external_reference := mv_rec.veh_reg;
           cs_incident_rec.customer_product_id  := NULL;
           v_external_ref := 'Yes';
        end if;

        -- -------------------------------------------------------------------------
        -- ADDRESS Logic
        -- -------------------------------------------------------------------------
        IF NOT r_alreadyfailed THEN
           FND_FILE.PUT_LINE(v_logfile,'125 - PROCESSING ADDRESSES WITH - > '||mv_rec.address_type);
           if mv_rec.address_type in ('ONE', 'SHIP') then
               -- 1. CHECK - lets check if the address already exists in party sites \ locations tables.
               -- 2. OUTCOME - change to existing party_site_id if site gets a match
               -- 3. OUTCOME - do nothing if the party_site_id is the one already being used
               -- 4. OUTCOME - create a new party site as it does not exsit
               
               FND_FILE.PUT_LINE(V_LOGFILE,'130 - Check location exists-> '||V_INCIDENT_REC.INCIDENT_LOCATION_ID);
               
               v_party_site_id := address_exists_in_party_sites (mv_rec.address_line_1,
                                                                 mv_rec.postal_code,
                                                                 mv_rec.city,
                                                                 mv_rec.country);
               
               fnd_file.put_line(v_logfile,'140 - Party_site_id returned -> '|| v_party_site_id);
              -- -------------------------------------------------------------------------
              -- Logic for one time address
              -- -------------------------------------------------------------------------
              if mv_rec.address_type = 'ONE' then
                 -- -------------------------------------------------------------------------
                 -- If the address already exists then use it
                 -- elsif the address is already the same as the one being loaded then do nothing
                 -- otherwise add a new one time address
                 -- -------------------------------------------------------------------------
                 IF  v_party_site_id != 0 
                 and v_party_site_id != nvl(v_incident_rec.incident_location_id, 0) then
                    cs_incident_rec.incident_location_id := v_party_site_id;
                    v_address_updated := 'One Off';
                    fnd_file.put_line(v_logfile,'150 - Party site already exists using site_id -> '||v_party_site_id);
                 elsif v_party_site_id = v_incident_rec.incident_location_id then
                    fnd_file.put_line(v_logfile,'160 - Party site already used in this SR');               
                    v_address_updated := 'Same';               
                 else
                     -- -------------------------------------------------------------------------
                     -- Create one time address 
                     -- -------------------------------------------------------------------------
                     fnd_file.put_line(v_logfile,'170 - Creating One Time Address -> '||mv_rec.address_line_1||','||mv_rec.address_line_2||','||mv_rec.city||','||mv_rec.postal_code);
                     cs_incident_rec.incident_location_id := null;
                     cs_incident_rec.incident_address := mv_rec.address_line_1;
                     cs_incident_rec.incident_city := mv_rec.city;
                     cs_incident_rec.incident_state := mv_rec.county;
                     cs_incident_rec.incident_country  := mv_rec.country;
                     cs_incident_rec.incident_province := NULL;
                     cs_incident_rec.incident_postal_code  := mv_rec.postal_code;
                     cs_incident_rec.incident_county   := mv_rec.county;
                     cs_incident_rec.incident_address2  := mv_rec.address_line_2;
                     cs_incident_rec.incident_address3  := mv_rec.address_line_3;
                     cs_incident_rec.incident_address4  := null;
                     v_address_updated := 'One Off';
                 end if;
              -- -------------------------------------------------------------------------
              -- Logic for ship to address
              -- -------------------------------------------------------------------------
              elsif mv_rec.address_type = 'SHIP' then
                 -- -------------------------------------------------------------------------
                 -- If the ship to address already exists then and it is the same as on the SR then do nothing
                 -- elsif the address exists but there is not site use then create a ship to site use
                 -- otherwise add a new location, site and site use and assign it to the SR
                 -- -------------------------------------------------------------------------
                 OPEN Check_Ship_To_Address(v_party_site_id);
                 FETCH Check_Ship_To_Address INTO v_party_site_use_id;
                 CLOSE Check_Ship_To_Address;
                 
                 IF v_party_site_use_id IS NOT NULL THEN
                   fnd_file.put_line(v_logfile,'175 - Found SHIP_TO_SITE_USE with -> v_party_site_use_id = '||v_party_site_use_id);
                 END IF;
                 
                 fnd_file.put_line(v_logfile,'180 - In SHIP with -> v_party_site_id -> '||v_party_site_id||' v_incident_rec.ship_to_site_id -> '||v_incident_rec.ship_to_site_id);
                 -- if the ship_to address is found and is not the same as the current ship to 
                 -- then set the ship to address to the current customer record.
                 IF  v_party_site_id != 0 
                 AND v_party_site_id != NVL(v_incident_rec.ship_to_site_id, 0) THEN
                    
                    IF v_party_site_use_id IS NOT NULL THEN
                        cs_incident_rec.ship_to_site_id := v_party_site_id;
                        cs_incident_rec.ship_to_party_id := v_incident_rec.customer_id; 
                        cs_incident_rec.ship_to_site_use_id := v_party_site_use_id;
                        v_address_updated := 'Existing';
                        fnd_file.put_line(v_logfile,'190 - Found party site so using site_id -> '||v_party_site_id||' v_incident_rec.customer_id -> '||v_incident_rec.customer_id||' v_incident_rec.customer_id -> '||v_party_site_use_id); 
                    else
                        -- -------------------------------------------------------------------------
                        -- No SHIP TO site use exists for the site
                        -- Create SHIP_TO site use 
                        -- -------------------------------------------------------------------------                   
                        -- Initializing the Mandatory API parameters
                        v_party_site_use_rec.site_use_type     := upper('SHIP_TO');
                        v_party_site_use_rec.party_site_id     := v_party_site_id;
                        v_party_site_rec.identifying_address_flag := 'Y';
                        v_party_site_rec.status                   := 'A';
                        
                        v_party_site_use_rec.created_by_module := 'TCA_V2_API';
                        
                        create_party_site_use (v_party_site_use_rec, lx_party_site_use_id, lx_su_return_status, lx_su_error_msg);                      
                        if (lx_su_return_status <> fnd_api.g_ret_sts_success) then
                              fnd_file.put_line(v_logfile,'200 - Party Site USE API Error -> '||lx_su_error_msg);
                              fnd_file.put_line(v_logfile,'210 - Add record to output report -> '||mv_rec.incident_number);
                              v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                          rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                          rpad(mv_rec.incident_number, 15)||'|'||
                                          RPAD(mv_rec.veh_reg, 13)||'|'||'Party Site Use Creation API Error : '||lx_su_error_msg;
                              add_msg(v_buffer, g_failed_tbl);
                              g_fail_count := g_fail_count + 1;
                              gshowfailed := TRUE;
                              r_alreadyfailed := TRUE;
                        ELSE
                                -- -------------------------------------------------------------------------
                                -- Set the SR ship_to _id with the new site_id 
                                -- ------------------------------------------------------------------------- 
                                fnd_file.put_line(v_logfile,'220 - Created NEW party site use -> '||lx_party_site_use_id);
                                cs_incident_rec.ship_to_site_id := lx_party_site_id;
                                cs_incident_rec.ship_to_party_id := v_incident_rec.customer_id;
                                cs_incident_rec.ship_to_site_use_id := lx_party_site_use_id; 
                                v_address_updated := 'New Ship To';
                                fnd_file.put_line(v_logfile,'230 - Created NEW party site use so using site_id -> '||v_party_site_id||' v_incident_rec.customer_id -> '||v_incident_rec.customer_id);  
                        end if; 
                    end if;                       
                 -- -------------------------------------------------------------------------
                 -- SHIP TO address already exists on te SR so do nothing
                 -- -------------------------------------------------------------------------   
                 elsif v_party_site_id != 0
                   and v_party_site_id = nvl(v_incident_rec.ship_to_site_id, 0) then
                    fnd_file.put_line(v_logfile,'240 - Party site already used in this SR');               
                    v_address_updated := 'Same'; 
                 -- -------------------------------------------------------------------------
                 -- Create a new location, site and SHIP_TO address
                 -- -------------------------------------------------------------------------
                 else
                     -- -------------------------------------------------------------------------
                     -- Create Location
                     -- -------------------------------------------------------------------------
                     -- Initializing the Mandatory API parameters
                     fnd_file.put_line(v_logfile,'250 - Creating new location'); 
                     v_location_rec.country           := mv_rec.country;
                     v_location_rec.address1          := MV_REC.ADDRESS_LINE_1;
                     v_location_rec.city              := mv_rec.city;
                     v_location_rec.postal_code       := mv_rec.postal_code;
                     v_location_rec.county            := mv_rec.county;
                     v_location_rec.address2          := mv_rec.address_line_2;
                     v_location_rec.address3          := mv_rec.address_line_3;                     
                     v_location_rec.created_by_module := 'TCA_V2_API';
                     
                     create_location (v_location_rec, lx_location_id, lx_loc_return_status, lx_loc_error_msg);
                     fnd_file.put_line(v_logfile,'260 - Location Details -> lx_location_id = '||lx_location_id);
                     fnd_file.put_line(v_logfile,'270 - Location Status -> lx_loc_return_status = '||lx_loc_return_status);
                      -- -------------------------------------------------------------------------
                      -- Write to report API results 
                      -- -------------------------------------------------------------------------
                      if (lx_loc_return_status <> fnd_api.g_ret_sts_success) then
                          fnd_file.put_line(v_logfile,'280 - Locations API Error -> '||lx_loc_error_msg);
                          fnd_file.put_line(v_logfile,'290 - Add record to output report -> '||mv_rec.incident_number);
                          v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                      rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                      rpad(mv_rec.incident_number, 15)||'|'||
                                      RPAD(mv_rec.veh_reg, 13)||'|'||'Location Creation API Error : '||lx_loc_error_msg;
                          add_msg(v_buffer, g_failed_tbl);
                          g_fail_count := g_fail_count + 1;
                          gshowfailed := TRUE;  
                          r_alreadyfailed := TRUE;
                      else
                           -- -------------------------------------------------------------------------
                           -- Create Site
                           -- -------------------------------------------------------------------------
                           -- Initializing the Mandatory API parameters
                           fnd_file.put_line(v_logfile,'300 - Creating new party site');                            
                           v_party_site_rec.party_id                 := v_incident_rec.customer_id;
                           v_party_site_rec.location_id              := lx_location_id;
                           v_party_site_rec.identifying_address_flag := 'Y';
                           v_party_site_rec.status                   := 'A';
                           v_party_site_rec.created_by_module := 'TCA_V2_API';
                           
                           create_party_site (v_party_site_rec, lx_party_site_id, lx_party_site_number, lx_ps_return_status, lx_ps_error_msg);
 
                           fnd_file.put_line(v_logfile,'310 - Party Site Details -> lx_party_site_id = '||lx_party_site_id);
                           fnd_file.put_line(v_logfile,'320 - Party Sites -> lx_ps_return_status = '||lx_ps_return_status);
                            -- -------------------------------------------------------------------------
                            -- Write to report API results 
                            -- -------------------------------------------------------------------------
                            if (lx_ps_return_status <> fnd_api.g_ret_sts_success) then
                                fnd_file.put_line(v_logfile,'330 - Party Site API Error -> '||lx_ps_error_msg);
                                fnd_file.put_line(v_logfile,'340 - Add record to output report -> '||mv_rec.incident_number);
                                v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                            rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                            rpad(mv_rec.incident_number, 15)||'|'||
                                            RPAD(mv_rec.veh_reg, 13)||'|'||'Party Site Creation API Error : '||lx_ps_error_msg;
                                add_msg(v_buffer, g_failed_tbl);
                                g_fail_count := g_fail_count + 1;
                                gshowfailed := TRUE;
                                r_alreadyfailed := TRUE;
                           ELSE
                                -- -------------------------------------------------------------------------
                                -- Create Site USE
                                -- -------------------------------------------------------------------------                           
                                -- Initializing the Mandatory API parameters
                                v_party_site_use_rec.site_use_type     := upper('SHIP_TO');
                                v_party_site_use_rec.party_site_id     := lx_party_site_id;
                                v_party_site_use_rec.primary_per_type  := 'Y';
                                v_party_site_use_rec.created_by_module := 'TCA_V2_API';
                                
                                create_party_site_use (v_party_site_use_rec, lx_party_site_use_id, lx_su_return_status, lx_su_error_msg);                      
                                if (lx_su_return_status <> fnd_api.g_ret_sts_success) then
                                      fnd_file.put_line(v_logfile,'350 - Party Site API Error -> '||lx_ps_error_msg);
                                      fnd_file.put_line(v_logfile,'360 - Add record to output report -> '||mv_rec.incident_number);
                                      v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                                  rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                                  rpad(mv_rec.incident_number, 15)||'|'||
                                                  RPAD(mv_rec.veh_reg, 13)||'|'||'Party Site Use Creation API Error : '||lx_su_error_msg;
                                      add_msg(v_buffer, g_failed_tbl);
                                      g_fail_count := g_fail_count + 1;
                                      gshowfailed := TRUE;
                                      r_alreadyfailed := TRUE;
                                ELSE
                                      -- -------------------------------------------------------------------------
                                      -- Assign site to the SR
                                      -- ------------------------------------------------------------------------- 
                                      cs_incident_rec.ship_to_site_id := lx_party_site_id;
                                      cs_incident_rec.ship_to_party_id := v_incident_rec.customer_id; 
                                      cs_incident_rec.ship_to_site_use_id := lx_party_site_use_id;                                       
                                      v_address_updated := 'New Ship To';
                                      fnd_file.put_line(v_logfile,'370 - Created NEW party site so using site_id -> '||lx_party_site_id||' v_incident_rec.customer_id -> '||v_incident_rec.customer_id);  
                               END IF; 
                           END IF;
                      END IF;
                 END IF;      
              END IF;
           END IF;
        end if;
 
        fnd_file.put_line(v_logfile,'375 - FINISHED ADDRESSES');        
        ----------------------------------------------------------------------
        -- SR Contacts
        ----------------------------------------------------------------------
         IF NOT  r_alreadyfailed THEN
            -- is there any phone in the upload record

            fnd_file.put_line(v_logfile,'380 - Calling sr_contact exists -> incident_id = '||v_incident_rec.incident_id|| 
                             ' mv_rec.person_first_name = '||mv_rec.person_first_name||
                             ' mv_rec.person_last_name = '||mv_rec.person_last_name||
                             ' PHONE');
            sr_contact_exists(v_incident_rec.incident_id, 
                              mv_rec.person_first_name, 
                              mv_rec.person_last_name, 
                              v_em_cont_point_id, 
                              v_em_sr_cont_id,
                              v_ph_cont_point_id, 
                              v_ph_sr_cont_id, 
                              v_sr_party_id);

            fnd_file.put_line(v_logfile,'390 - sr_contact exists Return Values-> v_ph_cont_point_id = '||v_ph_cont_point_id||CHR(10)||
                                        '                                        v_ph_sr_cont_id = '||v_ph_sr_cont_id||CHR(10)||
                                        '                                        v_em_cont_point_id = '||v_em_cont_point_id||CHR(10)||
                                        '                                        v_em_sr_cont_id = '||v_em_sr_cont_id||CHR(10)||
                                        '                                        v_sr_party_id = '||v_sr_party_id);
            
            -- is there a phone number in the upload
            ----------------------------------------
            --  PROCESS PHONE CONTACT
            -----------------------------------------
            IF mv_rec.phone IS NOT NULL THEN
               v_contact_updated := 'Yes';              
               IF v_ph_cont_point_id != 0 THEN
              
                    -- update existing contact point record
                    fnd_file.put_line(v_logfile,'400 - Updating existing phone contact -> v_ph_cont_point_id = '||v_ph_cont_point_id);

                    update_contact_point(v_ph_cont_point_id,
                                         null,
                                         mv_rec.phone,
                                         mv_rec.phone_type,
                                         v_sr_party_id,
                                         lx_cont_phone_status,
                                         lx_cont_phone_error);
                    IF (lx_cont_phone_status <> fnd_api.g_ret_sts_success) THEN
                           fnd_file.put_line(v_logfile,'410 - Contact Point API Error -> '||lx_cont_phone_error);
                           fnd_file.put_line(v_logfile,'420 - Add record to output report -> '||mv_rec.incident_number);
                           v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                       rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                       rpad(mv_rec.incident_number, 15)||'|'||
                                       RPAD(mv_rec.veh_reg, 13)||'|'||'Update PHONE Contact Point API Error : '||lx_cont_phone_error;
                           add_msg(v_buffer, g_failed_tbl);
                           g_fail_count := g_fail_count + 1;
                           gshowfailed := TRUE;
                           r_alreadyfailed := TRUE;
                     end if;                                      
               ELSIF v_sr_party_id IS NOT NULL 
                 AND v_ph_cont_point_id != 0 THEN
                  -- create new contact point record
                  fnd_file.put_line(v_logfile,'430 - Creating new phone contact point -> v_sr_party_id = '||v_sr_party_id);

                  create_contact_point (null,
                                        mv_rec.phone,
                                        mv_rec.phone_type,
                                        v_sr_party_id,
                                        lx_ph_contact_point_id,
                                        lx_cont_point_status,
                                        lx_cont_point_error);
                                        
                   IF (lx_cont_point_status <> fnd_api.g_ret_sts_success) THEN
                           fnd_file.put_line(v_logfile,'440 - Contact Point API Error -> '||lx_cont_phone_error);
                           v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                       rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                       rpad(mv_rec.incident_number, 15)||'|'||
                                       RPAD(mv_rec.veh_reg, 13)||'|'||'Create PHONE Contact Point API Error : '||lx_cont_point_error;
                           add_msg(v_buffer, g_failed_tbl);
                           g_fail_count := g_fail_count + 1;
                           gshowfailed := TRUE;
                           r_alreadyfailed := TRUE;
                   end if; 
                   -- add contact point to sr  
                    sr_contact_tbl(1).PARTY_ID            := v_sr_party_id;
                    sr_contact_tbl(1).CONTACT_POINT_ID    := lx_ph_contact_point_id;
                    sr_contact_tbl(1).CONTACT_POINT_TYPE  := 'PHONE';
                    sr_contact_tbl(1).PRIMARY_FLAG        := 'Y';
                    sr_contact_tbl(1).CONTACT_TYPE        := 'PARTY_RELATIONSHIP';
                    sr_contact_tbl(1).party_role_code     := 'CONTACT';
                    sr_contact_tbl(1).start_date_active   := SYSDATE;
                    v_contact_records := 1;                                                          
               ELSE
                  fnd_file.put_line(v_logfile,'450 - Creating new party (PHONE)');
             
                  -- create new party and contact point record
                  create_party (mv_rec.person_title,
                                mv_rec.person_first_name,
                                mv_rec.person_last_name,
                                x_party_id,
                                lx_party_return_status,
                                lx_party_error_msg);


                   IF (lx_party_return_status <> fnd_api.g_ret_sts_success) THEN
                           fnd_file.put_line(v_logfile,'460 - Party API Error -> '||lx_cont_phone_error);
                           v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                       rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                       rpad(mv_rec.incident_number, 15)||'|'||
                                       RPAD(mv_rec.veh_reg, 13)||'|'||'Create Party API Error : '||lx_party_error_msg;
                           add_msg(v_buffer, g_failed_tbl);
                           g_fail_count := g_fail_count + 1;
                           gshowfailed := TRUE;
                           r_alreadyfailed := TRUE;
                   else
                      fnd_file.put_line(v_logfile,'470 - Created new party (PHONE) x_party_id = '||x_party_id);
                   end if; 
                   fnd_file.put_line(v_logfile,'480 - Creating new relationship (PHONE) x_party_id = '||x_party_id||
                                                ' v_incident_rec.customer_id = '||v_incident_rec.customer_id);
                   create_party_relationship ( x_party_id,
                                               v_incident_rec.customer_id,
                                               lx_rel_party_id,
                                               lx_rel_return_status,
                                               lx_rel_error_msg);
                                               
                   IF (lx_rel_return_status <> fnd_api.g_ret_sts_success) THEN
                           fnd_file.put_line(v_logfile,'490 - Relationship API Error -> '||lx_cont_phone_error);
                           v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                       rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                       rpad(mv_rec.incident_number, 15)||'|'||
                                       RPAD(mv_rec.veh_reg, 13)||'|'||'Create Relationship API Error : '||lx_rel_error_msg;
                           add_msg(v_buffer, g_failed_tbl);
                           g_fail_count := g_fail_count + 1;
                           gshowfailed := TRUE;
                           r_alreadyfailed := TRUE;
                   else
                      fnd_file.put_line(v_logfile,'500 - Created new party (PHONE) lx_rel_party_id = '||lx_rel_party_id);
                   end if;                                                
                  
                  fnd_file.put_line(v_logfile,'510 - Creating new phone contact point -> x_party_id = '||x_party_id);
                  create_contact_point (null,
                                        mv_rec.phone,
                                        mv_rec.phone_type,
                                        lx_rel_party_id,
                                        lx_ph_contact_point_id,
                                        lx_cont_point_status,
                                        lx_cont_point_error);

                                        
                   IF (lx_cont_point_status <> fnd_api.g_ret_sts_success) THEN
                           fnd_file.put_line(v_logfile,'520 - Contact Point API Error -> '||lx_cont_phone_error);
                           v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                       rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                       rpad(mv_rec.incident_number, 15)||'|'||
                                       RPAD(mv_rec.veh_reg, 13)||'|'||'Create PHONE Contact Point API Error : '||lx_cont_point_error;
                           add_msg(v_buffer, g_failed_tbl);
                           g_fail_count := g_fail_count + 1;
                           gshowfailed := TRUE;
                           r_alreadyfailed := TRUE;
                   else
                      fnd_file.put_line(v_logfile,'530 - Contact Point (PHONE)  -> '||lx_ph_contact_point_id);
                   
                   end if; 
               
                   -- add contact point to sr  
                   sr_contact_tbl(1).PARTY_ID            := lx_rel_party_id;
                   sr_contact_tbl(1).CONTACT_POINT_ID    := lx_ph_contact_point_id;
                   sr_contact_tbl(1).CONTACT_POINT_TYPE  := 'PHONE';
                   sr_contact_tbl(1).PRIMARY_FLAG        := 'Y';
                   sr_contact_tbl(1).CONTACT_TYPE        := 'PARTY_RELATIONSHIP';
                   --sr_contact_tbl(1).party_role_code     := 'CONTACT';
                   sr_contact_tbl(1).start_date_active   := SYSDATE;
                   v_contact_records := 1; 
               END IF;
               
            END IF;
            -- is there any email in the upload record
            ----------------------------------------
            --  PROCESS EMAIL CONTACT
            -----------------------------------------
            IF mv_rec.email IS NOT NULL THEN
               v_contact_updated := 'Yes';
               IF v_em_cont_point_id != 0 THEN

                 -- update existing contact point record
                 fnd_file.put_line(v_logfile,'540 - Updating existing email contact -> v_em_cont_point_id = '||v_em_cont_point_id);

                 update_contact_point(v_em_cont_point_id,
                                      mv_rec.email,
                                      null,
                                      null,
                                      v_sr_party_id,
                                      lx_cont_email_status,
                                      lx_cont_email_error);
                 IF (lx_cont_email_status <> fnd_api.g_ret_sts_success) THEN
                        fnd_file.put_line(v_logfile,'550 - Contact Point API Error -> '||lx_cont_phone_error);
                        v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                    rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                    rpad(mv_rec.incident_number, 15)||'|'||
                                    RPAD(mv_rec.veh_reg, 13)||'|'||'Update EMAIL Contact Point API Error : '||lx_cont_email_error;
                        add_msg(v_buffer, g_failed_tbl);
                        g_fail_count := g_fail_count + 1;
                        gshowfailed := TRUE;
                        r_alreadyfailed := TRUE;
                  end if;
               ELSIF v_sr_party_id IS NOT NULL 
                 AND v_em_cont_point_id != 0 THEN
                  -- create new contact point record
                  fnd_file.put_line(v_logfile,'560 - Creating new email contact point -> v_sr_party_id = '||v_sr_party_id);
                  create_contact_point (mv_rec.email,
                                        null,
                                        null,
                                        v_sr_party_id,
                                        lx_em_contact_point_id,
                                        lx_cont_point_status,
                                        lx_cont_point_error);
                                        
                   IF (lx_cont_point_status <> fnd_api.g_ret_sts_success) THEN
                           fnd_file.put_line(v_logfile,'530 - Contact Point API Error -> '||lx_cont_phone_error);
                           fnd_file.put_line(v_logfile,'540 - Add record to output report -> '||mv_rec.incident_number);
                           v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                       rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                       rpad(mv_rec.incident_number, 15)||'|'||
                                       RPAD(mv_rec.veh_reg, 13)||'|'||'Create EMAIL Contact Point API Error : '||lx_cont_point_error;
                           add_msg(v_buffer, g_failed_tbl);
                           g_fail_count := g_fail_count + 1;
                           gshowfailed := TRUE;
                           r_alreadyfailed := TRUE;
                   else
                     fnd_file.put_line(v_logfile,'570 - Created new email contact point -> lx_em_contact_point_id = '||lx_em_contact_point_id);
                   end if;
                   -- add contact point to sr 
                    v_contact_records := v_contact_records + 1; 
                    sr_contact_tbl(v_contact_records).PARTY_ID            := v_sr_party_id;
                    sr_contact_tbl(v_contact_records).CONTACT_POINT_ID    := lx_em_contact_point_id;
                    sr_contact_tbl(v_contact_records).CONTACT_POINT_TYPE  := 'EMAIL';
                    IF v_contact_records = 1 THEN
                      sr_contact_tbl(v_contact_records).PRIMARY_FLAG        := 'Y';
                    ELSE
                      sr_contact_tbl(v_contact_records).PRIMARY_FLAG        := 'N';
                    END IF;
                    sr_contact_tbl(v_contact_records).CONTACT_TYPE        := 'PARTY_RELATIONSHIP';
                    sr_contact_tbl(v_contact_records).party_role_code     := 'CONTACT';
                    sr_contact_tbl(v_contact_records).start_date_active   := SYSDATE;                    
               ELSE
                  -- create new party and contact point record
                  IF lx_rel_party_id IS NULL THEN
                     fnd_file.put_line(v_logfile,'580 - Creating new party (EMAIL) x_party_id = '||x_party_id);
                     create_party (mv_rec.person_title,
                                   mv_rec.person_first_name,
                                   mv_rec.person_last_name,
                                   x_party_id,
                                   lx_party_return_status,
                                   lx_party_error_msg);
                      IF (lx_party_return_status <> fnd_api.g_ret_sts_success) THEN
                              fnd_file.put_line(v_logfile,'560 - Party API Error -> '||lx_party_error_msg);
                              v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                          rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                          rpad(mv_rec.incident_number, 15)||'|'||
                                          RPAD(mv_rec.veh_reg, 13)||'|'||'Create Party API Error : '||lx_party_error_msg;
                              add_msg(v_buffer, g_failed_tbl);
                              g_fail_count := g_fail_count + 1;
                              gshowfailed := TRUE;
                              r_alreadyfailed := TRUE;
                      else
                         fnd_file.put_line(v_logfile,'590 - Created new party (EMAIL) x_party_id = '||x_party_id);
                      end if;
                      
                      create_party_relationship ( x_party_id,
                                                  v_incident_rec.customer_id,
                                                  lx_rel_party_id,
                                                  lx_rel_return_status,
                                                  lx_rel_error_msg);
                                                  
                      IF (lx_rel_return_status <> fnd_api.g_ret_sts_success) THEN
                              fnd_file.put_line(v_logfile,'600 - Relationship API Error -> '||lx_cont_phone_error);
                              v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                          rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                          rpad(mv_rec.incident_number, 15)||'|'||
                                          RPAD(mv_rec.veh_reg, 13)||'|'||'Create Relationship API Error : '||lx_rel_error_msg;
                              add_msg(v_buffer, g_failed_tbl);
                              g_fail_count := g_fail_count + 1;
                              gshowfailed := TRUE;
                              r_alreadyfailed := TRUE;
                      else
                         fnd_file.put_line(v_logfile,'610 - Created new party relationship (EMAIL) lx_rel_party_id = '||lx_rel_party_id);
                      end if;                         
                  END IF;

                  fnd_file.put_line(v_logfile,'620 - Creating new email contact point -> lx_rel_party_id = '||lx_rel_party_id);

                  create_contact_point (mv_rec.email,
                                        null,
                                        null,
                                        lx_rel_party_id,
                                        lx_em_contact_point_id,
                                        lx_cont_point_status,
                                        lx_cont_point_error);
                                        
                   IF (lx_cont_point_status <> fnd_api.g_ret_sts_success) THEN
                           fnd_file.put_line(v_logfile,'580 - Contact Point API Error -> '||lx_cont_phone_error);
                           v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                                       rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                                       rpad(mv_rec.incident_number, 15)||'|'||
                                       RPAD(mv_rec.veh_reg, 13)||'|'||'Create EMAIL Contact Point API Error : '||lx_cont_point_error;
                           add_msg(v_buffer, g_failed_tbl);
                           g_fail_count := g_fail_count + 1;
                           gshowfailed := TRUE;
                           r_alreadyfailed := TRUE;
                   else
                     fnd_file.put_line(v_logfile,'630 - Created new email contact point -> lx_em_contact_point_id = '||lx_em_contact_point_id);

                   end if; 
               
                   -- add contact point to sr  
                    v_contact_records := v_contact_records + 1; 
                    sr_contact_tbl(v_contact_records).PARTY_ID            := lx_rel_party_id;
                    sr_contact_tbl(v_contact_records).CONTACT_POINT_ID    := lx_em_contact_point_id;
                    sr_contact_tbl(v_contact_records).CONTACT_POINT_TYPE  := 'EMAIL';
                    IF mv_rec.phone IS NULL THEN
                      sr_contact_tbl(v_contact_records).PRIMARY_FLAG        := 'Y';
                    ELSE
                      sr_contact_tbl(v_contact_records).PRIMARY_FLAG        := 'N';
                    END IF;
                    sr_contact_tbl(v_contact_records).CONTACT_TYPE        := 'PARTY_RELATIONSHIP';
                    sr_contact_tbl(v_contact_records).start_date_active   := SYSDATE; 
               END IF;
            END IF;
         END IF;
        fnd_file.put_line(v_logfile,'635 - FINISHED CONTACTS'); 
           -----------------------------------------------------------------------
           -- If we haven't alrready encountered an error then lets update the SR
           -----------------------------------------------------------------------
           IF NOT r_alreadyfailed THEN
              -- -------------------------------------------------------------------------
              -- Setting SR Defaults
              -- -------------------------------------------------------------------------
              fnd_file.put_line(v_logfile,'640 - PROCESSING UPDATE SR -> '||mv_rec.incident_number);
              -- Set Mandatory SR values
             
              cs_incident_rec.request_date:= v_incident_rec.incident_date;
              cs_incident_rec.type_id := v_incident_rec.incident_type_id;
              cs_incident_rec.status_id := v_incident_rec.incident_status_id;
              cs_incident_rec.severity_id := v_incident_rec.incident_severity_id;
              cs_incident_rec.urgency_id := v_incident_rec.incident_urgency_id;
              cs_incident_rec.owner_id := v_incident_rec.incident_owner_id;
              cs_incident_rec.summary := v_incident_rec.summary;
              cs_incident_rec.customer_id := v_incident_rec.customer_id;
              cs_incident_rec.verify_cp_flag := 'N';
              cs_incident_rec.closed_date  := v_incident_rec.close_date;
              cs_incident_rec.owner_group_id  := v_incident_rec.owner_group_id;
              --cs_incident_rec.publish_flag  := v_incident_rec.publish_flag;
              cs_incident_rec.caller_type  := v_incident_rec.caller_type;
              cs_incident_rec.employee_id  := v_incident_rec.employee_id;
              cs_incident_rec.platform_id  := v_incident_rec.platform_id;
              cs_incident_rec.platform_version  := v_incident_rec.platform_version;
              cs_incident_rec.db_version  := v_incident_rec.db_version;
              cs_incident_rec.platform_version_id  := v_incident_rec.platform_version_id;
              cs_incident_rec.cp_component_id  := v_incident_rec.cp_component_id;
              cs_incident_rec.cp_component_version_id  := v_incident_rec.cp_component_version_id;
              cs_incident_rec.cp_subcomponent_id  := v_incident_rec.cp_subcomponent_id;
              cs_incident_rec.cp_subcomponent_version_id  := v_incident_rec.cp_subcomponent_version_id;
              cs_incident_rec.language_id  := v_incident_rec.language_id;
              cs_incident_rec.language  := v_incident_rec.language;
              --cs_incident_rec.cp_ref_number  := v_incident_rec.cp_ref_number;
              cs_incident_rec.inventory_item_id  := v_incident_rec.inventory_item_id;
              cs_incident_rec.inventory_org_id  := v_incident_rec.inv_organization_id;
              --cs_incident_rec.inventory_item_conc_segs   := v_incident_rec.inventory_item_conc_segs;
             --cs_incident_rec.inventory_item_segment1  := v_incident_rec.inventory_item_segment1;  
             --cs_incident_rec.inventory_item_segment2   := v_incident_rec.inventory_item_segment2; 
             --cs_incident_rec.inventory_item_segment3   := v_incident_rec.inventory_item_segment3;
             --cs_incident_rec.inventory_item_segment4   := v_incident_rec.inventory_item_segment4 ; 
             --cs_incident_rec.inventory_item_segment5  := v_incident_rec.inventory_item_segment5;
             --cs_incident_rec.inventory_item_segment6  := v_incident_rec.inventory_item_segment6;
             --cs_incident_rec.inventory_item_segment7    := v_incident_rec.inventory_item_segment7;
             --cs_incident_rec.inventory_item_segment8   := v_incident_rec.inventory_item_segment8;
             --cs_incident_rec.inventory_item_segment9  := v_incident_rec.inventory_item_segment9;
             --cs_incident_rec.inventory_item_segment10    := v_incident_rec.inventory_item_segment10;
             --cs_incident_rec.inventory_item_segment11  := v_incident_rec.inventory_item_segment11;
             --cs_incident_rec.inventory_item_segment12   := v_incident_rec.inventory_item_segment12;
             --cs_incident_rec.inventory_item_segment13  := v_incident_rec.inventory_item_segment13;
             --cs_incident_rec.inventory_item_segment14  := v_incident_rec.inventory_item_segment14;
             --cs_incident_rec.inventory_item_segment15  := v_incident_rec.inventory_item_segment15 ;
             --cs_incident_rec.inventory_item_segment16 := v_incident_rec.inventory_item_segment16 ; 
             --cs_incident_rec.inventory_item_segment17 := v_incident_rec.inventory_item_segment17 ; 
             --cs_incident_rec.inventory_item_segment18  := v_incident_rec.inventory_item_segment18; 
             --cs_incident_rec.inventory_item_segment19 := v_incident_rec.inventory_item_segment19 ;
             --cs_incident_rec.inventory_item_segment20  := v_incident_rec.inventory_item_segment20 ;
             --cs_incident_rec.inventory_item_vals_or_ids := v_incident_rec.inventory_item_vals_or_ids;
             cs_incident_rec.current_serial_number  := v_incident_rec.current_serial_number;    
             cs_incident_rec.original_order_number := v_incident_rec.original_order_number;     
             cs_incident_rec.purchase_order_num  := v_incident_rec.purchase_order_num;        
             cs_incident_rec.problem_code  := v_incident_rec.problem_code;              
             cs_incident_rec.exp_resolution_date := v_incident_rec.expected_resolution_date;       
             cs_incident_rec.install_site_use_id  := v_incident_rec.install_site_use_id;       
             --cs_incident_rec.request_attribute_1  := v_incident_rec.request_attribute_1 ;     
             --cs_incident_rec.request_attribute_2  := v_incident_rec.request_attribute_2 ;    
             --cs_incident_rec.request_attribute_3  := v_incident_rec.request_attribute_3 ;     
             --cs_incident_rec.request_attribute_4  := v_incident_rec.request_attribute_4  ;    
             --cs_incident_rec.request_attribute_5  := v_incident_rec.request_attribute_5 ;     
             --cs_incident_rec.request_attribute_6  := v_incident_rec.request_attribute_6 ;    
             --cs_incident_rec.request_attribute_7  := v_incident_rec.request_attribute_7 ;      
             --cs_incident_rec.request_attribute_8  := v_incident_rec.request_attribute_8 ;     
             --cs_incident_rec.request_attribute_9  := v_incident_rec.request_attribute_9 ;     
             --cs_incident_rec.request_attribute_10 := v_incident_rec.request_attribute_10;      
             --cs_incident_rec.request_attribute_11  := v_incident_rec.request_attribute_11 ;   
             --cs_incident_rec.request_attribute_12 := v_incident_rec.request_attribute_12;      
             --cs_incident_rec.request_attribute_13  := v_incident_rec.request_attribute_13;     
             --cs_incident_rec.request_attribute_14  := v_incident_rec.request_attribute_14;    
             --cs_incident_rec.request_attribute_15  := v_incident_rec.request_attribute_15 ;    
             --cs_incident_rec.request_context  := v_incident_rec.request_context ;        
             cs_incident_rec.external_attribute_1   := v_incident_rec.external_attribute_1 ;   
             cs_incident_rec.external_attribute_2   := v_incident_rec.external_attribute_2 ;   
             cs_incident_rec.external_attribute_3   := v_incident_rec.external_attribute_3 ;   
             cs_incident_rec.external_attribute_4   := v_incident_rec.external_attribute_4 ;   
             cs_incident_rec.external_attribute_5   := v_incident_rec.external_attribute_5;    
             cs_incident_rec.external_attribute_6   := v_incident_rec.external_attribute_6 ;   
             cs_incident_rec.external_attribute_7   := v_incident_rec.external_attribute_7 ;  
             cs_incident_rec.external_attribute_8   := v_incident_rec.external_attribute_8 ;   
             cs_incident_rec.external_attribute_9   := v_incident_rec.external_attribute_9;
             cs_incident_rec.external_attribute_10  := v_incident_rec.external_attribute_10;
             cs_incident_rec.external_attribute_11  := v_incident_rec.external_attribute_11;
             cs_incident_rec.external_attribute_12  := v_incident_rec.external_attribute_12;
             cs_incident_rec.external_attribute_13  := v_incident_rec.external_attribute_13;
             cs_incident_rec.external_attribute_14  := v_incident_rec.external_attribute_14;
             cs_incident_rec.external_attribute_15  := v_incident_rec.external_attribute_15;
             cs_incident_rec.external_context  := v_incident_rec.external_context;
             cs_incident_rec.bill_to_site_use_id := v_incident_rec.bill_to_site_use_id;
             cs_incident_rec.bill_to_contact_id  := v_incident_rec.bill_to_contact_id ;
             cs_incident_rec.ship_to_contact_id := v_incident_rec.ship_to_contact_id ;
             cs_incident_rec.resolution_code   := v_incident_rec.resolution_code;
             cs_incident_rec.act_resolution_date  := v_incident_rec.actual_resolution_date;
             --cs_incident_rec.public_comment_flag  := v_incident_rec.public_comment_flag;
             --cs_incident_rec.parent_interaction_id := v_incident_rec.parent_interaction_id;
             cs_incident_rec.contract_service_id  := v_incident_rec.contract_service_id;
             --cs_incident_rec.contract_service_number := v_incident_rec.contract_service_number;
             cs_incident_rec.contract_id        := v_incident_rec.contract_id;
             cs_incident_rec.project_number     := mv_rec.veh_reg;
             cs_incident_rec.qa_collection_plan_id  := v_incident_rec.qa_collection_id;
             cs_incident_rec.account_id             := v_incident_rec.account_id ;
             cs_incident_rec.resource_type          := v_incident_rec.resource_type;
             cs_incident_rec.resource_subtype_id    := v_incident_rec.resource_subtype_id;
             cs_incident_rec.cust_po_number         := v_incident_rec.customer_po_number;
             cs_incident_rec.cust_ticket_number     := v_incident_rec.customer_ticket_number;
             cs_incident_rec.sr_creation_channel    := v_incident_rec.sr_creation_channel;
             cs_incident_rec.obligation_date        := v_incident_rec.obligation_date ;
             cs_incident_rec.time_zone_id           := v_incident_rec.time_zone_id ;
             cs_incident_rec.time_difference        := v_incident_rec.time_difference;
             cs_incident_rec.site_id                := v_incident_rec.site_id;
             cs_incident_rec.customer_site_id       := v_incident_rec.customer_site_id;
             cs_incident_rec.territory_id           := v_incident_rec.territory_id ;
             --cs_incident_rec.initialize_flag        := v_incident_rec.initialize_flag;
             cs_incident_rec.cp_revision_id         := v_incident_rec.cp_revision_id;
             cs_incident_rec.inv_item_revision      := v_incident_rec.inv_item_revision;
             cs_incident_rec.inv_component_id       := v_incident_rec.inv_component_id;
             cs_incident_rec.inv_component_version     := v_incident_rec.inv_component_version;
             cs_incident_rec.inv_subcomponent_id       := v_incident_rec.inv_subcomponent_id;
             cs_incident_rec.inv_subcomponent_version   := v_incident_rec.inv_subcomponent_version;
             cs_incident_rec.tier                      := v_incident_rec.tier;
             cs_incident_rec.tier_version              := v_incident_rec.tier_version;
             cs_incident_rec.operating_system          := v_incident_rec.operating_system;
             cs_incident_rec.operating_system_version  := v_incident_rec.operating_system_version;
             cs_incident_rec.database                 := v_incident_rec.database ;
             cs_incident_rec.cust_pref_lang_id         := v_incident_rec.cust_pref_lang_id ;
             cs_incident_rec.category_id               := v_incident_rec.category_id ;
             cs_incident_rec.group_type                := v_incident_rec.group_type;
             cs_incident_rec.group_territory_id        := v_incident_rec.group_territory_id;
             cs_incident_rec.inv_platform_org_id       := v_incident_rec.inv_platform_org_id;
             cs_incident_rec.component_version        := v_incident_rec.component_version ;
             cs_incident_rec.subcomponent_version      := v_incident_rec.subcomponent_version;
             cs_incident_rec.product_revision          := v_incident_rec.product_revision;
             cs_incident_rec.comm_pref_code           := v_incident_rec.comm_pref_code;
             cs_incident_rec.cust_pref_lang_code       := v_incident_rec.cust_pref_lang_code;
             cs_incident_rec.last_update_channel      := v_incident_rec.last_update_channel;
             cs_incident_rec.category_set_id            := v_incident_rec.category_set_id ;
             -- we set this earlier
             --cs_incident_rec.external_reference         := v_incident_rec.external_reference;
             cs_incident_rec.system_id                  := v_incident_rec.system_id ;
             cs_incident_rec.error_code                := v_incident_rec.error_code;
             cs_incident_rec.incident_occurred_date     := v_incident_rec.incident_occurred_date;
             cs_incident_rec.incident_resolved_date     := v_incident_rec.incident_resolved_date;
             cs_incident_rec.inc_responded_by_date     := v_incident_rec.inc_responded_by_date;
             cs_incident_rec.resolution_summary         := v_incident_rec.resolution_summary;
             --cs_incident_rec.incident_address          := v_incident_rec.incident_address;
             --cs_incident_rec.incident_city              := v_incident_rec.incident_city;
             --cs_incident_rec.incident_state            := v_incident_rec.incident_state;
             --cs_incident_rec.incident_country           := v_incident_rec.incident_country;
             cs_incident_rec.incident_province          := v_incident_rec.incident_province;
             --cs_incident_rec.incident_postal_code       := v_incident_rec.incident_postal_code;
             --cs_incident_rec.incident_county           := v_incident_rec.incident_county;
             --cs_incident_rec.site_number                := v_incident_rec.party_site_number;
             --cs_incident_rec.site_name                  := v_incident_rec.site_name;
             --cs_incident_rec.addressee                 := v_incident_rec.addressee;
             cs_incident_rec.owner                      := v_incident_rec.owner ;
             cs_incident_rec.group_owner                := v_incident_rec.group_owner;
             --cs_incident_rec.cc_number                 := v_incident_rec.cc_number;
             --cs_incident_rec.cc_expiration_date         := v_incident_rec.cc_expiration_date;
             --cs_incident_rec.cc_type_code               := v_incident_rec.cc_type_code ;
             --cs_incident_rec.cc_first_name              := v_incident_rec.cc_first_name;
             --cs_incident_rec.cc_last_name               := v_incident_rec.cc_last_name;
             --cs_incident_rec.cc_middle_name             := v_incident_rec.cc_middle_name;
             --cs_incident_rec.cc_id                      := v_incident_rec.cc_id;
             cs_incident_rec.bill_to_account_id         := v_incident_rec.bill_to_account_id;
             cs_incident_rec.ship_to_account_id         := v_incident_rec.ship_to_account_id;
             cs_incident_rec.customer_phone_id          := v_incident_rec.customer_phone_id;
             cs_incident_rec.customer_email_id   	      := v_incident_rec.customer_email_id;
             cs_incident_rec.creation_program_code      := v_incident_rec.creation_program_code;
             cs_incident_rec.last_update_program_code   := v_incident_rec.last_update_program_code;
             cs_incident_rec.bill_to_party_id           := v_incident_rec.bill_to_party_id;
             --cs_incident_rec.ship_to_party_id          := v_incident_rec.ship_to_party_id;
             --cs_incident_rec.program_id                 := v_incident_rec.program_id;
             --cs_incident_rec.program_application_id     := v_incident_rec.program_application_id;
             --cs_incident_rec.conc_request_id            := v_incident_rec.request_id;
             cs_incident_rec.program_login_id           := v_incident_rec.program_login_id;
             cs_incident_rec.bill_to_site_id           := v_incident_rec.bill_to_site_id;
             --cs_incident_rec.ship_to_site_id           := v_incident_rec.ship_to_site_id;
             cs_incident_rec.incident_point_of_interest    := v_incident_rec.incident_point_of_interest;
             cs_incident_rec.incident_cross_street        := v_incident_rec.incident_cross_street;
             cs_incident_rec.incident_direction_qualifier     := v_incident_rec.incident_direction_qualifier;
             cs_incident_rec.incident_distance_qualifier      := v_incident_rec.incident_distance_qualifier;
             cs_incident_rec.incident_distance_qual_uom       := v_incident_rec.incident_distance_qual_uom;
             --cs_incident_rec.incident_address2                := v_incident_rec.incident_address2;
             --cs_incident_rec.incident_address3                := v_incident_rec.incident_address3;
             cs_incident_rec.incident_address4                := v_incident_rec.incident_address4;
             cs_incident_rec.incident_address_style           := v_incident_rec.incident_address_style;
             cs_incident_rec.incident_addr_lines_phonetic     := v_incident_rec.incident_addr_lines_phonetic;
             cs_incident_rec.incident_po_box_number           := v_incident_rec.incident_po_box_number;
             cs_incident_rec.incident_house_number            := v_incident_rec.incident_house_number;
             cs_incident_rec.incident_street_suffix           := v_incident_rec.incident_street_suffix;
             cs_incident_rec.incident_street                  := v_incident_rec.incident_street;
             cs_incident_rec.incident_street_number           := v_incident_rec.incident_street_number;
             cs_incident_rec.incident_floor                   := v_incident_rec.incident_floor;
             cs_incident_rec.incident_suite                   := v_incident_rec.incident_suite;
             cs_incident_rec.incident_postal_plus4_code      := v_incident_rec.incident_postal_plus4_code;
             cs_incident_rec.incident_position                := v_incident_rec.incident_position;
             cs_incident_rec.incident_location_directions     := v_incident_rec.incident_location_directions;
             cs_incident_rec.incident_location_description     := v_incident_rec.incident_location_description;
             cs_incident_rec.install_site_id                  := v_incident_rec.install_site_id;
             cs_incident_rec.item_serial_number			:= v_incident_rec.item_serial_number;
             cs_incident_rec.owning_department_id		:= v_incident_rec.owning_department_id;
             cs_incident_rec.incident_location_type		:= v_incident_rec.incident_location_type;
             cs_incident_rec.coverage_type           := v_incident_rec.coverage_type;
             cs_incident_rec.maint_organization_id    := v_incident_rec.maint_organization_id;
             cs_incident_rec.instrument_payment_use_id    := v_incident_rec.instrument_payment_use_id;

  
              fnd_file.put_line(v_logfile,'650 - Populating notes table -> '||mv_rec.incident_number);            
   
              -- -------------------------------------------------------------------------
              -- Populate SR Notes
              -- -------------------------------------------------------------------------
              sr_notes_tbl(1).note := ('Vehicle Details'||CHR(10));
              sr_notes_tbl(1).note_type := 'VEH_DETAILS';
              sr_notes_tbl(1).note_detail := ('Vehicle Manufacturer: '||mv_rec.veh_manuf||chr(10)||
                                              'Vehicle Model: '||mv_rec.veh_model||chr(10)||
                                              'Vehicle Reg: '||mv_rec.veh_reg||chr(10)||
                                              'VIN /Chassis: '||mv_rec.veh_vin_chassis||chr(10)||
                                              'Vehicle Year: '||mv_rec.veh_year||chr(10)||
                                              'TEI Feed: '||mv_rec.veh_tei_feed||chr(10)||
                                              'Aerial Type: '||mv_rec.veh_aerial_type||chr(10)||
                                              'Key Reader: '||mv_rec.veh_key_reader||chr(10)||
                                              'Tacho Make and Model: '||mv_rec.veh_tacho_mm||chr(10)||
                                              'PTO: '||mv_rec.veh_pto||chr(10)||
                                              'Gritter Control Unit Make and Model: '||mv_rec.veh_gcu||chr(10)||
                                              'Gully Cleaner: '||mv_rec.veh_gully_cleaner||chr(10)||
                                              'Other Additional: '||mv_rec.veh_int_roaming||chr(10)||
                                              'Additional Information: Old VRN: '||mv_rec.veh_old_vrn||chr(10)||
                                              'Vehicle Descscription 1: '||mv_rec.veh_desc_field1||chr(10)||
                                              'Vehicle Descscription 2: '||mv_rec.veh_desc_field2||chr(10)||
                                              'Vehicle Descscription 3: '||mv_rec.veh_desc_field3);
        
              fnd_file.put_line(v_logfile,'660 - before call to SR Update API -> '||mv_rec.incident_number);
  
              -- -------------------------------------------------------------------------
              -- Call Service Request API 
              -- -------------------------------------------------------------------------
              update_service_request(v_incident_rec.incident_id, cs_incident_rec, sr_notes_tbl, sr_contact_tbl, lx_return_status, lx_error_msg);
        
              fnd_file.put_line(v_logfile,'670 - after call to SR Update API -> '||mv_rec.incident_number||' Return status -> '||lx_return_status||' Error Message -> '||lx_error_msg);
  
  
              -- -------------------------------------------------------------------------
              -- Write to report API results 
              -- -------------------------------------------------------------------------
              if (lx_return_status <> fnd_api.g_ret_sts_success) then
                  fnd_file.put_line(v_logfile,'680 - SR API Error -> '||lx_error_msg);
                  fnd_file.put_line(v_logfile,'690 - Add record to output report -> '||mv_rec.incident_number);
                  v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                              rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                              rpad(mv_rec.incident_number, 15)||'|'||
                              RPAD(mv_rec.veh_reg, 13)||'|'||'SR Update API Error : '||lx_error_msg;
                  add_msg(v_buffer, g_failed_tbl);
                  g_fail_count := g_fail_count + 1;
                  gshowfailed := true;           
     
              else
                  fnd_file.put_line(v_logfile,'700 - Add record to output report -> '||mv_rec.incident_number);
                  v_buffer := rpad(mv_rec.vmu_id||' '||mv_rec.cust_name, 50)||'|'||
                              rpad(nvl(to_char(mv_rec.cust_account), ' '), 15)||'|'||
                              rpad(mv_rec.incident_number, 15)||'|'||
                              rpad(mv_rec.veh_reg, 13)||'|'||
                              rpad('Yes', 10)||'|'||  
                              rpad(v_external_ref, 10)||'|'|| 
                              rpad(v_address_updated, 10)||'|'||
                              rpad(v_contact_updated, 10)||'|';
                  add_msg(v_buffer, g_success_tbl);
                  g_success_count := g_success_count + 1;             
              
              end if;
           END IF;
        fnd_file.put_line(v_logfile,'700 - FINISHED SR UPDATE'||CHR(10));            
        update_processed(mv_rec.vmu_id);
    
      END LOOP;
      
      fnd_file.put_line(v_logfile,'710 - Completed updating all records');
      report_exceptions;
      report_footer;
      
      IF gShowFailed THEN
          p_retcode := gc_warning;
      ELSE
          p_retcode := gc_success;
      END IF;  
      
      fnd_file.put_line(v_logfile,'900 - Deleting processed....');

      delete_processed;    

      fnd_file.put_line(v_logfile,'1000 - Finished Mass Update....');

   EXCEPTION
      WHEN OTHERS THEN
         p_retcode  := gc_failed;
         p_errbuf   := 'Unexpected Exception : '||SQLERRM;
   END process_update;

END XXINO_VEH_MASS_UPDATE_PKG;
/
