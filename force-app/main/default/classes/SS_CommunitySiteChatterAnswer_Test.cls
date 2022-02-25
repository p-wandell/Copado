@isTest
private class SS_CommunitySiteChatterAnswer_Test {
	
	@isTest 
    private static void test_getCommunityId() {
        List<Community> communities = [select Id from Community where Name = :SS_CommunitySiteConstants.getCommunityName()];

		SS_CommunitySiteChatterAnswerController controller = new SS_CommunitySiteChatterAnswerController();
        
        Id communityId = controller.getCommunityId();
        if (communities.isEmpty()) {
            System.assertEquals(null, communityId);
        } else {
            System.assertNotEquals(null, communityId);
        }
	}
	
	@isTest 
    private static void test_forwardToCustomAuthPage() {
        SS_CommunitySiteChatterAnswerController controller = new SS_CommunitySiteChatterAnswerController();
        
        // Authenticated
        System.assertEquals(null, controller.forwardToCustomAuthPage());

        // Unauthenticated
        User guestUser = SS_TestUtils.initGuestUser();
        System.runAs(guestUser) {
            System.assertEquals('/Login?startURL=' + controller.startURL, controller.forwardToCustomAuthPage().getUrl());
        }
	}
	
}