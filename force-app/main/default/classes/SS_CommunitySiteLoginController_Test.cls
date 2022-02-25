@isTest 
private class SS_CommunitySiteLoginController_Test {

    /* Stolen from SiteLoginControllerTest */
    @isTest(SeeAllData=true) 
    private static void test_SS_CommunitySiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SS_CommunitySiteLoginController controller = new SS_CommunitySiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}