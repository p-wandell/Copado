/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasVotersController {
	@AuraEnabled
	public static Boolean isAuthenticated() {
		return !Auth.CommunitiesUtil.isGuestUser();
	}

	@AuraEnabled (Cacheable=true)
	public static Boolean isNicknameDisplayEnabled() {
		return x7sIdeasUtility.isNicknameDisplayEnabled();
	}

	@AuraEnabled (Cacheable=true)
	public static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	@AuraEnabled (Cacheable=true)
	public static String getZoneId(String nameValue) {
		try {
			if (!String.isEmpty(nameValue)) {
				List<Community> currCommunity = [SELECT Id FROM Community WHERE Name = :nameValue WITH SECURITY_ENFORCED];
				if (currCommunity != null && currCommunity.size() > 0) {
					return currCommunity[0].Id;
				}
			}
		} catch (Exception ex) { System.debug('getIdeaSubscriberMap() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());}
		return '';
	}

	@AuraEnabled (Cacheable=true)
	public static Boolean isValidIdeaId(String ideaId, String zoneId) {
		Boolean isValid = true;
		try {

			Id currIdeaId = Id.valueOf(ideaId);
			Id zoneIdValue = Id.valueOf(zoneId);

			Integer countIdeas = [SELECT COUNT() FROM Idea WHERE Id = :currIdeaId AND CommunityId = :zoneIdValue];

			if (countIdeas == 0) {
				isValid = false;
			}
		}
		catch (Exception e) {
			isValid = false;
		}

		return isValid;
	}

	@AuraEnabled (Cacheable=true)
	public static Integer getTotalVoterCount(String recordId) {
		return [
			SELECT COUNT()
			FROM Vote
			WHERE ParentId = :recordId
			AND Type = 'UP'
		];
	}

	@AuraEnabled (Cacheable=true)
	public static User[] getIdeaVoters(String recordId, Integer numResults) {
		Integer numResultsValue = Integer.valueOf(numResults);

		try {
			if (Schema.SObjectType.User.fields.Id.isAccessible()
				&& Schema.SObjectType.User.fields.Name.isAccessible()
				&& Schema.SObjectType.User.fields.SmallPhotoUrl.isAccessible()
				&& Schema.SObjectType.User.fields.CommunityNickname.isAccessible()
				&& Schema.SObjectType.Vote.fields.Type.isAccessible()
				&& Schema.SObjectType.Vote.fields.ParentId.isAccessible()
				&& Schema.SObjectType.Vote.fields.CreatedById.isAccessible()) {
				return [SELECT Id, Name, SmallPhotoUrl, CommunityNickname FROM User WHERE Id IN (SELECT CreatedById FROM Vote WHERE ParentId = :recordId AND Type = 'UP') WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC LIMIT :numResultsValue];
			}
			else { return new List<User>();}
		}
		catch (Exception ex) { System.debug('getIdeaSubscriberMap() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());return new List<User>();}
	}
}