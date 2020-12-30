package ch4.oracle.apps.xxhr.emp.server;

import ch4.oracle.apps.xxhr.emp.schema.server.EmpSocietiesEOImpl;

import oracle.apps.fnd.framework.server.OAViewRowImpl;

import oracle.jbo.domain.Date;
import oracle.jbo.domain.Number;
import oracle.jbo.domain.RowID;
import oracle.jbo.server.AttributeDefImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class EmpSocietiesVORowImpl extends OAViewRowImpl {
    public static final int SOCIETYID = 0;
    public static final int PERSONID = 1;
    public static final int CODE = 2;
    public static final int MEANING = 3;
    public static final int DATESTART = 4;
    public static final int DATEEND = 5;
    public static final int SUBSAMOUNT = 6;
    public static final int SUBSPERIOD = 7;
    public static final int SUBSTOTAL = 8;
    public static final int SUBSHOLD = 9;
    public static final int ROWID = 10;

    /**This is the default constructor (do not remove)
     */
    public EmpSocietiesVORowImpl() {
    }

    /**Gets EmpSocietiesEO entity object.
     */
    public EmpSocietiesEOImpl getEmpSocietiesEO() {
        return (EmpSocietiesEOImpl)getEntity(0);
    }

    /**Gets the attribute value for SOCIETY_ID using the alias name SocietyId
     */
    public Number getSocietyId() {
        return (Number) getAttributeInternal(SOCIETYID);
    }

    /**Sets <code>value</code> as attribute value for SOCIETY_ID using the alias name SocietyId
     */
    public void setSocietyId(Number value) {
        setAttributeInternal(SOCIETYID, value);
    }

    /**Gets the attribute value for PERSON_ID using the alias name PersonId
     */
    public Number getPersonId() {
        return (Number) getAttributeInternal(PERSONID);
    }

    /**Sets <code>value</code> as attribute value for PERSON_ID using the alias name PersonId
     */
    public void setPersonId(Number value) {
        setAttributeInternal(PERSONID, value);
    }

    /**Gets the attribute value for CODE using the alias name Code
     */
    public String getCode() {
        return (String) getAttributeInternal(CODE);
    }

    /**Sets <code>value</code> as attribute value for CODE using the alias name Code
     */
    public void setCode(String value) {
        setAttributeInternal(CODE, value);
    }

    /**Gets the attribute value for DATE_START using the alias name DateStart
     */
    public Date getDateStart() {
        return (Date) getAttributeInternal(DATESTART);
    }

    /**Sets <code>value</code> as attribute value for DATE_START using the alias name DateStart
     */
    public void setDateStart(Date value) {
        setAttributeInternal(DATESTART, value);
    }

    /**Gets the attribute value for DATE_END using the alias name DateEnd
     */
    public Date getDateEnd() {
        return (Date) getAttributeInternal(DATEEND);
    }

    /**Sets <code>value</code> as attribute value for DATE_END using the alias name DateEnd
     */
    public void setDateEnd(Date value) {
        setAttributeInternal(DATEEND, value);
    }

    /**Gets the attribute value for SUBS_AMOUNT using the alias name SubsAmount
     */
    public String getSubsAmount() {
        return (String) getAttributeInternal(SUBSAMOUNT);
    }

    /**Sets <code>value</code> as attribute value for SUBS_AMOUNT using the alias name SubsAmount
     */
    public void setSubsAmount(String value) {
        setAttributeInternal(SUBSAMOUNT, value);
    }

    /**Gets the attribute value for SUBS_PERIOD using the alias name SubsPeriod
     */
    public String getSubsPeriod() {
        return (String) getAttributeInternal(SUBSPERIOD);
    }

    /**Sets <code>value</code> as attribute value for SUBS_PERIOD using the alias name SubsPeriod
     */
    public void setSubsPeriod(String value) {
        setAttributeInternal(SUBSPERIOD, value);
    }

    /**Gets the attribute value for SUBS_TOTAL using the alias name SubsTotal
     */
    public String getSubsTotal() {
        return (String) getAttributeInternal(SUBSTOTAL);
    }

    /**Sets <code>value</code> as attribute value for SUBS_TOTAL using the alias name SubsTotal
     */
    public void setSubsTotal(String value) {
        setAttributeInternal(SUBSTOTAL, value);
    }

    /**Gets the attribute value for SUBS_HOLD using the alias name SubsHold
     */
    public String getSubsHold() {
        return (String) getAttributeInternal(SUBSHOLD);
    }

    /**Sets <code>value</code> as attribute value for SUBS_HOLD using the alias name SubsHold
     */
    public void setSubsHold(String value) {
        setAttributeInternal(SUBSHOLD, value);
    }

    /**Gets the attribute value for ROWID using the alias name RowID
     */
    public RowID getRowID() {
        return (RowID) getAttributeInternal(ROWID);
    }

    /**getAttrInvokeAccessor: generated method. Do not modify.
     */
    protected Object getAttrInvokeAccessor(int index, 
                                           AttributeDefImpl attrDef) throws Exception {
        switch (index) {
        case SOCIETYID:
            return getSocietyId();
        case PERSONID:
            return getPersonId();
        case CODE:
            return getCode();
        case MEANING:
            return getMeaning();
        case DATESTART:
            return getDateStart();
        case DATEEND:
            return getDateEnd();
        case SUBSAMOUNT:
            return getSubsAmount();
        case SUBSPERIOD:
            return getSubsPeriod();
        case SUBSTOTAL:
            return getSubsTotal();
        case SUBSHOLD:
            return getSubsHold();
        case ROWID:
            return getRowID();
        default:
            return super.getAttrInvokeAccessor(index, attrDef);
        }
    }

    /**setAttrInvokeAccessor: generated method. Do not modify.
     */
    protected void setAttrInvokeAccessor(int index, Object value, 
                                         AttributeDefImpl attrDef) throws Exception {
        switch (index) {
        case SOCIETYID:
            setSocietyId((Number)value);
            return;
        case PERSONID:
            setPersonId((Number)value);
            return;
        case CODE:
            setCode((String)value);
            return;
        case MEANING:
            setMeaning((String)value);
            return;
        case DATESTART:
            setDateStart((Date)value);
            return;
        case DATEEND:
            setDateEnd((Date)value);
            return;
        case SUBSAMOUNT:
            setSubsAmount((String)value);
            return;
        case SUBSPERIOD:
            setSubsPeriod((String)value);
            return;
        case SUBSTOTAL:
            setSubsTotal((String)value);
            return;
        case SUBSHOLD:
            setSubsHold((String)value);
            return;
        default:
            super.setAttrInvokeAccessor(index, value, attrDef);
            return;
        }
    }

    /**Gets the attribute value for the calculated attribute Meaning
     */
    public String getMeaning() {
        return (String) getAttributeInternal(MEANING);
    }

    /**Sets <code>value</code> as the attribute value for the calculated attribute Meaning
     */
    public void setMeaning(String value) {
        setAttributeInternal(MEANING, value);
    }

    /**Sets <code>value</code> as the attribute value for the calculated attribute RowID
     */
    public void setRowID(RowID value) {
        setAttributeInternal(ROWID, value);
    }
}
