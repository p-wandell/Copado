public with sharing class SS_CommunitySiteForgotPasswordController {
	public String username {get; set;}  
    public Boolean showAlert {get; private set;}
    public Boolean success {get; private set;}

    public final String usernameSuffix {get; private set;} 
    
    public SS_CommunitySiteForgotPasswordController() {
		usernameSuffix = SS_CommunitySiteConstants.getUsernameSuffix();

        showAlert = false;
        success = false;
	}

    public void forgotPassword() {
        success = Site.forgotPassword(username + usernameSuffix);
        showAlert = true;

        //PageReference pr = new PageReference('/ForgotPassword');
        //pr.setRedirect(false);
        //return pr;
    }
}