/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sExpFeaturedTopicsControllerTest {
    // Testing ConnectApi is difficult and without the "setTest" version of the method, we must use SeeAllData for testing.
    // See https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/connectAPI_TestingApex.htm for more details.
    @IsTest(SeeAllData=true)
    static void testGetFeaturedTopics() {
        ConnectApi.ManagedTopicCollection testTopicCollection = new ConnectApi.ManagedTopicCollection();

        Test.startTest();

        testTopicCollection = x7sExpFeaturedTopicsController.getFeaturedTopics();
        System.assert(testTopicCollection.managedTopics != null);

        Test.stopTest();
    }
}