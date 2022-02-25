@isTest
private class SS_CommunitySiteSelfRegController_Test {
	
    /* Stolen from CommunitiesSelfRegControllerTest */
    @IsTest(SeeAllData=true) 
    public static void testCommunitiesSelfRegController() {
        SS_CommunitySiteSelfRegController controller = new SS_CommunitySiteSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.username = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null); 
        
        // Trigger the bot spam flow
        controller.spam = 'Totally spam';
        System.assert(controller.registerUser() == null);  
    }    
	
}