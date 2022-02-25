@isTest
private class GoogleRegistrationHandler_Test {

    private static User u;
    private static Auth.UserData data;

    private static void setupData() {
        u = SS_TestUtils.initGuestUser();

        data = new Auth.UserData('testId', 'testFirst', 'testLast', 'testFirst testLast', 'testuser@example.org', null, 
                                 'testuserlong', 'en_US', 'google', null, new Map<String, String>{'language' => 'en_US'});
    }

    @isTest
    private static void test_updateAdditionalFields() {
        setupData();

        GoogleRegistrationHandler handler = new GoogleRegistrationHandler();

        Test.startTest();

        handler.updateAdditionalFields(null, u, data);

        Test.stopTest();

        // data.identifier is the first value in the Auth.UserData constructor
        System.assertEquals(data.identifier, u.Google_Id__c);
    }
}