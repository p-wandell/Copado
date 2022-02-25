/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francois korb on 8/11/17.
 */

@IsTest
private class SS_Members_TopicsController_Test {

	@TestSetup
	private static void setupTestData(){
		List<Topic> testTopics = new List<Topic>();

		for (Integer i =0; i < SVNSUMMITS_Members_TestConstants.TEST_TOPIC_COUNT; i++) {
			testTopics.add(new Topic (Name = 'Topic' + i));
		}

		insert testTopics;
	}

	private static testMethod void testGetTopicMap() {
		Test.startTest();

		Map<String, String> topicMap = SS_Members_TopicsController.getTopics();
		System.assertEquals(SVNSUMMITS_Members_TestConstants.TEST_TOPIC_COUNT, topicMap.size());
		System.debug('Topic ' + topicMap);
		
		Test.stopTest();
	}
}