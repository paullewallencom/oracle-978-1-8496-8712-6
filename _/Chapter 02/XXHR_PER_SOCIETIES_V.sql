-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_PER_SOCIETIES_V
--            TYPE:   View for XXHRSOCC form 
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2011
--
--     DESCRIPTION:
--
--        This view is for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
-----------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW APPS.XXHR_PER_SOCIETIES_V (SOCIETY_ID, CODE, NAME, DATE_START, DATE_END, SUBS_AMOUNT, SUBS_PERIOD, SUBS_TOTAL, SUBS_HOLD, ATTRIBUTE_CATEGORY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20, LAST_UPDATE_DATE, LAST_UPDATED_BY, LAST_UPDATE_LOGIN, CREATED_BY, CREATION_DATE, PERSON_ID)
AS
  SELECT xps.SOCIETY_ID,
    xps.CODE,
    flv.MEANING,
    xps.DATE_START,
    xps.DATE_END,
    xps.SUBS_AMOUNT,
    xps.SUBS_PERIOD,
    xps.SUBS_TOTAL,
    xps.SUBS_HOLD,
    xps.ATTRIBUTE_CATEGORY,
    xps.ATTRIBUTE1,
    xps.ATTRIBUTE2,
    xps.ATTRIBUTE3,
    xps.ATTRIBUTE4,
    xps.ATTRIBUTE5,
    xps.ATTRIBUTE6,
    xps.ATTRIBUTE7,
    xps.ATTRIBUTE8,
    xps.ATTRIBUTE9,
    xps.ATTRIBUTE10,
    xps.ATTRIBUTE11,
    xps.ATTRIBUTE12,
    xps.ATTRIBUTE13,
    xps.ATTRIBUTE14,
    xps.ATTRIBUTE15,
    xps.ATTRIBUTE16,
    xps.ATTRIBUTE17,
    xps.ATTRIBUTE18,
    xps.ATTRIBUTE19,
    xps.ATTRIBUTE20,
    xps.LAST_UPDATE_DATE,
    xps.LAST_UPDATED_BY,
    xps.LAST_UPDATE_LOGIN,
    xps.CREATED_BY,
    xps.CREATION_DATE,
	xps.PERSON_ID
  FROM xxhr_per_societies xps
    , fnd_lookup_values flv
  WHERE xps.code = flv.lookup_code (+)
    AND flv.lookup_type = 'XXHR_SOCIETY_LOV';