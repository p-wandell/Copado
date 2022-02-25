global with sharing class SS_CommunitySiteTermsController {

    public Boolean hideTerms {get;set;}

    public SS_CommunitySiteTermsController() {
        hideTerms = getHideTerms();

        if (getCookieValue() == false && SS_CommunitySiteUtil.isPageAuthenticated()) { setCookie(); }
    }

    @TestVisible
    private Boolean getHideTerms() {
        Boolean hideTermsField = [SELECT Id, Hide_Terms_Conditions__c FROM User WHERE Id =: UserInfo.getUserId()].Hide_Terms_Conditions__c;
        return hideTermsField || getCookieValue() || !SS_CommunitySiteUtil.isPageAuthenticated();
    }

    @RemoteAction
    global static void hideTerms() {
        User u = new User(Id = UserInfo.getUserId());
        u.Hide_Terms_Conditions__c = true;
        update u;
    }

    private static void setCookie() {
        Cookie c = new Cookie('ClosedTerms', 'true', null, -1, true);
        ApexPages.currentPage().setCookies(new Cookie[] { c });
    }

    public static void deleteCookie() {
        Cookie c = new Cookie('ClosedTerms', 'true', null, 0, true);
        ApexPages.currentPage().setCookies(new Cookie[] { c });
    }

    @TestVisible
    private static Boolean getCookieValue() {
        try
        {
            Cookie c = ApexPages.currentPage().getCookies().get('ClosedTerms');
            if (c != null) {
                return Boolean.valueOf(c.getValue());
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
}