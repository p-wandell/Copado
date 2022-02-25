/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasViewController {
	@AuraEnabled (Cacheable=true)
	public static x7sIdeasCommon getCommonSettings(String zoneName, Boolean loadCustomFields, String fieldSetName) {
		x7sIdeasCommon settings = new x7sIdeasCommon('', loadCustomFields);

		settings.sitePath = System.Site.getPathPrefix();
		settings.nicknameEnabled = x7sIdeasUtility.isNicknameDisplayEnabled();
		settings.isAuthenticated = x7sIdeasUtility.isAuthenticated();
		settings.zoneId = x7sIdeasUtility.getZoneId(zoneName);

		if (String.isNotBlank(fieldSetName)) { settings.customFields = settings.getCustomFields(fieldSetName);}

		return settings;
	}

	@AuraEnabled
	public static Boolean isAuthenticated() {
		return x7sIdeasUtility.isAuthenticated();
	}

	@AuraEnabled (Cacheable=true)
	public static Boolean isNicknameDisplayEnabled() {
		return x7sIdeasUtility.isNicknameDisplayEnabled();
	}

	@AuraEnabled (Cacheable=true)
	public static String getSitePrefix() {
		return x7sIdeasUtility.getSitePrefix();
	}

	private static UserRecordAccess getUserRecordAccess(String userId, String recordId) {
		String currentUserId = String.isBlank(userId) ? UserInfo.getUserId() : userId;
		try {
			return [
				SELECT RecordId,
					HasAllAccess,
					HasDeleteAccess,
					HasEditAccess,
					HasTransferAccess,
					HasReadAccess,
					MaxAccessLevel
				FROM UserRecordAccess
				WHERE UserId = :currentUserId
				AND RecordId = :recordId
				WITH SECURITY_ENFORCED
			];
		} catch (Exception ex) { System.debug('getUserRecordAccess() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());return null;}
	}

	@AuraEnabled
	public static Boolean isRecordEditable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasEditAccess;
		}
		catch (Exception e) { return false;}
	}

	@AuraEnabled
	public static Boolean isRecordDeletable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasDeleteAccess;
		}
		catch (Exception e) { return false;}
	}

	@AuraEnabled (Cacheable=true)
	public static Boolean userAuthorizedChatter() {
		System.debug('Check userAuthorizedChatter');
		Boolean authorized = false;

		x7sIdeasCommon settings = new x7sIdeasCommon('', false);
		String userId = UserInfo.getUserId();

		if (String.isNotBlank(settings.chatterPermissions)) {
			System.debug('Chatter permissions: ' + settings.chatterPermissions);
			authorized = x7sIdeasUtility.permissionSetMember(userId, settings.chatterPermissions);
		}

		if (!authorized && String.isNotBlank(settings.chatterProfiles)) {
			System.debug('Chatter profiles: ' + settings.chatterProfiles);
			authorized = x7sIdeasUtility.profileMember(userId, settings.chatterProfiles);
		}

		System.debug('    userAuthorizedChatter: ' + authorized);

		return authorized;
	}

	@AuraEnabled (Cacheable=true)
	public static String getZoneId(String nameValue) {
		return x7sIdeasUtility.getZoneId(nameValue);
	}

	@AuraEnabled (Cacheable=true)
	public static List<Topic> getTopicNamesList() {
		return x7sIdeasNewController.getTopicNamesList();
	}

	@AuraEnabled (Cacheable=true)
	public static Map<String, String> getTopicMap(String topicName) {
		List<String> topicNames = new List<String>();
		topicNames.add(topicName);

		return x7sIdeasTopicController.getTopicMap(topicNames);
	}

	@AuraEnabled
	public static x7sIdeasListWrapper getIdeaRecord(String zoneId, String recordId, String customFieldSetName) {
		x7sIdeasCommon settings = new x7sIdeasCommon('', true);
		List<x7sIdeasCustomField> customFields;

		Set<Id> ideasIds = new Set<Id>{recordId};
		Integer listSize = ideasIds.size();

		if (String.isNotBlank(customFieldSetName)) { customFields = settings.getCustomFields(customFieldSetName);}
		else { customFields = settings.customFields;}

		String query = 'SELECT Id,' +
			' Title,' +
			' Status,' +
			' CommunityId,' +
			' CreatedBy.Name,' +
			' CreatedBy.CommunityNickname,' +
			' CreatedBy.CreatedDate, ' +
			' CreatedById,' +
			' CreatorSmallPhotoUrl,' +
			' CreatedDate,' +
			' Categories,' +
			' VoteTotal,' +
			' AttachmentName,' +
			' NumComments,' +
			' Related_Topic_Name__c,' +
			' Requested_By__c,' +
			' IdeaThemeId,' +
			' IdeaTheme.Title,' +
			' Body,' +
			' X7S_Ideas_Extension__c' +
			getCustomFieldsString(customFields) +
			' FROM Idea WHERE Id IN :ideasIds' +
			' AND CommunityId = ' +
			'\'' + String.escapeSingleQuotes(zoneId) + '\'';

		x7sIdeasListWrapper wrapper = new x7sIdeasListWrapper(query, listSize, ideasIds);

		return wrapper;
	}

	private static String getCustomFieldsString(List<x7sIdeasCustomField> fieldList) {
		List<String> customFields = new List<String>();

		if (fieldList != null) {
			for (x7sIdeasCustomField field : fieldList) {
				customFields.add(field.apiName);
			}
		}

		return customFields.size() > 0 ? (', ' + String.join(customFields, ', ')) : '';
	}

	@AuraEnabled
	public static List<Idea> getMergedIdeas(String recordId, String zoneId) {
		Id parentIdValue = Id.valueOf(recordId);
		Id zoneIdValue = Id.valueOf(zoneId);
		try {
			List<Idea> mergedIdeas = [
				SELECT Id, Title, ParentIdeaId, CreatedById, CreatedDate, IsMerged, CommunityId
				FROM Idea
				WHERE IsMerged = TRUE AND ParentIdeaId = :parentIdValue AND CommunityId = :zoneIdValue 
				WITH SECURITY_ENFORCED
			];

			return mergedIdeas;

		} catch (Exception ex) { System.debug('getMergedIdeas() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());return null;}
	}

	@AuraEnabled
	public static Boolean deleteIdea(String ideaId) {
		return x7sIdeasNewController.deleteIdea(ideaId);
	}

	@AuraEnabled
	public static Vote vote(String recordId, Boolean isUp) {
		System.debug('Voting: ' + recordId + ', ' + isUp);
		Vote theVote = null;
		try {
			if (String.isNotBlank(recordId) &&  Vote.SObjectType.getDescribe().isCreateable()) {
				Id recordIdValue = Id.valueOf(recordId);
				theVote = new Vote();
				theVote.ParentId = recordIdValue;

				theVote.Type = isUp ? 'Up' : 'Down';

				insert theVote;
				System.debug('Voted: ' + theVote);
			}
		}
		catch (Exception e) {
			System.debug('Apex Error: ' + e);
			return null;
		}
		return theVote;
	}
	@AuraEnabled
	public static Vote deleteVote(String recordId) {
		System.debug('Voting: ' + recordId);
		Vote theVote = null;
		try {
			if (String.isNotBlank(recordId) &&  Vote.SObjectType.getDescribe().isDeletable()) {
				Id recordIdValue = Id.valueOf(recordId);
				theVote = [select Id from Vote where Id = :recordIdValue ];

				delete theVote;
				System.debug('Deleted Vote: ' + theVote);
			}
		}
		catch (Exception e) {
			System.debug('Apex Error: ' + e);
			return null;
		}
		return theVote;
	}
	@AuraEnabled (Cacheable=true)
	public static Vote getVote(String recordId) {
		// check if guest user
		String loggedInUserType = UserInfo.getUserType();

		if (loggedInUserType != 'Guest') {
			try {
				return [SELECT Id, ParentId, Type, CreatedById, IsDeleted FROM Vote WHERE ParentId = :recordId AND CreatedById = :UserInfo.getUserId() AND IsDeleted = FALSE LIMIT 1
				];
			}
			catch (Exception e) {
				// No votes yet
				Vote v = new Vote();
				v.ParentId = recordId;
				return v;
			}
		}
		else { return null;}
	}

	@AuraEnabled (Cacheable=true)
	public static List<String> getIdeaStatusValues() {
		return x7sIdeasUtility.getIdeaStatusValues();
	}

	// Subscription related
	// -----------------------------------------------
	@AuraEnabled
	public static Boolean followIdea(String ideaId) {
		return x7sIdeasSubscription.ideaSubscribe(UserInfo.getUserId(), ideaId);
	}

	@AuraEnabled
	public static Boolean unFollowIdea(String ideaId) {
		return x7sIdeasSubscription.ideaUnSubscribe(UserInfo.getUserId(), ideaId);
	}

	@AuraEnabled
	public static Boolean isFollowingIdea(String ideaId) {
		return x7sIdeasSubscription.ideaIsSubscribed(UserInfo.getUserId(), ideaId);
	}

	// Voting related
	// ------------------------------------------------------
	@AuraEnabled
	public static VotingDetails getVotingLimitsForAccount(String ideaId) {
		VotingDetails votingDetails = new VotingDetails();
		Boolean ignoreVoteLimit = false;

		String settingsQuery = 'SELECT ' + String.join(x7sIdeasCommon.commonSettingsFields, ', ')
			+ ' FROM ' + x7sIdeasCommon.IDEAS_SETTINGS
			+ ' WHERE DeveloperName = \'' + x7sIdeasCommon.IDEAS_DEVELOPER_NAME + '\''
			+ ' LIMIT 1';

		//PMD : False positive, All variables are checked
		X7S_Ideas_Setting__mdt ideasSettings = (X7S_Ideas_Setting__mdt) Database.query(settingsQuery); //NOPMD

		if (ideasSettings != null) {
			votingDetails.accountVoteLimitMessage = ideasSettings.Account_Limit_Message__c;
			ignoreVoteLimit = ideasSettings.Ignore_Vote_Limit_Field__c;
		}

		if (!ignoreVoteLimit) {
			
			List<User> usr = (List<User>) Database.query('SELECT Id, AccountId FROM User WHERE Id = ' + '\'' + String.escapeSingleQuotes(UserInfo.getUserId()) + '\' LIMIT 1');

			if (!usr.isEmpty() && usr[0].AccountId != null) {

				List<Account> acc = (List<Account>) Database.query('SELECT Id,Name, Account_Vote_Limit__c FROM Account WHERE Id = ' + '\'' + String.escapeSingleQuotes(usr[0].AccountId) + '\' LIMIT 1');

				Map<Id, Integer> mapVoteCounts = new Map<Id, Integer>();
				Integer voteCount = 0;

				if (!acc.isEmpty()) {
					if (acc[0].Account_Vote_Limit__c != null) { votingDetails.totalVotes = Integer.valueOf(acc[0].Account_Vote_Limit__c);}
					else { votingDetails.totalVotes = 0;}

					List<Vote> listOfVotes = (List<Vote>) Database.query('SELECT Id,ParentId,Parent.Type,CreatedById FROM Vote WHERE Parent.Type = \'Idea\' AND ParentId = ' + '\'' + String.escapeSingleQuotes(ideaId) + '\'');

					for (Vote vt : listOfVotes) {
						if (mapVoteCounts.containsKey(vt.CreatedById)) { mapVoteCounts.put(vt.CreatedById, mapVoteCounts.get(vt.CreatedById) + 1);}
						else { mapVoteCounts.put(vt.CreatedById, 1);}
					}

					List<User> listOfUsersVoted = (List<User>) Database.query('SELECT Id,ContactId,AccountId from User WHERE AccountId = ' + '\'' + String.escapeSingleQuotes(acc[0].Id) + '\'');

					for (User user : listOfUsersVoted) {
						if (mapVoteCounts.containsKey(user.Id)) { voteCount = voteCount + mapVoteCounts.get(user.Id);}
					}
					votingDetails.currentVoteCount = voteCount;
				}
			}
		}

		System.debug('getVotingLimitsForAccount - votingDetails: ' + votingDetails);

		return votingDetails;
	}

	public class VotingDetails {
		@AuraEnabled public Integer totalVotes;
		@AuraEnabled public Integer currentVoteCount;
		@AuraEnabled public String accountVoteLimitMessage;

		public VotingDetails() {
			totalVotes = 0;
			currentVoteCount = 0;
			accountVoteLimitMessage = '';
		}
	}
}