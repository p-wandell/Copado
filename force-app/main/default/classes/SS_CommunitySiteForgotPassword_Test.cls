@isTest
private class SS_CommunitySiteForgotPassword_Test {
	
    /* Stolen from ForgotPasswordControllerTest */
	@isTest(SeeAllData=true) 
    private static void test_forgotPassword() {
        SS_CommunitySiteForgotPasswordController controller = new SS_CommunitySiteForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        controller.forgotPassword();
        System.assert(controller.showAlert); 
    }
}