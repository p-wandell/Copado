/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasTopicController {
	private static final Integer TOPIC_LOAD_LIMIT = 2000;

	@AuraEnabled
	public static List<String> getTopicNamesList() {
		Id networkId = System.Network.getNetworkId();
		List<String> topicNamesList = new List<String>();
		List<Topic> topicList = new List<Topic>();

		if (networkId != null) { topicList = [SELECT CreatedById,CreatedDate,Description,Id,Name,NetworkId,TalkingAbout FROM Topic WHERE NetworkId = :networkId];
		}
		else {
			topicList = [
				SELECT CreatedById,CreatedDate,Description,Id,Name,NetworkId,TalkingAbout
				FROM Topic
				LIMIT :TOPIC_LOAD_LIMIT
			];
		}

		for (Topic t : topicList) {
			topicNamesList.add(t.Name);
		}

		return topicNamesList;
	}

	@AuraEnabled
	public static Map <String, String> getTopicMap(List<String> uniqueTopicNames) {
		Id networkId = System.Network.getNetworkId();
		Map <String, String> topicNameToId = new Map <String, String>();
		List<Topic> topicList = new List<Topic>();
		try {
			if (networkId != null) { topicList = [SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout FROM Topic WHERE Name IN :uniqueTopicNames AND NetworkId = :networkId WITH SECURITY_ENFORCED];
			}
			else {
				topicList = [
					SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
					FROM Topic
					WHERE Name IN :uniqueTopicNames
					WITH SECURITY_ENFORCED
				];
			}

			for (Topic t : topicList) {
				topicNameToId.put(t.Name, t.Id);
			}
			System.debug('----topicNameToId' + topicNameToId);

			return topicNameToId;
		} catch (Exception ex) { System.debug('getTopicMap() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());return null;}
	}
}