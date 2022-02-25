/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sMembersTopicsController_Test {

    @TestSetup
    private static void setupTestData() {
        List<Topic> testTopics = new List<Topic>();

        for (Integer i = 0; i < x7sMembersTestConstants.TEST_TOPIC_COUNT; i++) {
            testTopics.add(new Topic (Name = 'Topic' + i));
        }

        insert testTopics;
    }

    @IsTest
    private static void testGetTopicMap() {
        Test.startTest();

        Map<String, String> topicMap = x7sMembersTopicsController.getTopics();
        System.assertEquals(x7sMembersTestConstants.TEST_TOPIC_COUNT, topicMap.size());
        System.debug('Topic ' + topicMap);

        Test.stopTest();
    }
}