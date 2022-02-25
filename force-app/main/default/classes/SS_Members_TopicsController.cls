/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 8/11/17.
 */

global with sharing class SS_Members_TopicsController {

	private static Id netwrkId = System.Network.getNetworkId();

	// Set of fields used for checking access to Topic fields
	private static String [] TopicAccessFields = new String []{
			'Id',
			'Name'
	};

	@AuraEnabled
	global static Map<string, string> getTopics() {
		Map<string, string> topics = new Map<string, string>();
		List<Topic> topicList = new List<Topic>();
		Map<String, Schema.SObjectField> topicFldMap = Schema.SObjectType.Topic.fields.getMap();

		for (String fieldToCheck : TopicAccessFields) {
			if (!topicFldMap.get(fieldToCheck).getDescribe().isAccessible()) {
				throw new System.NoAccessException();
			}
		}

		topicList = netwrkId != null ? [SELECT Id, Name FROM Topic WHERE NetworkId = :netwrkId ORDER BY Name LIMIT 2000] : [SELECT Id, Name FROM Topic ORDER BY NAME LIMIT 2000];

		for (Topic t : topicList) {
			topics.put(t.Id, t.Name);
		}

		return topics;
	}
}