/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

/**
 * : Apex class to provide access to the News object
 */
@SuppressWarnings('PMD.ExcessiveClassLength')
public with sharing class x7sNewsController {
	public static final String STR_SEARCH_TERM = 'Search Term';
	public static final String STR_NONE = 'None';
	public static final String STR_TOPIC_VALUE = 'Topic Value';
	public static final String FOR_GROUP_ID = 'Group';
	public static final Integer USER_SEARCH_LIMIT = 500;
	public static final String FOR_GUEST_TYPE = 'Guest';
	public static final String NEWS_FIELD_SEPARATOR = ',';
	private static final Integer NEWS_UNFOLLOW_LIMIT = 1000;

	//We need to use both networkId and strNetworkId to handle 15 digit and 18 digit id in news records as per CLF-210
	//
	//networkId of type id returns 18 digit id
	public static Id networkId = System.Network.getNetworkId();
	//networkId of type string i.e. strNetworkId returns 15 digit id
	public static String strNetworkId = System.Network.getNetworkId();

	public static String TOKEN_SOBJECT_NAME = 'X7S_News__c';
	public static String TOKEN_GROUP_NAME = 'News Article';

	//showNickName of type string. i.e it will get value from design attribute
	private static String strShowNickName;

	// Initial dataLoad for Detail and Header
	public class InitialData {
		@AuraEnabled public Boolean useNickName { get; set; }
		@AuraEnabled public Boolean canCreate { get; set; }
		@AuraEnabled public Boolean canDelete { get; set; }
		@AuraEnabled public Boolean canEdit { get; set; }
		@AuraEnabled public String sitePrefixStr { get; set; }

		public InitialData() {
			useNickName = false;
			canCreate = false;
			canDelete = false;
			canEdit = false;
			sitePrefixStr = '';
		}
	}

	@AuraEnabled(Cacheable=true)
	public static InitialData getInitialData(String recordId) {
		InitialData data = new InitialData();

		data.useNickName = isNicknameDisplayEnabled();
		data.sitePrefixStr = getSitePrefix();
		data.canCreate = isObjectCreatable();

		if (String.isNotBlank(recordId)) {
			data.canDelete = isRecordDeletable(recordId);
			data.canEdit = isRecordEditable(recordId);
		}

		return data;
	}

	// CUSTOM METADATA SETTINGS
	@AuraEnabled
	public static Boolean userAuthorizedToPost() {
		Boolean authorized = false;
		try {
			X7S_News_Setting__mdt setting = [
				SELECT PermissionSetName__c
				FROM X7S_News_Setting__mdt
				WHERE DeveloperName = 'Default'
				WITH SECURITY_ENFORCED
			];

			System.debug('userAuthorizedToPost name = ' + setting.PermissionSetName__c);
			authorized = permissionSetMember(UserInfo.getUserId(), setting.PermissionSetName__c);
		}
		catch (Exception ex) { System.debug(System.LoggingLevel.ERROR, 'X7S_News_Setting__mdt not configured ' + +ex.getMessage());}

		return authorized;
	}

	@AuraEnabled
	public static Boolean requireGroupMembership() {
		Boolean requireMembership = false;

		try {
			X7S_News_Setting__mdt setting = [
				SELECT Require_Group_Membership__c
				FROM X7S_News_Setting__mdt
				WHERE DeveloperName = 'Default'
				WITH SECURITY_ENFORCED
			];

			requireMembership = setting.Require_Group_Membership__c;
		}
		catch (Exception ex) { System.debug(System.LoggingLevel.ERROR, 'X7S_News_Setting__mdt not configured + ' + ex.getMessage());}

		return requireMembership;
	}

	public static Boolean userAuthorizedToViewAll() {
		Boolean authorized = false;
		try {
			X7S_News_Setting__mdt setting = [
				SELECT View_All_Permission_Set__c
				FROM X7S_News_Setting__mdt
				WHERE DeveloperName = 'Default'
				WITH SECURITY_ENFORCED
			];
			authorized = permissionSetMember(UserInfo.getUserId(), setting.View_All_Permission_Set__c);
		}
		catch (Exception ex) { System.debug(System.LoggingLevel.ERROR, 'CMT Author_Permission_Set__c : ' + ex.getMessage());}

		return authorized;
	}

	private static Boolean permissionSetMember(String userId, String permissionSetList) {
		Boolean isMember = false;

		if (String.isNotBlank(permissionSetList)) {
			List<String> permissionSets = permissionSetList.split(',\\s*');

			isMember = [SELECT COUNT() FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSet.Name IN :permissionSets] > 0;
		}

		return isMember;
	}


	// CURRENT USER
	@AuraEnabled
	public static User getCurrentUser() {
		return [SELECT Id, Name, CommunityNickname,LanguageLocaleKey,UserType FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
	}

	// LEX Mode
	@AuraEnabled(Cacheable=true)
	public static Boolean getLexMode() {
		return networkId == null && strNetworkId == null;
	}

	/*
		* MethodName		: getOrgNamespace
		* Description	   : Method for getting the namespace
	*/
	public static String getOrgNamespace() {
		String thisNameSpace = x7sNewsBaseController.getModel().namespacePrefix;

		return String.isBlank(thisNameSpace) ? '' : thisNameSpace + '__';
	}

	// FOLLOWING
	@AuraEnabled
	public static Boolean isFollowing(String recordId) {
		return [
			SELECT COUNT()
			FROM EntitySubscription
			WHERE NetworkId = :System.Network.getNetworkId()
			AND ParentId = :recordId
			AND SubscriberId = :UserInfo.getUserId()
			LIMIT 1000
		] > 0;
	}

	@AuraEnabled
	public static Boolean followRecord(String recordId) {
		try {
			ConnectApi.ChatterUsers.follow(System.Network.getNetworkId(), UserInfo.getUserId(), recordId); return true;
		}
		catch (Exception e) {
			System.debug(e);
		}
		return false;
	}

	@AuraEnabled
	public static Boolean unfollowRecord(String recordId) {
		try {
			for (EntitySubscription follow : [
				SELECT Id
				FROM EntitySubscription
				WHERE NetworkId = :System.Network.getNetworkId() AND ParentId = :recordId AND SubscriberId = :UserInfo.getUserId()
				LIMIT :NEWS_UNFOLLOW_LIMIT
			]) { ConnectApi.Chatter.deleteSubscription(System.Network.getNetworkId(), follow.Id); return true;}
		}
		catch (Exception e) { System.debug(e.getMessage());}

		return false;
	}

	/*
	@Name		  :  isNicknameDisplayEnabled
	@Description   :  Method to fetch community setting for nick name to display users name or name as per setting.
	*/
	@AuraEnabled(Cacheable=true)
	public static Boolean isNicknameDisplayEnabled() {

		if (!hasNicknameDisplayEnabledQueried) {
			try {
				Network currNetwork = [SELECT Id, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :networkId WITH SECURITY_ENFORCED LIMIT 1];
				isNicknameDisplayEnabled = currNetwork.OptionsNicknameDisplayEnabled;
			}
			catch (Exception e) {
				System.debug(e.getMessage());
				isNicknameDisplayEnabled = true;
			}
			finally {
				hasNicknameDisplayEnabledQueried = true;
			}
		}
		return isNicknameDisplayEnabled;
	}
	@TestVisible private static Boolean hasNicknameDisplayEnabledQueried = false;
	@TestVisible private static Boolean isNicknameDisplayEnabled = true;

	// ACCESS TO OBJECT
	@AuraEnabled(Cacheable=true)
	public static Boolean isObjectCreatable() {

		Boolean isCreateEnabled = false;
		if (Schema.SObjectType.X7S_News__c.isCreateable()) {
			isCreateEnabled = true;
		}
		return isCreateEnabled;
	}

	@AuraEnabled(Cacheable=true)
	public static Boolean isObjectEditable() {

		Boolean isEditEnabled = false;
		if (Schema.SObjectType.X7S_News__c.isUpdateable()) {
			isEditEnabled = true;
		}
		return isEditEnabled ;
	}

	@AuraEnabled(Cacheable=true)
	public static Boolean isRecordEditable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasEditAccess;
		}
		catch (Exception e) { return false;}
	}

	@AuraEnabled(Cacheable=true)
	public static Boolean isRecordDeletable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasDeleteAccess;
		}
		catch (Exception e) { return false;}
	}

	@AuraEnabled(Cacheable=true)
	public static Boolean isRecordShareable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasAllAccess;
		}
		catch (Exception e) { return false;}
	}

	@AuraEnabled
	public static Boolean deleteRecord(String recordId) {
		try {
			if (!X7S_News__c.SObjectType.getDescribe().isDeletable()) {
				System.debug('deleteRecord(): Unable to delete X7S_News__c');
				return false;
			}

			UserRecordAccess access = getUserRecordAccess(UserInfo.getUserId(), recordId);
			if (access.HasDeleteAccess) {
//				if (audienceEnabled())
//				{
//					String audience = getAudienceIdForRecordId(strNetworkId, UserInfo.getUserId(), recordId);
//					if (String.isNotBlank(audience))
//					{
//						deleteAudienceRecord(strNetworkId, UserInfo.getUserId(), recordId);
//					}
//				}
				System.debug('deleting record ' + recordId);
				delete new X7S_News__c(Id = recordId);
				return true;
			}
			else {
				System.debug('No delete access');
			}
		}
		catch (Exception e) { System.debug(e);}

		return false;
	}

	@TestVisible
	private static UserRecordAccess getUserRecordAccess(String userId, String recordId) {
		return [
			SELECT RecordId,
				HasAllAccess,
				HasDeleteAccess,
				HasEditAccess,
				HasTransferAccess,
				HasReadAccess,
				MaxAccessLevel
			FROM UserRecordAccess
			WHERE UserId = :userId
			AND RecordId = :recordId
			WITH SECURITY_ENFORCED
		];
	}

	@AuraEnabled
	public static Boolean getNewsFeedEnabled() {
		return Schema.SObjectType.X7S_News__c.isFeedEnabled();
	}

	/**
	 * :  Method to News Records as per different criteria in different components
	 *
	 * @param numberOfNewsPerPage
	 * @param strRecordId
	 * @param networkIds
	 * @param sortBy
	 * @param filterByTopic
	 * @param filterByAuthor
	 * @param topicName
	 * @param filterOn
	 * @param searchTerm
	 * @param fromDate
	 * @param toDate
	 * @param listofNewsIds
	 *
	 * @return
	 */
	@AuraEnabled
	public static x7sNewsWrapper getNews(
		Integer numberOfNewsPerPage,
		String strRecordId,
		String networkIds,
		String sortBy,
		String filterByTopic,
		String filterByAuthor,
		String topicName,
		String filterOn,
		String searchTerm,
		String fromDate,
		String toDate,
		List<String> listofNewsIds) {

		Datetime fromDt;
		Datetime toDt;
		String networkClause, topicNetworkClause;

		try {
			//create datetime instance of fromDate and toDate as we get them in string format
			if (String.isNotBlank(fromDate) || String.isNotBlank(toDate)) {

				if (String.isNotBlank(fromDate) && fromDate.length() > 0) {
					List<String> lstOfFromDt = fromDate.split('-');

					//set date by splitting string because expected format is mm/dd/yyyy but we are getting string in yy/mm/dd
					fromDt = Datetime.newInstance(
						Integer.valueOf(lstOfFromDt[0]),
						Integer.valueOf(lstOfFromDt[1]),
						Integer.valueOf(lstOfFromDt[2]),
						0, 0, 0);
				}

				if (String.isNotBlank(toDate) && toDate.length() > 0) {
					List<String> lstOfToDt = toDate.split('-');

					//set date by splitting string because expected format is mm/dd/yyyy but we are getting string in yy/mm/dd

					toDt = Datetime.newInstance(
						Integer.valueOf(lstOfToDt[0]),
						Integer.valueOf(lstOfToDt[1]),
						Integer.valueOf(lstOfToDt[2]),
						23, 59, 59);
				}
			}
		}
		catch (Exception e) { System.debug(e.getMessage()); return new x7sNewsWrapper('Date', e.getMessage());}

		try {
			// note this variable is also declared in the Wrapper
			// as we pass the QUERY string to the wrapper
			// not needed here but makes the code more readable
			Datetime rightNow = Datetime.now();
			System.assertNotEquals(null, rightNow);

			Integer intLimit = Integer.valueOf(numberOfNewsPerPage);
			String recId = validateId(strRecordId);

			// Group membership
			Boolean requireGroupId = requireGroupMembership();

			//set of topicIds ,authorIds and newsIds for filter criteria
			Set<String> topicIds = new Set<String>();
			Set<String> newsIds = new Set<String>();
			Set<String> authorIds = new Set<String>();

			// Multi Language
			Set<String> multiLngIds = new Set<String>();
			String userLanguage = getLanguage();
			User currentUser = getCurrentUser();
			Boolean useMultiLanguage = String.isNotBlank(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE;

			// disable Audience for users that can Authorise news via permission set
			Boolean useAudience = audienceEnabled() && !userAuthorizedToViewAll();
			List<String> audienceIds = new List<String>();

			if (useAudience) {
				audienceIds = getAudienceTargetIds(strNetworkId);
				System.debug('Using audience - ' + audienceIds);
			}

			//collect news id related to similar topics
			if (filterOn != STR_SEARCH_TERM && String.isNotBlank(strRecordId)) {
				System.debug('Search term: ' + STR_SEARCH_TERM + ' ' + String.valueOf(strRecordId));

				if (String.isNotBlank(recId)) {
					String queryTopicAssignment = getQueryString('TopicAssignment');

					if (String.isNotBlank(queryTopicAssignment)) {
						queryTopicAssignment += ' WHERE EntityId = \'' + recId + '\''; // note: recId already sanitized

						topicNetworkClause = getNetworkClause('NetworkId', networkId, networkIds);

						if (String.isNotBlank(topicNetworkClause)) {
							queryTopicAssignment += ' AND ' + topicNetworkClause;
						}

						queryTopicAssignment += ' LIMIT 1000';
						List<TopicAssignment> topicAssignments = Database.query(queryTopicAssignment); // NOPMD - Embedded variables have been escaped

						//collect all topics related to X7S_News__c object
						for (TopicAssignment topicAssignment : topicAssignments) {
							topicIds.add(topicAssignment.TopicId);
						}

						//collect all news Ids related to topicIds above
						String queryTopicSubAssignment = getQueryString('TopicAssignment');
						queryTopicSubAssignment += ' WHERE TopicId IN : topicIds';
						queryTopicSubAssignment += String.isNotBlank(networkId) ? ' AND NetworkId = \'' + networkId + '\'' : '';

						queryTopicSubAssignment += ' LIMIT 1000';
						List<TopicAssignment> topics = Database.query(queryTopicSubAssignment); // NOPMD - Embedded variables have been escaped

						for (TopicAssignment topicAssignment : topics) {
							newsIds.add(topicAssignment.EntityId);
						}
					}
				}
			}

			// multi language enabled logic
			if (useMultiLanguage) {

				String queryNewsTranslate = getQueryString('X7S_News_Translation__c');

				//Translation Records
				if (String.isNotBlank(queryNewsTranslate)) {
					List<X7S_News_Translation__c> translateList;

					if (String.isNotBlank(searchTerm)) { translateList = Database.query(String.escapeSingleQuotes(queryNewsTranslate) + ' WHERE Title__c LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'' + ' AND Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\'');}
					else { translateList = Database.query(String.escapeSingleQuotes(queryNewsTranslate) + ' WHERE Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\'');}

					for (X7S_News_Translation__c newsRecord : translateList) { multiLngIds.add(newsRecord.Parent_X7S_News__c);}
				}

				//News Records
				String queryNewsArticle = getQueryString('X7S_News__c');
				if (String.isNotBlank(queryNewsArticle)) {

					List<X7S_News__c> newsList;

					if (String.isNotBlank(searchTerm)) { newsList = Database.query(String.escapeSingleQuotes(queryNewsArticle) + ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'' + ' AND Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\'');}
					else { newsList = Database.query(String.escapeSingleQuotes(queryNewsArticle) + ' WHERE Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\'');}

					for (X7S_News__c newsRecord : newsList) { multiLngIds.add(newsRecord.Id);}
				}
			}

			if (listofNewsIds.size() > 0) {
				if (useMultiLanguage) { multiLngIds = multiLanguageSet(listofNewsIds, multiLngIds);}
				else {
					newsIds.addAll(listofNewsIds);
				}
			}
			//system.debug('Final Values: '+multiLngIds);

			//fetch Query string for X7S_News__c (news) with child query attachment and user required fields
			String Query = getSobjectQueryString('X7S_News__c');


			if (String.isNotBlank(Query)) {
				// get recommended news records
				if (filterOn == STR_NONE && String.isNotBlank(strRecordId) && String.isNotBlank(recId)) {
					System.debug('**:1 get recommended news records');

					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);
					if (String.isNotBlank(networkClause)) {
						Query += ' WHERE ' + networkClause;
					}

					if (String.isNotBlank(searchTerm)) {
						Query += String.isBlank(networkId) ? ' WHERE' : ' AND ';
						if (String.isNotBlank(searchTerm)) { Query += ' Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';}
					}

					if (useMultiLanguage) { for (String ids : multiLngIds) { newsIds.add(ids);}} else {newsIds.addAll(listofNewsIds);}

					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';
					Query += ' AND Id IN : newsIds';

					if (useAudience) { Query += getAudienceQuery(audienceIds);}

					Query += ' AND Id != \'' + recId + '\'';
					Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c DESC ';
					Query += ' LIMIT : intLimit';
				}

				//get news records on search page as per searchterm entered with sort by filter selected by user
				else if (filterOn == STR_SEARCH_TERM && String.isNotBlank(searchTerm)) {
					System.debug('**:2 get news records on search page as per search term entered with sort by filter selected by user');

					if (String.isNotBlank(searchTerm) && searchTerm.trim().length() > 0) {
						searchTerm = String.escapeSingleQuotes(searchTerm.trim());
					}

					if (useMultiLanguage) { Query += ' WHERE id  IN : multiLngIds ';}
					else {
						if (String.isNotBlank(searchTerm)) {
							Query += ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
						}
					}

					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';

					if (useAudience) { Query += getAudienceQuery(audienceIds);}

					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);
					if (String.isNotBlank(networkClause)) {
						Query += ' AND ' + networkClause;
					}

					if (sortBy == 'Oldest First') {
						Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c';
					}

					if (sortBy == 'Most Recent') {
						Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c DESC';
					}
				}
				//get news records on Topic detail as per topicName selected by user
				else if (String.isNotBlank(topicName) && filterOn == STR_TOPIC_VALUE) {
					System.debug('**:3 get news records on Topic detail as per topicName selected by user');
					System.debug('Searching by topic: ' + topicName);

					newsIds = new Set<String>();

					//if (Schema.getGlobalDescribe().get('Topic').getDescribe().accessible)
					{
						//Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get('Topic').getDescribe().fields.getMap();

						//if (strFldNameToFldDesc.get('Name').getDescribe().isAccessible())
						{
							String queryStrTopic = getQueryString('TopicAssignment');

							if (String.isNotBlank(queryStrTopic)) {

								// hack for Topic names with spaces that are replaced with a '-' in the URL
								String subTopicQuery;

								// check if ID is passed as the parameter
								if (topicName instanceof Id) {
									subTopicQuery = ' WHERE Topic.Id = \'' + String.escapeSingleQuotes(topicName) + '\'';
								}
								else {
									if (topicName.indexOf('-') != -1) {
										subTopicQuery = ' WHERE Topic.Name LIKE \'%' + String.escapeSingleQuotes(topicName.replace('-', '%')) + '%\'';
									}
									else {
										subTopicQuery = ' WHERE Topic.Name = \'' + String.escapeSingleQuotes(topicName) + '\'';
									}
								}
								queryStrTopic += subTopicQuery;

								topicNetworkClause = getNetworkClause('NetworkId', networkId, networkIds);

								if (String.isNotBlank(topicNetworkClause)) {
									queryStrTopic += ' AND ' + topicNetworkClause;
								}
								queryStrTopic += ' LIMIT 500';

								System.debug('Topic query: ' + queryStrTopic);

								List<TopicAssignment> topicsLst = Database.query(queryStrTopic); // NOPMD - Embedded variables have been escaped

								for (TopicAssignment topic : topicsLst) {
									newsIds.add(topic.EntityId);
								}

								System.debug('News IDs filtered by topic list: ' + newsIds);
							}
						}
					}

					Query += ' Where Id IN : newsIds';

					if (useMultiLanguage) { Query += ' AND id  IN : multiLngIds ';}
					else { if (String.isNotBlank(searchTerm)) { Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';}}

					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';

					if (useAudience) { Query += getAudienceQuery(audienceIds);}

					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);

					if (String.isNotBlank(networkClause)) {
						Query += ' AND ' + networkClause;
					}

					if (sortBy == 'Oldest First') {
						Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c';
					}

					if (sortBy == 'Most Recent') {

						Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c DESC';
					}
				}
				// filter by group id (stored in topicName for now)
				else if (filterOn == FOR_GROUP_ID) {

					System.debug('**:4 filter by group id (stored in topicName for now');
					Query += ' WHERE GroupId__c  = \'' + String.escapeSingleQuotes(topicName) + '\'';


					if (useMultiLanguage) { Query += ' AND id  IN : multiLngIds ';}

					if (useAudience) { Query += getAudienceQuery(audienceIds);}

					Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c DESC';
					System.debug('Query for Groups : ' + Query);
				}
				//get news records on List View as per combination of Topic, date, Author and sort by
				else if (String.isNotBlank(filterByTopic) || String.isNotBlank(filterByAuthor) || fromDt != null || toDt != null || String.isNotBlank(sortBy)) {

					System.debug('**:5 get news records on List View as per combination of Topic, date, Author and sort by');

					Query += ' WHERE (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';


					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);

					if (String.isNotBlank(networkClause)) {
						Query += ' AND ' + networkClause;
					}

					if (useMultiLanguage) { Query += ' AND id  IN : multiLngIds ';}
					else { if (String.isNotBlank(searchTerm)) { Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';}}

					// PRIVATE GROUPS ---------------------------------------------------------------------------------
					// Hide Private items
					// re-purposed newsId for the group id's that the user is a member of
					// the 2 will never be used together in the same query
					// not great but it is difficult to add to the packaged WrapperNews parameters
					if (requireGroupId) {
						newsIds = getGroups().keySet();
						System.debug('My group list: ' + newsIds);
						Query += newsIds.size() > 0 ? ' AND (GroupId__c = null OR GroupId__c IN : newsIds)' : ' AND GroupId__c = null';
					}
					else {
						Query += ' AND Private_Group__c = false';
					}

					if (String.isNotBlank(filterByTopic) && filterByTopic.trim().length() > 0) {
						System.debug('Filter by topic: ' + filterByTopic);
						Set<String> topicLst = new Set<String>();
						topicLst.addAll(filterByTopic.split(NEWS_FIELD_SEPARATOR));

						Boolean fieldIsId = false;

						for (String topicNameEntry : topicLst) {
							if (topicNameEntry instanceof Id) { fieldIsId = true;}
							else { if (topicNameEntry.indexOf('-') != -1) { topicLst.add(topicNameEntry.replace('-', ' '));}}
						}
						System.debug('Topic list: ' + topicLst);

						List<String> topicIdList = new List<String>();
						String targetName = fieldIsId ? 'Id' : 'name';
						String topicIdQuery = 'SELECT Id, Name FROM Topic WHERE ' + targetName + ' IN : topicLst';
						List<Topic> topics = Database.query(String.escapeSingleQuotes(topicIdQuery));
						for (Topic entry : topics) {
							topicIdList.add(entry.Id);
						}

						newsIds = new Set<String>();

						String queryTopic = getQueryString('TopicAssignment');
						if (String.isNotBlank(queryTopic)) {
							queryTopic += ' WHERE TopicId IN :topicIdList ';
							queryTopic += ' LIMIT 1000';

							System.debug('Filter by topic query: ' + queryTopic);
							List<TopicAssignment> topicsLst = Database.query(queryTopic);

							for (TopicAssignment topic : topicsLst) {
								newsIds.add(topic.EntityId);
							}
						}

						Query += ' AND Id IN : newsIds';
					}

					if (String.isNotBlank(filterByAuthor) && filterByAuthor.trim().length() > 0) {
						authorIds = new Set<String>();
						authorIds.addAll(filterByAuthor.split(NEWS_FIELD_SEPARATOR));

						Query += ' AND Author__c IN : authorIds';
						Query += ' AND Show_Author__c = true';
					}

					if (fromDt != null || toDt != null) {
						if (fromDt != null) {
							Query += ' AND Publish_DateTime__c >=: fromDt ';
						}

						if (toDt != null) {
							Query += ' AND Publish_DateTime__c <=:  toDt ' ;
						}
					}

					Query += ' AND Publish_DateTime__c <= :rightNow ' ;

					if (useAudience) {
						Query += getAudienceQuery(audienceIds);
					}

					if (String.isNotBlank(sortBy)) {
						if (sortBy == 'Oldest First') {
							intLimit = Integer.valueOf(numberOfNewsPerPage);

							Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c';
						}

						if (sortBy == 'Most Recent') {
							intLimit = Integer.valueOf(numberOfNewsPerPage);

							Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c DESC';
						}
					}
				}
				//when no criteria is selected without sort by as well
				else {
					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);

					if (String.isNotBlank(networkClause)) {
						Query += ' WHERE ' + networkClause;
					}

					if (useMultiLanguage) { Query += ' AND Id  IN : multiLngIds ';}
					else if (newsIds.size() > 0) { Query += ' AND Id IN : newsIds';}
					else { if (String.isNotBlank(searchTerm)) { Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';}}

					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';

					if (useAudience) { Query += getAudienceQuery(audienceIds);}

					Query += ' WITH SECURITY_ENFORCED ORDER BY Publish_DateTime__c DESC';
				}

				//calling wrapper class to execute query and set controller parameters
				x7sNewsWrapper WrapperNews = new x7sNewsWrapper(
					Query,
					userLanguage,
					intLimit,
					newsIds,
					authorIds,
					fromDt,
					toDt,
					false,
					null,
					multiLngIds,
					currentUser.UserType,
					audienceIds);
				return WrapperNews;
			}
			else {
				return null;
			}
		}
		catch (Exception e) { return new x7sNewsWrapper('others', e.getMessage());}
	}

	public static Set<String> multiLanguageSet(List<String> newsIds, Set<String> multiLngIds) {
		Set<String> newsLanguageIds = new Set<String>();

		for (String id : newsIds) { if (multiLngIds.contains(id)) { newsLanguageIds.add(id);}}
		return newsLanguageIds;
	}

	/**
	 * Create the query sub-string to select news articles for the use's audience
	 *
	 * @param audienceIds list of target ids applicable to the user's audience
	 *
	 * @return sub-query string to select items for the user's target audience
	 */
	private static String getAudienceQuery(List<String> audienceIds) {
		return ' AND (Audience_Selected__c = false' + (audienceIds.size() > 0 ? ' OR Id IN : audienceIds' : '') + (') ');
	}

	@TestVisible
	private static String getNetworkClause(String targetField, String networkId, String networkIds) {
		String networkClause = '';

		if (String.isNotBlank(networkId)) {
			networkClause = targetField + ' = \'' + networkId + '\'';
		}
		else if (String.isNotBlank(networkIds)) {
			List<String> idList = new List<String>();
			for (String idItem : networkIds.split(NEWS_FIELD_SEPARATOR)) {
				idList.add(targetField + ' = \'' + String.escapeSingleQuotes(idItem) + '\'');
			}

			networkClause = String.join(idList, ' OR ');
		}
		else {
			networkClause = targetField + ' = null';
		}

		return ' ' + networkClause;
	}

	/*
	@Name		  :  nextPage
	@Description   :  Method used on click of "Next" in pagination to display news records as per numberOfNewsPerPage
	*/
	@AuraEnabled
	public static x7sNewsWrapper nextPage(
		Integer numberOfNewsPerPage,
		Integer pageNumber,
		String strRecordId,
		String networkIds,
		String sortBy,
		String filterByTopic,
		String filterByAuthor,
		String topicName,
		String filterOn,
		String searchTerm,
		String fromDate,
		String toDate,
		List<String> listofNewsIds) {

		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		x7sNewsWrapper nlw = getNews(
			numberOfNewsPerPage,
			strRecordId,
			networkIds,
			sortBy,
			filterByTopic,
			filterByAuthor,
			topicName,
			filterOn,
			searchTerm,
			fromDate,
			toDate,
			listofNewsIds);

		nlw.pageNumber = pageNumberValue;
		nlw.nextPage();

		return nlw;
	}

	/*
	@Name		  :  previousPage
	@Description   :  Method used on click of "Previous" in pagination to diaplay news records as per numberOfNewsPerPage
	*/
	@AuraEnabled
	public static x7sNewsWrapper previousPage(
		Integer numberOfNewsPerPage,
		Integer pageNumber,
		String strRecordId,
		String networkIds,
		String sortBy,
		String filterByTopic,
		String filterByAuthor,
		String topicName,
		String filterOn,
		String searchTerm,
		String fromDate,
		String toDate,
		List<String> listofNewsIds) {

		//Integer listSizeValue = numberOfNewsPerPage != null ? Integer.valueOf(numberOfNewsPerPage) : 50;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		x7sNewsWrapper nlw = getNews(
			numberOfNewsPerPage,
			strRecordId,
			networkIds,
			sortBy,
			filterByTopic,
			filterByAuthor,
			topicName,
			filterOn,
			searchTerm,
			fromDate,
			toDate,
			listofNewsIds);

		nlw.pageNumber = pageNumberValue;
		nlw.previousPage();

		return nlw ;
	}

	/**
	 * :  Method to fetch topics and display in dropdown of "Topic Filter" component.
	 *
	 * @return Map TopicId, Topic
	 */
	@AuraEnabled(Cacheable=true)
	public static Map<String, String> getTopics() {

		Map<String, String> topics = new Map<String, String>();
		List<Topic> topicList = new List<Topic>();

		String queryTopic = getQueryString('Topic');
		if (String.isNotBlank(queryTopic)) {
			if (String.isNotBlank(networkId)) {
				topicList = Database.query(String.escapeSingleQuotes(queryTopic) +
					' Where (NetworkId = \'' + String.escapeSingleQuotes(networkId) + '\'' +
					' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')' +
					' LIMIT 1000'
				);
			}
			else { topicList = Database.query(String.escapeSingleQuotes(queryTopic) + ' WHERE NetworkId = null' + ' LIMIT 1000');}

			for (Topic t : topicList) {
				topics.put(t.Id, t.Name);
			}

			return topics;
		}

		return null;
	}

	/**
	 * : Get a list of all the groups this user is a member of
	 *
	 * @return Map Groups Id, Group
	 */
	@AuraEnabled(Cacheable=true)
	public static Map<String, String> getGroups() {
		Map<String, String> groups = new Map<String, String>();

		for (CollaborationGroupMember member : [
			SELECT Id, CollaborationGroupId, CollaborationGroup.Name
			FROM CollaborationGroupMember
			WHERE MemberId = :UserInfo.getUserId() AND NetworkId = :networkId
			LIMIT 1000
		]) {
			groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
		}

		return groups;
	}

	/**
	 * : Get a list of all the groups
	 *
	 * @return Map GroupdId, Group
	 */
	@AuraEnabled(Cacheable=true)
	public static Map<String, String> getAllGroups() {
		Map<String, String> groups = new Map<String, String>();

		for (CollaborationGroupMember member : [
			SELECT Id, CollaborationGroupId, CollaborationGroup.Name
			FROM CollaborationGroupMember
			WHERE NetworkId = :networkId
			LIMIT 1000
		]) { groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);}

		return groups;
	}

	/**
	 * :  Method to fetch users and display in dropdown of "Author Filter" component.
	 *
	 * @return Map UserId, User
	 */
	@AuraEnabled(Cacheable=true)
	public static Map<String, String> getUsers() {

		Map<String, String> users = new Map<String, String>();
		String queryUser = getQueryString('NetworkMember') + ' n';

		if (String.isNotBlank(queryUser)) {
			List<NetworkMember> userLst;

			if (String.isNotBlank(networkId)) {
				userLst = Database.query(String.escapeSingleQuotes(queryUser) +
					' WHERE (NetworkId = \'' + String.escapeSingleQuotes(networkId) + '\'' +
					' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')' +
					' AND n.Member.IsActive = true' +
					' LIMIT ' + USER_SEARCH_LIMIT
				);
			}
			else { userLst = Database.query(String.escapeSingleQuotes(queryUser) + ' WHERE NetworkId = null' + ' AND n.Member.IsActive = true' + ' LIMIT ' + USER_SEARCH_LIMIT);}

			Boolean useNickname = isNicknameDisplayEnabled();
			for (NetworkMember u : userLst) {
				users.put(u.MemberId, useNickname ? u.Member.CommunityNickname : u.Member.Name);
			}

			// make sure we add the current user
			User currentUser = getCurrentUser();

			if (!users.containsKey(currentUser.Id)) { users.put(currentUser.Id, useNickname ? currentUser.CommunityNickname : currentUser.Name);}

			return users;
		}

		return null;
	}

	/**
	 * :  Method to search users and display for the dropdown of "Author Filter" component.
	 *
	 * @param searchString search string
	 *
	 * @return Map userId, user
	 */
	@AuraEnabled
	public static Map<String, String> searchUsers(String searchString) {
		Map<String, String> users = new Map<String, String>();
		String queryUser = getQueryString('NetworkMember') + ' n ';

		if (String.isNotBlank(queryUser)) {
			if (String.isNotBlank(networkId)) {
				queryUser += ' WHERE (NetworkId = \'' + networkId + '\'';
				queryUser += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			}
			else {
				queryUser += ' WHERE NetworkId = null';
			}

			if (String.isNotBlank(searchString)) {
				queryUser += ' AND (n.Member.Name LIKE \'%' + String.escapeSingleQuotes(String.valueOf(searchString)) + '%\')';
			}

			queryUser += ' AND n.Member.IsActive = true';
			queryUser += ' LIMIT ' + USER_SEARCH_LIMIT;

			System.debug(LoggingLevel.DEBUG, 'searchUsers QRY: ' + queryUser);
			List<NetworkMember> userLst = Database.query(queryUser); // NOPMD - Embedded variables have been escaped

			Boolean useNickName = isNicknameDisplayEnabled();

			for (NetworkMember u : userLst) { users.put(u.MemberId, useNickName ?  u.Member.CommunityNickname : u.Member.Name);}

			return users;
		}
		return null;
	}

	/**
	 * :  Method to fetch users and display in dropdown of "Author Filter" component.
	 *
	 * @return Map AuthorId, Author
	 */
	@AuraEnabled(Cacheable=true)
	public static Map<String, String> getAuthors() {
		Map<String, String> authors = new Map<String, String>();

		if (Schema.SObjectType.X7S_News__c.isAccessible() && Schema.SObjectType.X7S_News__c.fields.Author__c.isAccessible()) {
			String queryBefore = 'SELECT Author__c authorId, Author__r.Name authorName, Author__r.CommunityNickname authorNickname';
			String queryAfter = '';

			queryBefore += ' FROM ';
			queryBefore += getOrgNamespace();
			queryBefore += TOKEN_SOBJECT_NAME;

			queryAfter += ' AND Author__c != null';
			queryAfter += ' GROUP BY Author__c, Author__r.Name, Author__r.CommunityNickname';
			queryAfter += ' LIMIT ' + USER_SEARCH_LIMIT;

			List<AggregateResult> newsLst;

			if (String.isNotBlank(networkId)) {
				newsLst = Database.query(String.escapeSingleQuotes(queryBefore) +
					' Where (NetworkId__c = \'' + String.escapeSingleQuotes(networkId) + '\'' +
					' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')' +
					String.escapeSingleQuotes(queryAfter)
				);
			}
			else {
				newsLst = Database.query(String.escapeSingleQuotes(queryBefore) + ' Where NetworkId__c = null' + String.escapeSingleQuotes(queryAfter));
			}

			Boolean useNickName = isNicknameDisplayEnabled();

			for (AggregateResult n : newsLst) {
				authors.put(String.valueOf(n.get('authorId')),
					useNickName ? String.valueOf(n.get('authorNickname')) : String.valueOf(n.get('authorName')));
			}

			return authors;
		}

		return null;
	}
	/**
	 * :  Method to fetch site prefix so that urls are redirected properly dynamically in any org.
	 *
	 * @return Path prefix
	 */
	@AuraEnabled (Cacheable=true)
	public static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	/**
	 * Method to fetch featured news records to show on featured components.
	 *
	 * @param recordId1 record 1 etc.
	 * @param recordId2
	 * @param recordId3
	 * @param recordId4
	 * @param recordId5
	 *
	 * @return x7sNewsWrapper
	 */
	@AuraEnabled
	public static x7sNewsWrapper getFeaturedNews(String recordId1, String recordId2, String recordId3, String recordId4, String recordId5) {
		Map<String, String> featuredNewsIds = new Map<String, String>();
		Set<String> newsIds = new Set<String>();

		String newsRecordId1 = validateId(recordId1);
		if (String.isNotBlank(newsRecordId1)) {
			featuredNewsIds.put(newsRecordId1, newsRecordId1);
		}

		String newsRecordId2 = validateId(recordId2);
		if (String.isNotBlank(newsRecordId2)) {
			featuredNewsIds.put(newsRecordId2, newsRecordId2);
		}

		String newsRecordId3 = validateId(recordId3);
		if (String.isNotBlank(newsRecordId3)) {
			featuredNewsIds.put(newsRecordId3, newsRecordId3);
		}

		String newsRecordId4 = validateId(recordId4);
		if (String.isNotBlank(newsRecordId4)) {
			featuredNewsIds.put(newsRecordId4, newsRecordId4);
		}

		String newsRecordId5 = validateId(recordId5);
		if (String.isNotBlank(newsRecordId5)) {
			featuredNewsIds.put(newsRecordId5, newsRecordId5);
		}

		newsIds = featuredNewsIds.keySet();
		User currentUser = getCurrentUser();
		String Query = getSobjectQueryString('X7S_News__c');

		if (String.isNotBlank(Query)) {
			Query += ' Where Id IN : newsIds';
			if (String.isNotBlank(networkId)) {
				Query += ' AND (NetworkId__c = \'' + networkId + '\'';
				Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			}
			else {
				Query += ' AND NetworkId__c = null';
			}

			Query += ' LIMIT 5';

			return new x7sNewsWrapper(
				Query,
				getLanguage(),
				5,
				newsIds,
				null,
				null,
				null,
				true,
				featuredNewsIds,
				null,
				currentUser.UserType,
				null);
		}
		else {
			return null;
		}
	}

	static public String validateId(String idParam) {
		try {
			String recId = String.escapeSingleQuotes(idParam);
			return (String.isNotBlank(recId) && Id.valueOf(recId).getSobjectType() == X7S_News__c.SObjectType) ? recId : null;
		}
		catch (Exception e) {
			return null;
		}
	}

	/**
	 * Method to fetch news record as per newsRecordId used on news detail page components
	 *
	 * @param newsRecordId requested news record Id
	 *
	 * @return NewsWrapper
	 */
	@AuraEnabled
	public static x7sNewsWrapper getNewsRecord(String newsRecordId) {
		String Query = getSobjectQueryString('X7S_News__c');

		User currentUser = getCurrentUser();
		if (String.isNotBlank(Query)) {
			Query += ' Where Id = \'' + newsRecordId + '\'';
			if (String.isNotBlank(networkId)) {
				Query += ' AND (NetworkId__c = \'' + networkId + '\'';
				Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			}
			else {
				Query += ' AND NetworkId__c = null';
			}

			Query += ' AND Publish_DateTime__c <= :rightNow';
			Query += ' LIMIT 1';

			return new x7sNewsWrapper(Query, getLanguage(), 1, null, null, null, null, false, null, null, currentUser.UserType, null);

		}

		return null;
	}

	/**
	 * :  Method to save new news object used on create news component.
	 *
	 * @param model News object
	 * @param strFilterByTopic topic filter
	 * @param attachmentType Attachment Type
	 * @param attachmentName Image attachment file name
	 * @param image Featured image as a binary64 encoded string
	 * @param audience Target audience
	 *
	 * @return news model
	 */
	@AuraEnabled
	public static x7sNewsModel saveNews(
		String model,
		String strFilterByTopic,
		String attachmentType,
		String attachmentName,
		String image,
		String audience) {
		if (!X7S_News__c.SObjectType.getDescribe().isCreateable() ||
			!X7S_News__c.SObjectType.getDescribe().isUpdateable() ||
			!Attachment.SObjectType.getDescribe().isCreateable() ||
			!TopicAssignment.SObjectType.getDescribe().isCreateable() ||
			!TopicAssignment.SObjectType.getDescribe().isUpdateable() ||
			!TopicAssignment.SObjectType.getDescribe().isDeletable()) {
			System.debug('saveNews() : Access Denied!');
		}

		System.debug('Saving news: ' + attachmentName);

		x7sNewsModel modelCls = (x7sNewsModel) JSON.deserialize(model, x7sNewsModel.class);

		//String strNamespacePrefix = getOrgNamespace();

		//Schema.DescribeSObjectResult soBjRes = Schema.getGlobalDescribe().get(strNamespacePrefix + 'X7S_News__c').getDescribe();

		//if (soBjRes.accessible && soBjRes.createable)
		{
			X7S_News__c newsObj = new X7S_News__c();
			newsObj.Id = modelCls.id;
			newsObj.Name = modelCls.name;
			newsObj.Details__c = modelCls.details;
			newsObj.GroupId__c = modelCls.groupId;
			newsObj.Language__c = modelCls.language;
			newsObj.Private_Group__c = modelCls.privateGroup;
			newsObj.Show_Author__c = modelCls.showAuthor;
			newsObj.Author__c = modelCls.author;
			newsObj.Publish_DateTime__c = Datetime.valueOf(modelCls.publishDate);
			newsObj.Archive_DateTime__c = Datetime.valueOf(modelCls.archiveDate);
			newsObj.NetworkId__c = networkId;
			newsObj.Audience_Selected__c = String.isNotBlank(audience);

			Map<String, TopicAssignment> topicMap = new Map<String, TopicAssignment>();

			if (newsObj.Id != null) {
				String queryTopicAssignment = getQueryString('TopicAssignment');

				if (String.isNotBlank(queryTopicAssignment)) {
					List<TopicAssignment> topicAssignments = Database.query(String.escapeSingleQuotes(queryTopicAssignment) +
						' WHERE EntityId = \'' + String.escapeSingleQuotes(newsObj.Id) + '\'' + ' LIMIT 1000'
					);
					for (TopicAssignment tAssgn : topicAssignments) {
						topicMap.put(tAssgn.TopicId, tAssgn);
					}
				}
			}

			upsert newsObj;
			modelCls.id = newsObj.Id;

			if (String.isNotEmpty(image) && String.isNotEmpty(attachmentType) && String.isNotEmpty(attachmentName)) {
				System.debug('Saving attachment ' + attachmentName + ' for ' + newsObj.Id);

				Attachment attachment = new Attachment();
				attachment.Body = EncodingUtil.base64Decode(image);
				attachment.Name = String.valueOf(('' + attachmentName));
				attachment.ParentId = newsObj.Id;
				attachment.ContentType = attachmentType;
				insert attachment;
			}

			if (String.isNotBlank(strFilterByTopic) && strFilterByTopic.trim().length() > 0) {
				List<TopicAssignment> topicAssignmentLst = new List<TopicAssignment>();
				Set<String> topicLst = new Set<String>();

				topicLst.addAll(strFilterByTopic.split(NEWS_FIELD_SEPARATOR));
				Set<String> topicSet = new Set<String>();
				List<TopicAssignment> deleteAssignments = new List<TopicAssignment>();

				if (topicMap.size() > 0) {
					for (String topicId : topicMap.keySet()) {
						for (String tId : topicLst) {
							if (tId != topicId) {
								if (!topicSet.contains(tId)) {
									topicSet.add(tId);
									TopicAssignment t = new TopicAssignment();
									t.EntityId = newsObj.Id;
									t.TopicId = tId;
									topicAssignmentLst.add(t);
								}
							}
						}
						if (!topicLst.contains(topicId)) {
							deleteAssignments.add(topicMap.get(topicId));
						}
					}
				}
				else {
					for (String strTopicId : topicLst) {
						if (!String.isEmpty(strTopicId)) {
							TopicAssignment t = new TopicAssignment();
							t.EntityId = newsObj.Id;
							t.TopicId = strTopicId;
							topicAssignmentLst.add(t);
						}
					}
				}

				if (deleteAssignments.size() > 0) {
					System.debug('   topics - deleting: ' + deleteAssignments);
					delete deleteAssignments;
				}

				if (topicAssignmentLst.size() > 0) {
					System.debug('	topics - adding: ' + topicAssignmentLst);
					upsert topicAssignmentLst;
				}
			}

			System.debug('saved ****newsObj******' + newsObj);

			// Sharing - check CMT flag
			List<String> userOrGroupList;
			Datetime rightNow = Datetime.now();

			if (useManagedSharing()) {
				if (String.isNotBlank(newsObj.GroupId__c)) { userOrGroupList.add(newsObj.GroupId__c);} else { userOrGroupList = getUserGroupId();}

				if (newsObj.Publish_DateTime__c <= rightNow) { for (String userOrGroup : userOrGroupList) { shareRecord(newsObj, userOrGroup);}}
				else { for (String userOrGroup : userOrGroupList) { unShareRecord(newsObj, userOrGroup);}
				}
			}

			// create an audience target record for this item
			if (String.isNotBlank(audience)) { assignAudienceToRecord(audience, newsObj.Id, strNetworkId);}

			return modelCls;
		}

		//return null;
	}

	//Delete attachment where user updates attachment on news edit page
	@AuraEnabled
	public static void deleteAttachment(String newsRecordId) {
		if (!Attachment.SObjectType.getDescribe().isDeletable()) {
			System.debug('deleteAttachment() : Unable to delete Attachment');
			return;
		}

		List<Attachment> attachments = new List<Attachment>();
		attachments = [SELECT Id FROM Attachment WHERE ParentId = :newsRecordId];
		if (!attachments.isEmpty()) {
			delete attachments;
		}
	}

	/*
	@Name		  :  getAccessibleFields
	@Description   :  Method to check all fields used in query are accessible
	*/
	public static List<String> getAccessibleFields(String strObj) {

		Set<String> NewsAccessFields = new Set<String>{
			'Id',
			'Name',
			'Archive_DateTime__c',
			'Audience_Selected__c',
			'Author__c',
			'Details__c',
			'GroupId__c',
			'Language__c',
			'Like_Count__c',
			'NetworkId__c',
			'Private_Group__c',
			'Publish_DateTime__c',
			'Show_Author__c',
			'Show_Internal__c',
			'Image_Type__c',
			'Image_Reference__c'
		};

		Set<String> NewsTranslationAccessFields = new Set<String>{
			'Id',
			'Name',
			'Language__c',
			'Detail__c',
			'Parent_X7S_News__c',
			'Title__c'
		};
		Set<String> TopicAssignmentAccessFields = new Set<String>{
			'entityid',
			'topicid'
		};
		Set<String> TopicAccessFields = new Set<String>{
			'Id',
			'Name'
		};
		Set<String> AttachmentAccessFields = new Set<String>{
			'Id',
			'Name'
		};
		Set<String> NetworkMemberAccessFields = new Set<String>{
			'NetworkId'
		};

		List<String> objectAccessFields = null;

		switch on strObj {
			when 'X7S_News__c' {
				objectAccessFields = new List<String>(NewsAccessFields);
			}
			when 'X7S_News_Translation__c' {
				objectAccessFields = new List<String>(NewsTranslationAccessFields);
			}
			when 'TopicAssignment' {
				objectAccessFields = new List<String>(TopicAssignmentAccessFields);
			}
			when 'Topic' {
				objectAccessFields = new List<String>(TopicAccessFields);
			}
			when 'Attachment' {
				objectAccessFields = new List<String>(AttachmentAccessFields);
			}
			when 'NetworkMember' {
				objectAccessFields = new List<String>(NetworkMemberAccessFields);
			}
			when else {
				System.debug('getAccessibleFields - Unknown object request (' + strObj + ')');
			}
		}
		return objectAccessFields;
	}

	/*
	@Name		  :  getSobjectQueryString
	@Description   :  Method to generate dynamic query for objects used in process.
					  this method is generating query for News,Attachment (as child query),User (some fields of user needed in news object) as per our requirement
	*/
	public static String getSobjectQueryString(String strObj) {

		List<String> objectAccessFields = getAccessibleFields(strObj);

		if (objectAccessFields != null && objectAccessFields.size() > 0) {
			String query = '';
			List<String> childFields = getAccessibleFields('Attachment');


			objectAccessFields.add(String.escapeSingleQuotes('Author__r.Name'));
			objectAccessFields.add(String.escapeSingleQuotes('CreatedBy.Name'));
			objectAccessFields.add(String.escapeSingleQuotes('createdBy.FullPhotoUrl'));
			objectAccessFields.add(String.escapeSingleQuotes('Author__r.FullPhotoUrl'));
			objectAccessFields.add(String.escapeSingleQuotes('createdBy.SmallPhotoUrl'));
			objectAccessFields.add(String.escapeSingleQuotes('Author__r.SmallPhotoUrl'));
			objectAccessFields.add(String.escapeSingleQuotes('Author__r.CommunityNickName'));
			objectAccessFields.add(String.escapeSingleQuotes('createdBy.CommunityNickname'));

			query += 'SELECT ';
			query += String.join(objectAccessFields, ',');

			if (childFields != null && childFields.size() > 0) {
				query += ',(' + 'SELECT ' + String.join(childFields, ',') + ' FROM Attachments )';
			}

			String userLanguage = getLanguage();

			if (String.isNotBlank(userLanguage)) {
				User currentUser = getCurrentUser();
				if (currentUser.UserType != FOR_GUEST_TYPE) {
					List<String> childTranslateFields = getAccessibleFields('X7S_News_Translation__c');

					if (childTranslateFields != null && childTranslateFields.size() > 0) {
						query += ',(' + 'SELECT ' + String.join(childTranslateFields, ',') + ' FROM X7S_News_Translation__r ';
						query += ' WHERE Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\')';
					}
				}
			}

			query += ' FROM ';
			if (strObj.contains('__c')) {
				query += getOrgNamespace();
			}
			query += strObj;

			return query;
		}
		else {
			return null;
		}
	}

	/*
	@Name		  :  getQueryString
	@Description   :  Method to generate dynamic query for objects used in process.
					  this method is generating query for TopicAssignment,Topic as per our requirement
	*/
	public static String getQueryString(String strObj) {

		List<String> objectAccessFields = getAccessibleFields(strObj);

		if (objectAccessFields != null && objectAccessFields.size() > 0) {
			String query = '';

			if (strObj == 'TopicAssignment') {
				objectAccessFields.add(String.escapeSingleQuotes('Topic.Name'));
			}

			if (strObj == 'NetworkMember') {
				objectAccessFields.add(String.escapeSingleQuotes('member.CommunityNickname'));
				objectAccessFields.add(String.escapeSingleQuotes('member.Name'));
			}

			query += 'SELECT ';
			query += String.join(objectAccessFields, ',');

			query += ' FROM ';
			query += strObj;

			return query;
		}
		else {
			return null;
		}
	}

	///////////////////////////////////////////////
	// Liking
	@AuraEnabled
	public static Boolean isLiking(String recordId) {
		return x7sNewsLikeController.isLiking(recordId);
	}

	@AuraEnabled
	public static Boolean likeNews(String recordId) {
		return x7sNewsLikeController.likeNews(recordId);
	}

	@AuraEnabled
	public static Boolean unLikeNews(String recordId) {
		return x7sNewsLikeController.unLikeNews(recordId);
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Sharing
	//
	public static Boolean useManagedSharing() {
		Boolean useSharing = false;

		try {
			X7S_News_Setting__mdt setting = [
				SELECT Use_Managed_Sharing__c
				FROM X7S_News_Setting__mdt
				WHERE DeveloperName = 'Default'
				WITH SECURITY_ENFORCED
			];

			useSharing = setting.Use_Managed_Sharing__c;
		}
		catch (Exception e) { System.debug(System.LoggingLevel.ERROR, 'X7S_News_Setting__mdt not configured for Use_Managed_Sharing');}

		return useSharing;

	}

	@TestVisible
	private static List<String> getUserGroupId() {
		List<String> idList = new List<String>();

		try {
			X7S_News_Setting__mdt setting = [SELECT UserOrGroupId__c FROM X7S_News_Setting__mdt WHERE DeveloperName = 'Default'];
			idList = setting.UserOrGroupId__c.split(NEWS_FIELD_SEPARATOR);
		}
		catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, 'X7S_News_Setting__mdt not configured for UserOrGroupId');
		}

		return idList;
	}

	private static void shareRecord(SObject shareRecord, Id userOrGroup) {
		if (shareRecord.get('OwnerId') == userOrGroup || !isRecordShareable((String) shareRecord.get('Id'))) { return;}

		String objName = shareRecord.getSObjectType().getDescribe().getName();
		Id parentId = (Id) shareRecord.get('Id');
		SObject shareObject = newSObject(objName.replace('__c', '__Share'));
		List<String> causes = getRowCause(shareObject, 'RowCause');
		String shareLevel = 'READ';

		shareObject.put('ParentId', parentId);
		shareObject.put('AccessLevel', shareLevel);
		shareObject.put('UserOrGroupId', userOrGroup);
		shareObject.put('RowCause', causes[0]);

		insert shareObject; // NOPMD - Access check handled via call to isRecordShareable
	}

	private static void unShareRecord(SObject shareRecord, Id userOrGroup) {
		if (shareRecord.get('OwnerId') == userOrGroup || !isRecordShareable((String) shareRecord.get('Id'))) { return;}

		String objName = shareRecord.getSObjectType().getDescribe().getName();
		String shareName = objName.endsWith('__c') ? objName.replace('__c', '__Share') : (objName + 'Share');
		Id parentId = (Id) shareRecord.get('Id');

		System.debug('Remove share records from ' + shareName + ' for ' + parentId);
		String query = 'SELECT Id, ParentId FROM ' + shareName + ' WHERE ParentId = \'' + parentId + '\'';
		List<SObject> shareObjects = (List<SObject>) Database.query(String.escapeSingleQuotes(query));

		if (shareObjects.size() > 0) {
			delete shareObjects; // NOPMD - Access check handled via call to isRecordShareable
		}
	}

	public class UndefinedSObjectTypeException extends Exception {
	}

	// typeName must be a valid API name (i.e. custom objects should be suffixed with "__c"):
	public static SObject newSObject(String typeName) {
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);

		if (targetType == null) {
			// calling code should usually handle this exception:
			throw new UndefinedSObjectTypeException('The requested SObject type [' + typeName + '] cannot be constructed - it is not configured in this org.');
		}

		// SObjects offer the only way in Apex to instantiate an object with a type determined at
		// runtime -- you can optionally pass an Id argument to instantiate an SObject for an existing record:
		return targetType.newSObject();
	}

	public static List<String> getRowCause(SObject targetObject, String fieldName) {
		List<String> values = new List<String>();
		Schema.SObjectType objType = targetObject.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

		Map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();

		for (Schema.PicklistEntry a : fieldMap.get(fieldName).getDescribe().getPicklistValues()) {
			values.add(a.getValue());
		}

		return values;
	}


	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Multi-language
	//
	public static Boolean useLanguage() {
		Boolean useMultiLanguage = false;

		try {
			X7S_News_Setting__mdt setting = [SELECT Enable_Multi_Language__c FROM X7S_News_Setting__mdt WHERE DeveloperName = 'Default' WITH SECURITY_ENFORCED];
			useMultiLanguage = setting.Enable_Multi_Language__c;
		}
		catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, 'X7S_News_Setting__mdt not configured for Enable_Multi_Language__c');
		}

		return useMultiLanguage;
	}

	@AuraEnabled(Cacheable=true)
	public static String getLanguage() {
		String userLanguage = '';
		User currentUser = getCurrentUser();
		try {
			if (useLanguage()) {
				if (String.isNotBlank(currentUser.LanguageLocaleKey)) {
					userLanguage = currentUser.LanguageLocaleKey;
					System.debug('***currentUser Name:' + currentUser.Name + '  ' + userLanguage);
				}
			}
		}
		catch (Exception e) { System.debug(System.LoggingLevel.ERROR, 'User local language not configured for translation');}

		return userLanguage;
	}

	@AuraEnabled(Cacheable=true)
	public static Map<String, String> getLanguageOption() {

		Map<String, String> languageOpts = new Map<String, String>();
		try {
			Schema.DescribeFieldResult fieldResult = X7S_News__c.language__c.getDescribe();
			List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

			for (Schema.PicklistEntry picklistEntry : picklistEntries) {
				languageOpts.put(picklistEntry.getLabel(), picklistEntry.getValue());
			}
			return languageOpts;
		}
		catch (Exception ex) { System.debug('Error Message:' + ex.getMessage() + ', Error Line:' + ex.getLineNumber());return null;}
	}


	//////////////////////////////////////////////////////////////////////////////////////////////////
	// Audience Personalization
	//

	final static ConnectApi.PublishStatus CONNECT_API_PUBLISH_STATUS_DRAFT = ConnectApi.PublishStatus.Draft;
	final static ConnectApi.PublishStatus CONNECT_API_PUBLISH_STATUS_LIVE = ConnectApi.PublishStatus.Live;
	final static String DEFAULT_PUBLISH_STATUS = 'Draft';
	final static String AUDIENCE_DEFAULT = 'Default';
	final static Integer AUDIENCE_QUERY_LIMIT = 200;

	/**
	 * Check CMT record for audience checkbox
	 *
	 * @return Audience enabled status - true or false
	 */
	@AuraEnabled(Cacheable=true)
	public static Boolean audienceEnabled() {
		Boolean enabled = false;
		try {
			X7S_News_Setting__mdt setting = [SELECT Enable_Audience_Targeting__c FROM X7S_News_Setting__mdt WHERE DeveloperName = 'Default' WITH SECURITY_ENFORCED LIMIT 1];
			enabled = setting.Enable_Audience_Targeting__c;
		}
		catch (Exception ex) { System.debug('CMT audienceEnabled exception: ' + ex.getMessage());}

		return enabled;
	}

	/**
	 * Get all defined audiences for the community
	 *
	 * @param networkId Community Id
	 * @param searchString search by name
	 *
	 * @return Map of audience Ids and Names
	 */
	@AuraEnabled(Cacheable=true)
	public static Map<String, String> getAudienceList(String networkId, String searchString) {
		System.debug('getAudienceList: ' + networkId);
		Map<String, String> audienceList = new Map<String, String>();

		String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
		if (String.isBlank(communityId)) {
			if (Test.isRunningTest()) { communityId = x7sNewsUtilityTest.strNetworkId;} else { return audienceList;}
		}

		communityId = communityId.substring(0, 15);

		String query = 'SELECT Id, AudienceName, ContainerId, DeveloperName FROM Audience WHERE ContainerId = :communityId ';
		if (String.isNotBlank(searchString)) { query += ' AND AudienceName LIKE \'%' + String.escapeSingleQuotes(searchString) + '%\'';}
		query += ' ORDER BY AudienceName LIMIT :AUDIENCE_QUERY_LIMIT';

		List<Audience> audiences = Database.query(string.escapeSingleQuotes(query));

		for (Audience audience : audiences) {
			System.debug('    adding: ' + audience.AudienceName + '\t[' + audience.Id + ']');
			if (audience.AudienceName != AUDIENCE_DEFAULT) { audienceList.put(audience.Id, audience.AudienceName);}
		}

		System.debug('getAudienceList: ' + audienceList);

		return audienceList;
	}

	/**
	 * Assign the item to an audience
	 *
	 * @param audienceId Selected Audience is
	 * @param recordId record Id
	 * @param networkId Community ID
	 *  NOTE: networkId must be provided as the future method does not have access to NetWork
	 */
	@Future
	public static void assignAudienceToRecord(String audienceId, String recordId, String networkId) {
		System.debug('assignAudienceToRecord - AudienceId: ' + audienceId + ', recordId: ' + recordId + ', networkId: ' + networkId);

		ConnectApi.TargetCollectionInput inputCollection = new ConnectApi.TargetCollectionInput();
		List<ConnectApi.TargetInput> targetInputList = new List<ConnectApi.TargetInput>();
		ConnectApi.TargetInput targetInput = new ConnectApi.TargetInput();

		targetInput.audienceId = audienceId.substring(0, 15);
		targetInput.groupName = TOKEN_GROUP_NAME;
		targetInput.publishStatus = CONNECT_API_PUBLISH_STATUS_LIVE;
		targetInput.targetType = TOKEN_SOBJECT_NAME;
		targetInput.targetValue = recordId.substring(0, 15);

		targetInputList.add(targetInput);

		inputCollection.targets = targetInputList;
		System.debug('input' + inputCollection);

		// Add as LIVE
		ConnectApi.TargetCollection targetOutput = ConnectApi.Personalization.createTargets(networkId.substring(0, 15), inputCollection);

		// Add as Draft
		for (ConnectApi.TargetInput input : inputCollection.targets) { input.publishStatus = CONNECT_API_PUBLISH_STATUS_DRAFT;}

		targetOutput = ConnectApi.Personalization.createTargets(networkId.substring(0, 15), inputCollection);

		System.debug('assignAudienceToRecord' + targetOutput);
	}

	/**
	 * Remove the item from the audience
	 * *
	 *
	 * @param recordId record Id
	 */
	@AuraEnabled
	public static void deleteCurrentAudience(String recordId) {
		deleteAudienceRecord(System.Network.getNetworkId(), recordId);
	}

	/**
	 * Remove the item from the audience
	 *
	 * @param networkId Community Id
	 * @param recordId record Id
	 * NOTE: networkId must be provided as the future method do not have access to NetWork
	 */
	@Future
	public static void deleteAudienceRecord(String networkId, String recordId) {
		if (String.isNotBlank(recordId)) {
			String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
			if (String.isBlank(communityId)) {
				if (Test.isRunningTest()) { communityId = x7sNewsUtilityTest.strNetworkId;}
				else { return;}
			}
			List<String> targets = getTargetsForRecordId(communityId, recordId);

			if (targets.size() > 0) {
				System.debug('Found targets to delete: ' + targets);
				for (String target : targets) {
					System.debug('    Deleting : ' + target);
					ConnectApi.Personalization.deleteTarget(communityId.substring(0, 15), target.substring(0, 15));
				}
			}
		}
	}

	public static List<String> getAudienceTargetIds(String networkId) {
		List<String> targetIds = new List<String>();
		List<String> targetTypes = new List<String>{TOKEN_SOBJECT_NAME};
		List<String> groupTypes = new List<String>{TOKEN_GROUP_NAME};
		Boolean includeAudience = true;
		Boolean includeInGroups = true;

		String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
		if (String.isBlank(communityId)) {
			if (Test.isRunningTest()) { communityId = x7sNewsUtilityTest.strNetworkId;}
			else { return targetIds;}
		}

		System.debug('getAudienceTargetIds - networkId: ' + communityId);
		ConnectApi.TargetCollection targetCollection = ConnectApi.Personalization.getTargets(communityId.substring(0, 15), null, null, null, CONNECT_API_PUBLISH_STATUS_DRAFT, null, targetTypes, includeAudience, includeInGroups, groupTypes);

		System.debug('targetCollection: ' + targetCollection);
		System.debug('targets: ' + targetCollection.targets);

		for (ConnectAPi.Target target : targetCollection.targets) { targetIds.add(target.targetValue);}

		System.debug('targetIds: ' + targetIds);
		return targetIds;
	}

	/**
	 * Get the audience Id for the specified record
	 *
	 * @param networkId Community ID
	 * @param recordId Item record Id
	 *
	 * @return Audience id
	 */
	@AuraEnabled
	public static String getAudienceIdForRecordId(String networkId, String recordId) {
		String audienceId = '';
		ConnectApi.Target target = getTarget(networkId, recordId);

		if (target != null) { audienceId = ((ConnectApi.AudienceTarget) target.audience).id;}

		return audienceId;
	}

	public static List<String> getTargetsForRecordId(String networkId, String recordId) {
		List<String> targetIds = new List<String>();

		String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
		if (String.isBlank(communityId)) {
			if (Test.isRunningTest()) { communityId = x7sNewsUtilityTest.strNetworkId;} else { return targetIds;}
		}

		String targetRecordId = recordId.substring(0, 15);
		String targetCommunity = communityId.substring(0, 15);

		List<PersonalizationTargetInfo> targets = [SELECT Id, ContainerId, TargetValue, PublishStatus FROM PersonalizationTargetInfo WHERE ContainerId = :targetCommunity AND TargetValue = :targetRecordId WITH SECURITY_ENFORCED ORDER BY PublishStatus DESC LIMIT :AUDIENCE_QUERY_LIMIT];

		if (targets.size() > 0) {
			for (PersonalizationTargetInfo target : targets) { targetIds.add(target.Id);}
		}

		return targetIds;
	}

	private static ConnectApi.Target getTarget(String networkId, String recordId) {
		ConnectApi.Target target = null;

		String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
		String targetValue = String.isNotBlank(recordId) ? recordId.substring(0, 15) : null;

		List<PersonalizationTargetInfo> targetInfos = [
			SELECT Id, DraftRowId, ContainerId, TargetType, TargetValue, GroupName, PublishStatus
			FROM PersonalizationTargetInfo
			WHERE TargetValue = :targetValue AND ContainerId = :communityId
			WITH SECURITY_ENFORCED
		];

		if (targetInfos.size() > 0) {
			String targetId = targetInfos[0].Id;

			target = ConnectApi.Personalization.getTarget(communityId, targetId);

			System.debug('Found target for recordId :'
				+ target.id
				+ ' audience: (' + ((ConnectApi.AudienceTarget) target.audience).id + ') '
				+ ((ConnectApi.AudienceTarget) target.audience).audienceName);
		}

		return target;
	}
}