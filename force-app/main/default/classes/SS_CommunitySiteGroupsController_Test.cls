@isTest
private class SS_CommunitySiteGroupsController_Test {
	
    private static User testUser;
    private static Account testAccount;
    private static CollaborationGroup testGroup;

    private static void setupData() {
        testGroup = new CollaborationGroup();
        testGroup.Name = 'Test Group';
        testGroup.CollaborationType = 'Public';
        insert testGroup;

        testAccount = new Account();
        testAccount.Name = 'Test';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.LastName = 'Smith';
        testContact.AccountId = testAccount.Id;
        insert testContact;

        testUser = SS_TestUtils.initCommunityUser();
        testUser.ContactId = testContact.Id;
        insert testUser;
    }

    @isTest
    private static void test_forwardToGroupPage() {
        setupData();

        SS_CommunitySiteGroupsController controller = new SS_CommunitySiteGroupsController();

        Test.startTest();

        // No group
        System.runAs(testUser) {
            System.assertEquals(null, controller.forwardToGroupPage());
            //System.assertEquals(SS_CommunitySiteConstants.GROUP_LIST_URL, controller.forwardToGroupPage().getUrl());
        }

        testAccount.Group_Id__c = testGroup.Id;
        update testAccount;

        // With group
        System.runAs(testUser) {
            System.assertEquals(SS_CommunitySiteConstants.GROUP_PROFILE_URL + testGroup.Id, controller.forwardToGroupPage().getUrl());
        }

        Test.stopTest();
		
	}
}