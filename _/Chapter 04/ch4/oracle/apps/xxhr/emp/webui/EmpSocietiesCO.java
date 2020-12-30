/*===========================================================================+
 |   Copyright (c) 2001, 2005 Oracle Corporation, Redwood Shores, CA, USA    |
 |                         All rights reserved.                              |
 +===========================================================================+
 |  HISTORY                                                                  |
 +===========================================================================*/
package ch4.oracle.apps.xxhr.emp.webui;

import oracle.apps.fnd.common.VersionInfo;
import oracle.apps.fnd.framework.webui.OAControllerImpl;
import oracle.apps.fnd.framework.webui.OAPageContext;
import oracle.apps.fnd.framework.webui.beans.OAWebBean;
import oracle.apps.fnd.framework.OAApplicationModule;
import oracle.apps.fnd.framework.OAException;
import oracle.apps.fnd.framework.OAViewObject;


/**
 * Controller for ...
 */
public class EmpSocietiesCO extends OAControllerImpl
{
  public static final String RCS_ID="$Header$";
  public static final boolean RCS_ID_RECORDED =
        VersionInfo.recordClassVersion(RCS_ID, "%packagename%");

  /**
   * Layout and page setup logic for a region.
   * @param pageContext the current OA page context
   * @param webBean the web bean corresponding to the region
   */
  public void processRequest(OAPageContext pageContext, OAWebBean webBean)
  {
      super.processRequest(pageContext, webBean);
      OAApplicationModule am = pageContext.getApplicationModule(webBean);
      OAViewObject vo = (OAViewObject)am.findViewObject("EmpSearchVO1");
      if (vo != null) {
        vo.executeQuery();  
      }
  }

  /**
   * Procedure to handle form submissions for form elements in
   * a region.
   * @param pageContext the current OA page context
   * @param webBean the web bean corresponding to the region
   */
  public void processFormRequest(OAPageContext pageContext, OAWebBean webBean)
  {
    super.processFormRequest(pageContext, webBean);

    // Get the action in the employee region
    String actionInEmpRegion = pageContext.getParameter(EVENT_PARAM); 
    
    // Perform logic for clicking the addSociety image
    if (actionInEmpRegion.equals("addSociety")){
        // Get the personId of the employee we clicked the crete society ocon for
        String actionPersonId = pageContext.getParameter("paramMasterPersonId");     
        // Display the action and the personId in a message on the screen
        throw new OAException("Action triggered is " + actionInEmpRegion
                              + " and the PersonId captured is " + actionPersonId
                              , OAException.CONFIRMATION);
    }
    
  }

}
