CREATE OR REPLACE PACKAGE body XXHR_PER_SOCIETIES_PVT IS
-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_PER_SOCIETIES_PVT
--            TYPE:   Package Body
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2011
--
--     DESCRIPTION:
--
--        This package body contains the public and local pl/sql procedures and functions for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
-----------------------------------------------------------------------------------------------------
      -- insert
      PROCEDURE insert_row (  P_CODE IN XXHR_PER_SOCIETIES.CODE%TYPE ,
                              P_DATE_START IN XXHR_PER_SOCIETIES.DATE_START%TYPE,
                              P_DATE_END IN XXHR_PER_SOCIETIES.DATE_END%TYPE ,
                              P_SUBS_PERIOD IN XXHR_PER_SOCIETIES.SUBS_PERIOD%TYPE ,
                              P_SUBS_AMOUNT IN XXHR_PER_SOCIETIES.SUBS_AMOUNT%TYPE ,
                              P_SUBS_TOTAL IN XXHR_PER_SOCIETIES.SUBS_TOTAL%TYPE ,
                              P_SUBS_HOLD IN XXHR_PER_SOCIETIES.SUBS_HOLD%TYPE ,
                              P_ATTRIBUTE_CATEGORY IN XXHR_PER_SOCIETIES.ATTRIBUTE_CATEGORY%TYPE ,
                              P_ATTRIBUTE1 IN XXHR_PER_SOCIETIES.ATTRIBUTE3%TYPE ,
                              P_ATTRIBUTE2 IN XXHR_PER_SOCIETIES.ATTRIBUTE2%TYPE ,
                              P_ATTRIBUTE3 IN XXHR_PER_SOCIETIES.ATTRIBUTE1%TYPE ,
                              P_ATTRIBUTE4 IN XXHR_PER_SOCIETIES.ATTRIBUTE4%TYPE ,
                              P_ATTRIBUTE5 IN XXHR_PER_SOCIETIES.ATTRIBUTE5%TYPE ,
                              P_ATTRIBUTE6 IN XXHR_PER_SOCIETIES.ATTRIBUTE6%TYPE ,            
                              P_ATTRIBUTE7 IN XXHR_PER_SOCIETIES.ATTRIBUTE7%TYPE ,
                              P_ATTRIBUTE8 IN XXHR_PER_SOCIETIES.ATTRIBUTE8%TYPE ,
                              P_ATTRIBUTE9 IN XXHR_PER_SOCIETIES.ATTRIBUTE9%TYPE ,
                              P_ATTRIBUTE10 IN XXHR_PER_SOCIETIES.ATTRIBUTE10%TYPE ,
                              P_ATTRIBUTE11 IN XXHR_PER_SOCIETIES.ATTRIBUTE13%TYPE ,
                              P_ATTRIBUTE12 IN XXHR_PER_SOCIETIES.ATTRIBUTE14%TYPE ,
                              P_ATTRIBUTE13 IN XXHR_PER_SOCIETIES.ATTRIBUTE11%TYPE ,
                              P_ATTRIBUTE14 IN XXHR_PER_SOCIETIES.ATTRIBUTE12%TYPE ,
                              P_ATTRIBUTE15 IN XXHR_PER_SOCIETIES.ATTRIBUTE15%TYPE ,
                              P_ATTRIBUTE16 IN XXHR_PER_SOCIETIES.ATTRIBUTE16%TYPE ,
                              P_ATTRIBUTE17 IN XXHR_PER_SOCIETIES.ATTRIBUTE17%TYPE,
                              P_ATTRIBUTE18 IN XXHR_PER_SOCIETIES.ATTRIBUTE18%TYPE ,
                              P_ATTRIBUTE19 IN XXHR_PER_SOCIETIES.ATTRIBUTE19%TYPE ,  
                              P_ATTRIBUTE20 IN XXHR_PER_SOCIETIES.ATTRIBUTE20%TYPE ,
                              P_CREATED_BY IN XXHR_PER_SOCIETIES.CREATED_BY%TYPE ,
                              P_CREATION_DATE IN XXHR_PER_SOCIETIES.CREATION_DATE%TYPE ,
                              P_LAST_UPDATE_DATE IN XXHR_PER_SOCIETIES.LAST_UPDATE_DATE%TYPE ,
                              P_LAST_UPDATED_BY IN XXHR_PER_SOCIETIES.LAST_UPDATED_BY%TYPE ,
                              P_LAST_UPDATE_LOGIN IN XXHR_PER_SOCIETIES.LAST_UPDATE_LOGIN%TYPE ,
                              P_PERSON_ID IN XXHR_PER_SOCIETIES.PERSON_ID%type) IS
        
        l_society_id XXHR_PER_SOCIETIES.SOCIETY_ID%TYPE;
     BEGIN
	  -- Create a unique sequence number for the SOCIETY_ID
      SELECT XXHR_PER_SOCIETIES_SEQ.NEXTVAL 
      INTO l_society_id 
      FROM dual;
	  
	  -- INSERT into the XXGR_PER_SCIETIES table      
      INSERT INTO  XXHR_PER_SOCIETIES ( SOCIETY_ID,
                                        CODE, 
                                        SUBS_PERIOD,  
                                        DATE_END,
                                        DATE_START, 
                                        SUBS_HOLD,
                                        SUBS_AMOUNT,
                                        SUBS_TOTAL, 
                                        PERSON_ID,
                                        ATTRIBUTE_CATEGORY, 
                                        ATTRIBUTE1,  
                                        ATTRIBUTE2,  
                                        ATTRIBUTE3, 
                                        ATTRIBUTE4, 
                                        ATTRIBUTE5,
                                        ATTRIBUTE6,
                                        ATTRIBUTE7,
                                        ATTRIBUTE8,
                                        ATTRIBUTE9, 
                                        ATTRIBUTE10, 
                                        ATTRIBUTE11,
                                        ATTRIBUTE12, 
                                        ATTRIBUTE13,   
                                        ATTRIBUTE14,  
                                        ATTRIBUTE15,    
                                        ATTRIBUTE16,
                                        ATTRIBUTE17,
                                        ATTRIBUTE18,
                                        ATTRIBUTE19, 
                                        ATTRIBUTE20,
                                        CREATION_DATE,    
                                        CREATED_BY,
                                        LAST_UPDATE_DATE,
                                        LAST_UPDATED_BY,
                                        LAST_UPDATE_LOGIN)
                                        VALUES (
                                        L_SOCIETY_ID,
                                        P_CODE, 
                                        P_SUBS_PERIOD,  
                                        P_DATE_END,
                                        P_DATE_START, 
                                        P_SUBS_HOLD,
                                        P_SUBS_AMOUNT,
                                        P_SUBS_TOTAL, 
                                        P_PERSON_ID,
                                        P_ATTRIBUTE_CATEGORY, 
                                        P_ATTRIBUTE1,  
                                        P_ATTRIBUTE2,  
                                        P_ATTRIBUTE3, 
                                        P_ATTRIBUTE4, 
                                        P_ATTRIBUTE5,
                                        P_ATTRIBUTE6,
                                        P_ATTRIBUTE7,
                                        P_ATTRIBUTE8,
                                        P_ATTRIBUTE9, 
                                        P_ATTRIBUTE10, 
                                        P_ATTRIBUTE11,
                                        P_ATTRIBUTE12, 
                                        P_ATTRIBUTE13,   
                                        P_ATTRIBUTE14,  
                                        P_ATTRIBUTE15,    
                                        P_ATTRIBUTE16,
                                        P_ATTRIBUTE17,
                                        P_ATTRIBUTE18,
                                        P_ATTRIBUTE19, 
                                        P_ATTRIBUTE20,
                                        P_CREATION_DATE,    
                                        P_CREATED_BY,
                                        P_LAST_UPDATE_DATE,
                                        P_LAST_UPDATED_BY,
                                        P_LAST_UPDATE_LOGIN);
        commit;
    END;
          -- update
   PROCEDURE update_row ( P_SOCIETY_ID IN XXHR_PER_SOCIETIES.SOCIETY_ID%TYPE ,
                          P_CODE IN XXHR_PER_SOCIETIES.CODE%TYPE ,
                          P_DATE_START IN XXHR_PER_SOCIETIES.DATE_START%TYPE,
                          P_DATE_END IN XXHR_PER_SOCIETIES.DATE_END%TYPE ,
                          P_SUBS_PERIOD IN XXHR_PER_SOCIETIES.SUBS_PERIOD%TYPE ,
                          P_SUBS_AMOUNT IN XXHR_PER_SOCIETIES.SUBS_AMOUNT%TYPE ,
                          P_SUBS_TOTAL IN XXHR_PER_SOCIETIES.SUBS_TOTAL%TYPE ,
                          P_SUBS_HOLD IN XXHR_PER_SOCIETIES.SUBS_HOLD%TYPE ,
                          P_ATTRIBUTE_CATEGORY IN XXHR_PER_SOCIETIES.ATTRIBUTE_CATEGORY%TYPE ,
                          P_ATTRIBUTE1 IN XXHR_PER_SOCIETIES.ATTRIBUTE3%TYPE ,
                          P_ATTRIBUTE2 IN XXHR_PER_SOCIETIES.ATTRIBUTE2%TYPE ,
                          P_ATTRIBUTE3 IN XXHR_PER_SOCIETIES.ATTRIBUTE1%TYPE ,
                          P_ATTRIBUTE4 IN XXHR_PER_SOCIETIES.ATTRIBUTE4%TYPE ,
                          P_ATTRIBUTE5 IN XXHR_PER_SOCIETIES.ATTRIBUTE5%TYPE ,
                          P_ATTRIBUTE6 IN XXHR_PER_SOCIETIES.ATTRIBUTE6%TYPE ,            
                          P_ATTRIBUTE7 IN XXHR_PER_SOCIETIES.ATTRIBUTE7%TYPE ,
                          P_ATTRIBUTE8 IN XXHR_PER_SOCIETIES.ATTRIBUTE8%TYPE ,
                          P_ATTRIBUTE9 IN XXHR_PER_SOCIETIES.ATTRIBUTE9%TYPE ,
                          P_ATTRIBUTE10 IN XXHR_PER_SOCIETIES.ATTRIBUTE10%TYPE ,
                          P_ATTRIBUTE11 IN XXHR_PER_SOCIETIES.ATTRIBUTE13%TYPE ,
                          P_ATTRIBUTE12 IN XXHR_PER_SOCIETIES.ATTRIBUTE14%TYPE ,
                          P_ATTRIBUTE13 IN XXHR_PER_SOCIETIES.ATTRIBUTE11%TYPE ,
                          P_ATTRIBUTE14 IN XXHR_PER_SOCIETIES.ATTRIBUTE12%TYPE ,
                          P_ATTRIBUTE15 IN XXHR_PER_SOCIETIES.ATTRIBUTE15%TYPE ,
                          P_ATTRIBUTE16 IN XXHR_PER_SOCIETIES.ATTRIBUTE16%TYPE ,
                          P_ATTRIBUTE17 IN XXHR_PER_SOCIETIES.ATTRIBUTE17%TYPE,
                          P_ATTRIBUTE18 IN XXHR_PER_SOCIETIES.ATTRIBUTE18%TYPE ,
                          P_ATTRIBUTE19 IN XXHR_PER_SOCIETIES.ATTRIBUTE19%TYPE ,  
                          P_ATTRIBUTE20 IN XXHR_PER_SOCIETIES.ATTRIBUTE20%TYPE ,
                          P_CREATED_BY IN XXHR_PER_SOCIETIES.CREATED_BY%TYPE ,
                          P_CREATION_DATE IN XXHR_PER_SOCIETIES.CREATION_DATE%TYPE ,
                          P_LAST_UPDATE_DATE IN XXHR_PER_SOCIETIES.LAST_UPDATE_DATE%TYPE ,
                          P_LAST_UPDATED_BY IN XXHR_PER_SOCIETIES.LAST_UPDATED_BY%TYPE ,
                          P_LAST_UPDATE_LOGIN IN XXHR_PER_SOCIETIES.LAST_UPDATE_LOGIN%TYPE ,
                          P_PERSON_ID IN XXHR_PER_SOCIETIES.PERSON_ID%type) IS
    BEGIN
	  -- UPDATE the XXGR_PER_SCIETIES table
      UPDATE XXHR_PER_SOCIETIES
      SET CODE = p_code, 
          SUBS_PERIOD = p_subs_period,  
          DATE_END = p_date_end,
          DATE_START = p_date_start, 
          SUBS_HOLD =  p_subs_hold,
          SUBS_AMOUNT = p_subs_amount,
          SUBS_TOTAL = p_subs_total, 
          PERSON_ID = p_person_id,
          ATTRIBUTE_CATEGORY = p_attribute_category, 
          ATTRIBUTE1 = p_attribute1,  
          ATTRIBUTE2 = p_attribute2,    
          ATTRIBUTE3 = p_attribute3,   
          ATTRIBUTE4 = p_attribute4,  
          ATTRIBUTE5 = p_attribute5,  
          ATTRIBUTE6 = p_attribute6,  
          ATTRIBUTE7 = p_attribute7,  
          ATTRIBUTE8 = p_attribute8,  
          ATTRIBUTE9 = p_attribute9,   
          ATTRIBUTE10 = p_attribute10,  
          ATTRIBUTE11 = p_attribute11,  
          ATTRIBUTE12 = p_attribute12,  
          ATTRIBUTE13 = p_attribute13,     
          ATTRIBUTE14 = p_attribute14,    
          ATTRIBUTE15 = p_attribute15,      
          ATTRIBUTE16 = p_attribute16,  
          ATTRIBUTE17 = p_attribute17,  
          ATTRIBUTE18 = p_attribute18,  
          ATTRIBUTE19 = p_attribute19,  
          ATTRIBUTE20 = p_attribute20,  
          CREATION_DATE = p_creation_date,      
          CREATED_BY = p_created_by,  
          LAST_UPDATE_DATE = p_last_update_date,  
          LAST_UPDATED_BY = p_last_updated_by,  
          LAST_UPDATE_LOGIN = p_last_update_login
      WHERE society_id = p_society_id;
      
      commit;
    END;
    -- del
    PROCEDURE delete_row(p_society_id IN XXHR_PER_SOCIETIES.SOCIETY_ID%type ) IS
    BEGIN
	  -- DELETE from the XXGR_PER_SCIETIES table
      DELETE FROM XXHR_PER_SOCIETIES
      WHERE SOCIETY_ID = p_society_id;
      
      commit;
    END;
	
	PROCEDURE insert_test_record (p_person_id IN PER_ALL_PEOPLE_F.PERSON_ID%TYPE) IS
   
    l_person_id per_all_people_f.person_id%TYPE := p_person_id;
	BEGIN

	  XXHR_PER_SOCIETIES_PVT.insert_row
		( P_CODE => 'CS01',
		  P_DATE_START => SYSDATE,
		  P_DATE_END => null,
		  P_SUBS_PERIOD => 'M',
		  P_SUBS_AMOUNT => '10.00',
		  P_SUBS_TOTAL => '120.00',
		  P_SUBS_HOLD => 'N',
		  P_ATTRIBUTE_CATEGORY => null,
		  P_ATTRIBUTE1 => null,
		  P_ATTRIBUTE2 => null,
		  P_ATTRIBUTE3 => null,
		  P_ATTRIBUTE4 => null,
		  P_ATTRIBUTE5 => null,
		  P_ATTRIBUTE6 => null,            
		  P_ATTRIBUTE7 => null,
		  P_ATTRIBUTE8 => null,
		  P_ATTRIBUTE9 => null,
		  P_ATTRIBUTE10 => null,
		  P_ATTRIBUTE11 => null,
		  P_ATTRIBUTE12 => null,
		  P_ATTRIBUTE13 => null,
		  P_ATTRIBUTE14 => null,
		  P_ATTRIBUTE15 => null,
		  P_ATTRIBUTE16 => null,
		  P_ATTRIBUTE17 => null,
		  P_ATTRIBUTE18 => null,
		  P_ATTRIBUTE19 => null,  
		  P_ATTRIBUTE20 => null,
		  P_CREATED_BY => FND_PROFILE.VALUE('USER_ID'),
		  P_CREATION_DATE => SYSDATE,
		  P_LAST_UPDATE_DATE => SYSDATE,
		  P_LAST_UPDATED_BY => FND_PROFILE.VALUE('USER_ID'),
		  P_LAST_UPDATE_LOGIN => FND_PROFILE.VALUE('USER_ID'),
		  P_PERSON_ID => l_person_id);
	END;		
END XXHR_PER_SOCIETIES_PVT;