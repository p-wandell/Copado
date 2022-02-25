@isTest
private class SS_CommunitySiteTemplateController_Test {
	
	@isTest 
    private static void test_forwardToCustomAuthPage() {
        SS_CommunitySiteTemplateController controller = new SS_CommunitySiteTemplateController();

        System.assert(controller.forwardToCustomAuthPage().getUrl().endsWith('/SS_CommunitySiteHome'));
    }
    @isTest
	private static void test_isPageAuthenticated() {
	    // Authenticated
	    System.assertEquals(true, SS_CommunitySiteUtil.isPageAuthenticated());

	    // Unauthenticated
	    User guestUser = SS_TestUtils.initGuestUser();
	    System.runAs(guestUser) {
	        System.assertEquals(false, SS_CommunitySiteUtil.isPageAuthenticated());
	    }
    }
}