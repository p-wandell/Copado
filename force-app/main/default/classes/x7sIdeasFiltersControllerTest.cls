/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sIdeasFiltersControllerTest {
	public static Network currNetwork;
	public static List<Community> currCommunity;
	public static Idea currIdea;

	@TestSetup
	static void testSetupData() {
		currCommunity = [SELECT Id, Name FROM Community WHERE IsActive = TRUE];
		System.assertNotEquals(null, currCommunity);
	}

	static void testSetupQuery() {
		currCommunity = [SELECT Id, Name FROM Community WHERE IsActive = TRUE];
		currIdea = [SELECT Id FROM Idea WHERE Title = 'test' ORDER BY CreatedDate DESC LIMIT 1];
		System.assertNotEquals(null, currIdea);
	}

	@IsTest
	static void test_getSitePrefix() {
		System.assertEquals('', x7sIdeasFiltersController.getSitePrefix());
	}

	@IsTest
	static void test_getPicklistValues() {
		System.assertNotEquals(null, x7sIdeasFiltersController.getCategoryValues());
		System.assertNotEquals(null, x7sIdeasFiltersController.getStatusValues());
	}

	@IsTest
	static void test_getTopicNamesList() {
		Topic t = new Topic(Name = 'UnitTestTopic');
		insert t;

		List<String> topicList = x7sIdeasFiltersController.getTopicNamesList();
		Boolean containsValue = false;

		for (String s : topicList) {
			if (s == 'UnitTestTopic') {
				containsValue = true;
			}
		}
		System.assertEquals(true, containsValue);
	}

	@IsTest
	static void test_getThemeValues() {
		List<String> objList = x7sIdeasFiltersController.getThemeValues();
		System.assertNotEquals(null, objList);
	}

	@IsTest
	static void test_isAuthenticated() {
		System.assertNotEquals(null, x7sIdeasFiltersController.isAuthenticated());
	}

	@IsTest
	static void test_showAccountFilter() {
		System.assertNotEquals(null, x7sIdeasFiltersController.showAccountFilter());
	}
}