/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasSubscription {
	public static Boolean ideaSubscribe(String userId, String ideaId) {
		Boolean subscribed = false;

		if (String.isNotBlank(ideaId)) {
			List<X7S_Ideas_Subscription__c> ideaSubscriptions = getSubscription(userId, ideaId);

			if (ideaSubscriptions.size() == 0) {
				X7S_Ideas_Subscription__c newIdeaSubscription = new X7S_Ideas_Subscription__c(
					SubscriberId__c = userId,
					ParentId__c = ideaId);
				try {
					if (X7S_Ideas_Subscription__c.SObjectType.getDescribe().isCreateable()) {
						insert newIdeaSubscription;
						subscribed = true;
					}
				}
				catch (DmlException e) {
					System.debug('Failed to insert Idea subscription record: ' + e.getMessage());
				}
			}
		}

		return subscribed;
	}

	public static Boolean ideaUnSubscribe(String userId, String ideaId) {
		Boolean unSubscribed = false;

		if (String.isNotBlank(ideaId) &&
			X7S_Ideas_Subscription__c.SObjectType.getDescribe().isDeletable()) {
			List<X7S_Ideas_Subscription__c> ideaSubscriptions = getSubscription(userId, ideaId);

			if (ideaSubscriptions.size() > 0) {
				try {
					delete ideaSubscriptions;
					unSubscribed = true;
				}
				catch (DmlException e) {
					System.debug('Failed to remove Idea subscription record: ' + e.getMessage());
				}
			}
		}

		return unSubscribed;
	}

	public static Boolean ideaIsSubscribed(String userId, String ideaId) {
		Boolean isFollowing = false;

		if (String.isNotBlank(ideaId)) {
			List<X7S_Ideas_Subscription__c> ideaSubscriptions = getSubscription(userId, ideaId);

			if (ideaSubscriptions.size() > 0) {
				isFollowing = true;
			}
		}

		return isFollowing;
	}

	@TestVisible
	private static List<X7S_Ideas_Subscription__c> getSubscription(String userId, String ideaId) {
		String query = 'SELECT Id' +
			' FROM X7S_Ideas_Subscription__c ' +
			' WHERE ' +
			' SubscriberId__c = ' + '\'' + String.escapeSingleQuotes(userId) + '\'' +
			' AND ParentId__c = ' + '\'' + String.escapeSingleQuotes(ideaId) + '\'' +
			' LIMIT 1';

		// PMD : False positive, All variables are checked
		List<X7S_Ideas_Subscription__c> ideaSubscriptions = (List<X7S_Ideas_Subscription__c>) Database.query(query); //NOPMD

		return ideaSubscriptions;
	}
}