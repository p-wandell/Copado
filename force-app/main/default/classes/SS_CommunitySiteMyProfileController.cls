public with sharing class SS_CommunitySiteMyProfileController {
    
/*
    public PageReference forwardToCustomAuthPage() {
        // this should go back to MyCases since we don't have access to Id till the user is authenticated
        String startURL = '%2FMyProfile';
        return SS_CommunitySiteUtil.forwardToCustomAuthPage(startURL);        
    }
*/
    public PageReference forwardToProfilePage() {
        PageReference pr = new PageReference(SS_CommunitySiteConstants.USER_PROFILE_URL);
        pr.setRedirect(true);
        return pr;
    }
}