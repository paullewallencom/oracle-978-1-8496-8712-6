SELECT EmpSocietiesEO.SOCIETY_ID, 
       EmpSocietiesEO.CODE, 
       flv.MEANING,
       EmpSocietiesEO.DATE_START, 
       EmpSocietiesEO.DATE_END, 
       EmpSocietiesEO.SUBS_PERIOD, 
       EmpSocietiesEO.SUBS_AMOUNT, 
       EmpSocietiesEO.SUBS_TOTAL, 
       EmpSocietiesEO.SUBS_HOLD, 
       EmpSocietiesEO.PERSON_ID 
FROM  XXHR_PER_SOCIETIES EmpSocietiesEO
,     fnd_lookup_values flv
WHERE EmpSocietiesEO.code = flv.lookup_code (+)
  AND flv.lookup_type = 'XXHR_SOCIETY_LOV'