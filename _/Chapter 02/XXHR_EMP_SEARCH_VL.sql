CREATE OR REPLACE VIEW XXHR_EMP_SEARCH_VL AS
SELECT emp.person_id 
     , emp.full_name 
     , emp.employee_number 
     , emp.email_address
     , mgr.full_name mgr_full_name
     , mgr.employee_number mgr_employee_number
     , mgr.email_address mgr_email_address
     , emp.last_updated_by
     , emp.last_update_date
     , emp.last_update_login
     , emp.creation_date
     , emp.created_by
FROM   per_all_people_f emp
     , per_all_assignments_f empa
     , per_all_people_f mgr
WHERE emp.person_id = empa.person_id
  AND empa.supervisor_id = mgr.person_id 
  AND emp.attribute_category = 'EMP'
  AND empa.primary_flag = 'Y'
  AND SYSDATE BETWEEN TRUNC(emp.effective_start_date) AND TRUNC(emp.effective_end_date)
  AND SYSDATE BETWEEN TRUNC(empa.effective_start_date) AND TRUNC(empa.effective_end_date)
  AND SYSDATE BETWEEN TRUNC(mgr.effective_start_date) AND TRUNC(mgr.effective_end_date);
