package ch4.oracle.apps.xxhr.emp.schema.server;

import oracle.apps.fnd.framework.server.OADBTransaction;
import oracle.apps.fnd.framework.server.OAEntityDefImpl;
import oracle.apps.fnd.framework.server.OAEntityImpl;

import oracle.jbo.AttributeList;
import oracle.jbo.domain.Date;
import oracle.jbo.domain.Number;
import oracle.jbo.domain.RowID;
import oracle.jbo.server.AttributeDefImpl;
import oracle.jbo.server.EntityDefImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class EmpSocietiesEOImpl extends OAEntityImpl {
    public static final int ATTRIBUTE1 = 0;
    public static final int ATTRIBUTE10 = 1;
    public static final int ATTRIBUTE11 = 2;
    public static final int ATTRIBUTE12 = 3;
    public static final int ATTRIBUTE13 = 4;
    public static final int ATTRIBUTE14 = 5;
    public static final int ATTRIBUTE15 = 6;
    public static final int ATTRIBUTE16 = 7;
    public static final int ATTRIBUTE17 = 8;
    public static final int ATTRIBUTE18 = 9;
    public static final int ATTRIBUTE19 = 10;
    public static final int ATTRIBUTE2 = 11;
    public static final int ATTRIBUTE20 = 12;
    public static final int ATTRIBUTE3 = 13;
    public static final int ATTRIBUTE4 = 14;
    public static final int ATTRIBUTE5 = 15;
    public static final int ATTRIBUTE6 = 16;
    public static final int ATTRIBUTE7 = 17;
    public static final int ATTRIBUTE8 = 18;
    public static final int ATTRIBUTE9 = 19;
    public static final int ATTRIBUTECATEGORY = 20;
    public static final int CODE = 21;
    public static final int CREATEDBY = 22;
    public static final int CREATIONDATE = 23;
    public static final int DATEEND = 24;
    public static final int DATESTART = 25;
    public static final int LASTUPDATEDBY = 26;
    public static final int LASTUPDATEDATE = 27;
    public static final int LASTUPDATELOGIN = 28;
    public static final int PERSONID = 29;
    public static final int ROWID = 30;
    public static final int SOCIETYID = 31;
    public static final int SUBSAMOUNT = 32;
    public static final int SUBSHOLD = 33;
    public static final int SUBSPERIOD = 34;
    public static final int SUBSTOTAL = 35;


    private static OAEntityDefImpl mDefinitionObject;

    /**This is the default constructor (do not remove)
     */
    public EmpSocietiesEOImpl() {
    }


    /**Retrieves the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        if (mDefinitionObject == null) {
            mDefinitionObject = 
                    (OAEntityDefImpl)EntityDefImpl.findDefObject("ch4.oracle.apps.xxhr.emp.schema.server.EmpSocietiesEO");
        }
        return mDefinitionObject;
    }

    /**Add attribute defaulting logic in this method.
     */
    public void create(AttributeList attributeList) {
        super.create(attributeList);
        
        // To access database, we need the class - OADBTransaction
        OADBTransaction txn = getOADBTransaction();
        
        // SocietyId is obtained from the SEQUENCE called XXHR_PER_SOCIETIES_SEQ
        // and then we set the societyId by calling the setter method
        Number societyId = txn.getSequenceValue("XXHR_PER_SOCIETIES_SEQ");
        setSocietyId(societyId);
        
        // Set the default start date
        Date startDate = txn.getCurrentDBDate();
        setDateStart(startDate);
    }

    /**Add entity remove logic in this method.
     */
    public void remove() {
        super.remove();
    }

    /**Add Entity validation code in this method.
     */
    protected void validateEntity() {
        super.validateEntity();
    }

    /**Gets the attribute value for Attribute1, using the alias name Attribute1
     */
    public String getAttribute1() {
        return (String)getAttributeInternal(ATTRIBUTE1);
    }

    /**Sets <code>value</code> as the attribute value for Attribute1
     */
    public void setAttribute1(String value) {
        setAttributeInternal(ATTRIBUTE1, value);
    }

    /**Gets the attribute value for Attribute10, using the alias name Attribute10
     */
    public String getAttribute10() {
        return (String)getAttributeInternal(ATTRIBUTE10);
    }

    /**Sets <code>value</code> as the attribute value for Attribute10
     */
    public void setAttribute10(String value) {
        setAttributeInternal(ATTRIBUTE10, value);
    }

    /**Gets the attribute value for Attribute11, using the alias name Attribute11
     */
    public String getAttribute11() {
        return (String)getAttributeInternal(ATTRIBUTE11);
    }

    /**Sets <code>value</code> as the attribute value for Attribute11
     */
    public void setAttribute11(String value) {
        setAttributeInternal(ATTRIBUTE11, value);
    }

    /**Gets the attribute value for Attribute12, using the alias name Attribute12
     */
    public String getAttribute12() {
        return (String)getAttributeInternal(ATTRIBUTE12);
    }

    /**Sets <code>value</code> as the attribute value for Attribute12
     */
    public void setAttribute12(String value) {
        setAttributeInternal(ATTRIBUTE12, value);
    }

    /**Gets the attribute value for Attribute13, using the alias name Attribute13
     */
    public String getAttribute13() {
        return (String)getAttributeInternal(ATTRIBUTE13);
    }

    /**Sets <code>value</code> as the attribute value for Attribute13
     */
    public void setAttribute13(String value) {
        setAttributeInternal(ATTRIBUTE13, value);
    }

    /**Gets the attribute value for Attribute14, using the alias name Attribute14
     */
    public String getAttribute14() {
        return (String)getAttributeInternal(ATTRIBUTE14);
    }

    /**Sets <code>value</code> as the attribute value for Attribute14
     */
    public void setAttribute14(String value) {
        setAttributeInternal(ATTRIBUTE14, value);
    }

    /**Gets the attribute value for Attribute15, using the alias name Attribute15
     */
    public String getAttribute15() {
        return (String)getAttributeInternal(ATTRIBUTE15);
    }

    /**Sets <code>value</code> as the attribute value for Attribute15
     */
    public void setAttribute15(String value) {
        setAttributeInternal(ATTRIBUTE15, value);
    }

    /**Gets the attribute value for Attribute16, using the alias name Attribute16
     */
    public String getAttribute16() {
        return (String)getAttributeInternal(ATTRIBUTE16);
    }

    /**Sets <code>value</code> as the attribute value for Attribute16
     */
    public void setAttribute16(String value) {
        setAttributeInternal(ATTRIBUTE16, value);
    }

    /**Gets the attribute value for Attribute17, using the alias name Attribute17
     */
    public String getAttribute17() {
        return (String)getAttributeInternal(ATTRIBUTE17);
    }

    /**Sets <code>value</code> as the attribute value for Attribute17
     */
    public void setAttribute17(String value) {
        setAttributeInternal(ATTRIBUTE17, value);
    }

    /**Gets the attribute value for Attribute18, using the alias name Attribute18
     */
    public String getAttribute18() {
        return (String)getAttributeInternal(ATTRIBUTE18);
    }

    /**Sets <code>value</code> as the attribute value for Attribute18
     */
    public void setAttribute18(String value) {
        setAttributeInternal(ATTRIBUTE18, value);
    }

    /**Gets the attribute value for Attribute19, using the alias name Attribute19
     */
    public String getAttribute19() {
        return (String)getAttributeInternal(ATTRIBUTE19);
    }

    /**Sets <code>value</code> as the attribute value for Attribute19
     */
    public void setAttribute19(String value) {
        setAttributeInternal(ATTRIBUTE19, value);
    }

    /**Gets the attribute value for Attribute2, using the alias name Attribute2
     */
    public String getAttribute2() {
        return (String)getAttributeInternal(ATTRIBUTE2);
    }

    /**Sets <code>value</code> as the attribute value for Attribute2
     */
    public void setAttribute2(String value) {
        setAttributeInternal(ATTRIBUTE2, value);
    }

    /**Gets the attribute value for Attribute20, using the alias name Attribute20
     */
    public String getAttribute20() {
        return (String)getAttributeInternal(ATTRIBUTE20);
    }

    /**Sets <code>value</code> as the attribute value for Attribute20
     */
    public void setAttribute20(String value) {
        setAttributeInternal(ATTRIBUTE20, value);
    }

    /**Gets the attribute value for Attribute3, using the alias name Attribute3
     */
    public String getAttribute3() {
        return (String)getAttributeInternal(ATTRIBUTE3);
    }

    /**Sets <code>value</code> as the attribute value for Attribute3
     */
    public void setAttribute3(String value) {
        setAttributeInternal(ATTRIBUTE3, value);
    }

    /**Gets the attribute value for Attribute4, using the alias name Attribute4
     */
    public String getAttribute4() {
        return (String)getAttributeInternal(ATTRIBUTE4);
    }

    /**Sets <code>value</code> as the attribute value for Attribute4
     */
    public void setAttribute4(String value) {
        setAttributeInternal(ATTRIBUTE4, value);
    }

    /**Gets the attribute value for Attribute5, using the alias name Attribute5
     */
    public String getAttribute5() {
        return (String)getAttributeInternal(ATTRIBUTE5);
    }

    /**Sets <code>value</code> as the attribute value for Attribute5
     */
    public void setAttribute5(String value) {
        setAttributeInternal(ATTRIBUTE5, value);
    }

    /**Gets the attribute value for Attribute6, using the alias name Attribute6
     */
    public String getAttribute6() {
        return (String)getAttributeInternal(ATTRIBUTE6);
    }

    /**Sets <code>value</code> as the attribute value for Attribute6
     */
    public void setAttribute6(String value) {
        setAttributeInternal(ATTRIBUTE6, value);
    }

    /**Gets the attribute value for Attribute7, using the alias name Attribute7
     */
    public String getAttribute7() {
        return (String)getAttributeInternal(ATTRIBUTE7);
    }

    /**Sets <code>value</code> as the attribute value for Attribute7
     */
    public void setAttribute7(String value) {
        setAttributeInternal(ATTRIBUTE7, value);
    }

    /**Gets the attribute value for Attribute8, using the alias name Attribute8
     */
    public String getAttribute8() {
        return (String)getAttributeInternal(ATTRIBUTE8);
    }

    /**Sets <code>value</code> as the attribute value for Attribute8
     */
    public void setAttribute8(String value) {
        setAttributeInternal(ATTRIBUTE8, value);
    }

    /**Gets the attribute value for Attribute9, using the alias name Attribute9
     */
    public String getAttribute9() {
        return (String)getAttributeInternal(ATTRIBUTE9);
    }

    /**Sets <code>value</code> as the attribute value for Attribute9
     */
    public void setAttribute9(String value) {
        setAttributeInternal(ATTRIBUTE9, value);
    }

    /**Gets the attribute value for AttributeCategory, using the alias name AttributeCategory
     */
    public String getAttributeCategory() {
        return (String)getAttributeInternal(ATTRIBUTECATEGORY);
    }

    /**Sets <code>value</code> as the attribute value for AttributeCategory
     */
    public void setAttributeCategory(String value) {
        setAttributeInternal(ATTRIBUTECATEGORY, value);
    }

    /**Gets the attribute value for Code, using the alias name Code
     */
    public String getCode() {
        return (String)getAttributeInternal(CODE);
    }

    /**Sets <code>value</code> as the attribute value for Code
     */
    public void setCode(String value) {
        setAttributeInternal(CODE, value);
    }

    /**Gets the attribute value for CreatedBy, using the alias name CreatedBy
     */
    public Number getCreatedBy() {
        return (Number)getAttributeInternal(CREATEDBY);
    }

    /**Sets <code>value</code> as the attribute value for CreatedBy
     */
    public void setCreatedBy(Number value) {
        setAttributeInternal(CREATEDBY, value);
    }

    /**Gets the attribute value for CreationDate, using the alias name CreationDate
     */
    public Date getCreationDate() {
        return (Date)getAttributeInternal(CREATIONDATE);
    }

    /**Sets <code>value</code> as the attribute value for CreationDate
     */
    public void setCreationDate(Date value) {
        setAttributeInternal(CREATIONDATE, value);
    }

    /**Gets the attribute value for DateEnd, using the alias name DateEnd
     */
    public Date getDateEnd() {
        return (Date)getAttributeInternal(DATEEND);
    }

    /**Sets <code>value</code> as the attribute value for DateEnd
     */
    public void setDateEnd(Date value) {
        setAttributeInternal(DATEEND, value);
    }

    /**Gets the attribute value for DateStart, using the alias name DateStart
     */
    public Date getDateStart() {
        return (Date)getAttributeInternal(DATESTART);
    }

    /**Sets <code>value</code> as the attribute value for DateStart
     */
    public void setDateStart(Date value) {
        setAttributeInternal(DATESTART, value);
    }

    /**Gets the attribute value for LastUpdatedBy, using the alias name LastUpdatedBy
     */
    public Number getLastUpdatedBy() {
        return (Number)getAttributeInternal(LASTUPDATEDBY);
    }

    /**Sets <code>value</code> as the attribute value for LastUpdatedBy
     */
    public void setLastUpdatedBy(Number value) {
        setAttributeInternal(LASTUPDATEDBY, value);
    }

    /**Gets the attribute value for LastUpdateDate, using the alias name LastUpdateDate
     */
    public Date getLastUpdateDate() {
        return (Date)getAttributeInternal(LASTUPDATEDATE);
    }

    /**Sets <code>value</code> as the attribute value for LastUpdateDate
     */
    public void setLastUpdateDate(Date value) {
        setAttributeInternal(LASTUPDATEDATE, value);
    }

    /**Gets the attribute value for LastUpdateLogin, using the alias name LastUpdateLogin
     */
    public Number getLastUpdateLogin() {
        return (Number)getAttributeInternal(LASTUPDATELOGIN);
    }

    /**Sets <code>value</code> as the attribute value for LastUpdateLogin
     */
    public void setLastUpdateLogin(Number value) {
        setAttributeInternal(LASTUPDATELOGIN, value);
    }

    /**Gets the attribute value for PersonId, using the alias name PersonId
     */
    public Number getPersonId() {
        return (Number)getAttributeInternal(PERSONID);
    }

    /**Sets <code>value</code> as the attribute value for PersonId
     */
    public void setPersonId(Number value) {
        setAttributeInternal(PERSONID, value);
    }

    /**Gets the attribute value for RowID, using the alias name RowID
     */
    public RowID getRowID() {
        return (RowID)getAttributeInternal(ROWID);
    }

    /**Gets the attribute value for SocietyId, using the alias name SocietyId
     */
    public Number getSocietyId() {
        return (Number)getAttributeInternal(SOCIETYID);
    }

    /**Sets <code>value</code> as the attribute value for SocietyId
     */
    public void setSocietyId(Number value) {
        setAttributeInternal(SOCIETYID, value);
    }

    /**Gets the attribute value for SubsAmount, using the alias name SubsAmount
     */
    public String getSubsAmount() {
        return (String)getAttributeInternal(SUBSAMOUNT);
    }

    /**Sets <code>value</code> as the attribute value for SubsAmount
     */
    public void setSubsAmount(String value) {
        setAttributeInternal(SUBSAMOUNT, value);
    }

    /**Gets the attribute value for SubsHold, using the alias name SubsHold
     */
    public String getSubsHold() {
        return (String)getAttributeInternal(SUBSHOLD);
    }

    /**Sets <code>value</code> as the attribute value for SubsHold
     */
    public void setSubsHold(String value) {
        setAttributeInternal(SUBSHOLD, value);
    }

    /**Gets the attribute value for SubsPeriod, using the alias name SubsPeriod
     */
    public String getSubsPeriod() {
        return (String)getAttributeInternal(SUBSPERIOD);
    }

    /**Sets <code>value</code> as the attribute value for SubsPeriod
     */
    public void setSubsPeriod(String value) {
        setAttributeInternal(SUBSPERIOD, value);
    }

    /**Gets the attribute value for SubsTotal, using the alias name SubsTotal
     */
    public String getSubsTotal() {
        return (String)getAttributeInternal(SUBSTOTAL);
    }

    /**Sets <code>value</code> as the attribute value for SubsTotal
     */
    public void setSubsTotal(String value) {
        setAttributeInternal(SUBSTOTAL, value);
    }

    /**getAttrInvokeAccessor: generated method. Do not modify.
     */
    protected Object getAttrInvokeAccessor(int index, 
                                           AttributeDefImpl attrDef) throws Exception {
        switch (index) {
        case ATTRIBUTE1:
            return getAttribute1();
        case ATTRIBUTE10:
            return getAttribute10();
        case ATTRIBUTE11:
            return getAttribute11();
        case ATTRIBUTE12:
            return getAttribute12();
        case ATTRIBUTE13:
            return getAttribute13();
        case ATTRIBUTE14:
            return getAttribute14();
        case ATTRIBUTE15:
            return getAttribute15();
        case ATTRIBUTE16:
            return getAttribute16();
        case ATTRIBUTE17:
            return getAttribute17();
        case ATTRIBUTE18:
            return getAttribute18();
        case ATTRIBUTE19:
            return getAttribute19();
        case ATTRIBUTE2:
            return getAttribute2();
        case ATTRIBUTE20:
            return getAttribute20();
        case ATTRIBUTE3:
            return getAttribute3();
        case ATTRIBUTE4:
            return getAttribute4();
        case ATTRIBUTE5:
            return getAttribute5();
        case ATTRIBUTE6:
            return getAttribute6();
        case ATTRIBUTE7:
            return getAttribute7();
        case ATTRIBUTE8:
            return getAttribute8();
        case ATTRIBUTE9:
            return getAttribute9();
        case ATTRIBUTECATEGORY:
            return getAttributeCategory();
        case CODE:
            return getCode();
        case CREATEDBY:
            return getCreatedBy();
        case CREATIONDATE:
            return getCreationDate();
        case DATEEND:
            return getDateEnd();
        case DATESTART:
            return getDateStart();
        case LASTUPDATEDBY:
            return getLastUpdatedBy();
        case LASTUPDATEDATE:
            return getLastUpdateDate();
        case LASTUPDATELOGIN:
            return getLastUpdateLogin();
        case PERSONID:
            return getPersonId();
        case ROWID:
            return getRowID();
        case SOCIETYID:
            return getSocietyId();
        case SUBSAMOUNT:
            return getSubsAmount();
        case SUBSHOLD:
            return getSubsHold();
        case SUBSPERIOD:
            return getSubsPeriod();
        case SUBSTOTAL:
            return getSubsTotal();
        default:
            return super.getAttrInvokeAccessor(index, attrDef);
        }
    }

    /**setAttrInvokeAccessor: generated method. Do not modify.
     */
    protected void setAttrInvokeAccessor(int index, Object value, 
                                         AttributeDefImpl attrDef) throws Exception {
        switch (index) {
        case ATTRIBUTE1:
            setAttribute1((String)value);
            return;
        case ATTRIBUTE10:
            setAttribute10((String)value);
            return;
        case ATTRIBUTE11:
            setAttribute11((String)value);
            return;
        case ATTRIBUTE12:
            setAttribute12((String)value);
            return;
        case ATTRIBUTE13:
            setAttribute13((String)value);
            return;
        case ATTRIBUTE14:
            setAttribute14((String)value);
            return;
        case ATTRIBUTE15:
            setAttribute15((String)value);
            return;
        case ATTRIBUTE16:
            setAttribute16((String)value);
            return;
        case ATTRIBUTE17:
            setAttribute17((String)value);
            return;
        case ATTRIBUTE18:
            setAttribute18((String)value);
            return;
        case ATTRIBUTE19:
            setAttribute19((String)value);
            return;
        case ATTRIBUTE2:
            setAttribute2((String)value);
            return;
        case ATTRIBUTE20:
            setAttribute20((String)value);
            return;
        case ATTRIBUTE3:
            setAttribute3((String)value);
            return;
        case ATTRIBUTE4:
            setAttribute4((String)value);
            return;
        case ATTRIBUTE5:
            setAttribute5((String)value);
            return;
        case ATTRIBUTE6:
            setAttribute6((String)value);
            return;
        case ATTRIBUTE7:
            setAttribute7((String)value);
            return;
        case ATTRIBUTE8:
            setAttribute8((String)value);
            return;
        case ATTRIBUTE9:
            setAttribute9((String)value);
            return;
        case ATTRIBUTECATEGORY:
            setAttributeCategory((String)value);
            return;
        case CODE:
            setCode((String)value);
            return;
        case CREATEDBY:
            setCreatedBy((Number)value);
            return;
        case CREATIONDATE:
            setCreationDate((Date)value);
            return;
        case DATEEND:
            setDateEnd((Date)value);
            return;
        case DATESTART:
            setDateStart((Date)value);
            return;
        case LASTUPDATEDBY:
            setLastUpdatedBy((Number)value);
            return;
        case LASTUPDATEDATE:
            setLastUpdateDate((Date)value);
            return;
        case LASTUPDATELOGIN:
            setLastUpdateLogin((Number)value);
            return;
        case PERSONID:
            setPersonId((Number)value);
            return;
        case SOCIETYID:
            setSocietyId((Number)value);
            return;
        case SUBSAMOUNT:
            setSubsAmount((String)value);
            return;
        case SUBSHOLD:
            setSubsHold((String)value);
            return;
        case SUBSPERIOD:
            setSubsPeriod((String)value);
            return;
        case SUBSTOTAL:
            setSubsTotal((String)value);
            return;
        default:
            super.setAttrInvokeAccessor(index, value, attrDef);
            return;
        }
    }
}
