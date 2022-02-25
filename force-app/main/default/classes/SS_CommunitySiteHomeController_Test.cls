@isTest
private class SS_CommunitySiteHomeController_Test {
	
	@isTest 
    private static void test_forwardToCustomAuthPage() {
        SS_CommunitySiteHomeController controller = new SS_CommunitySiteHomeController();
        
        // Authenticated
        System.assertEquals(null, controller.forwardToCustomAuthPage());

        // Unauthenticated
        User guestUser = SS_TestUtils.initGuestUser();
        System.runAs(guestUser) {
            System.assertEquals('/Login?startURL=' + controller.startURL, controller.forwardToCustomAuthPage().getUrl());
        }
	}
	
}