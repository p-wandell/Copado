@isTest
private class SS_CommunitySiteMyProfileController_Test {
	
    @isTest
    private static void test_forwardToProfilePage() {
		SS_CommunitySiteMyProfileController controller = new SS_CommunitySiteMyProfileController();

        Test.startTest();

        System.assertEquals(SS_CommunitySiteConstants.USER_PROFILE_URL, controller.forwardToProfilePage().getUrl());

        Test.stopTest();
	}
}