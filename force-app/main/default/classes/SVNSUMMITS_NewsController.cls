/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name		  : SVNSUMMITS_NewsController
@Created by		  :
@Description		 : Apex class used by News lightning components
*/
global with sharing class SVNSUMMITS_NewsController {

	public static final String  STR_SEARCH_TERM      = 'Search Term';
	public static final String  STR_NONE             = 'None';
	public static final String  STR_TOPIC_VALUE      = 'Topic Value';
	public static final String  FOR_GROUP_ID         = 'Group';
	public static final Integer USER_SEARCH_LIMIT    = 50;

	private static final String NEWS_FIELD_SEPARATOR = ',';

	//We need to use both networkId and strNetworkId to handle 15 digit and 18 digit id in news records as per CLF-210
	//
	//networkId of type id returns 18 digit id
	global static Id networkId = System.Network.getNetworkId();
	//networkId of type string i.e. strNetworkId returns 15 digit id
	global static String strNetworkId = System.Network.getNetworkId();

	global static String TOKEN_SOBJECT_NAME = 'News__c';

	//showNickName of type string. i.e it will get value from design attribute
	private static String strShowNickName;

	// CUSTOM METADATA SETTINGS
	@AuraEnabled
	global static Boolean userAuthorizedToPost() {
		Boolean authorized = false;
		try {
			SS_News_Settings__mdt setting = [
					SELECT PermissionSetName__c
					FROM SS_News_Settings__mdt
					WHERE DeveloperName = 'Default'
			];

			System.debug('userAuthorizedToPost name = ' + setting.PermissionSetName__c);
			authorized = [
					SELECT COUNT()
					FROM PermissionSetAssignment
					WHERE AssigneeId = :UserInfo.getUserId()
					AND PermissionSet.Name = :setting.PermissionSetName__c
			] > 0;
		} catch (Exception e) {
			System.debug(System.LoggingLevel.ERROR, 'SS_News_Settings__mdt not configured');
		}

		return authorized;
	}

	@AuraEnabled
	global static Boolean requireGroupMembership() {
		Boolean requireMembership = false;

		try
		{
			SS_News_Settings__mdt setting =
			[
				SELECT Require_Group_Membership__c
				FROM SS_News_Settings__mdt
				WHERE DeveloperName = 'Default'
			];

			requireMembership = setting.Require_Group_Membership__c;
		}
		catch(Exception e)
		{
			System.debug(System.LoggingLevel.ERROR, 'SS_News_Settings__mdt not configured');
		}

		return requireMembership;
	}

	// CURRENT USER
	@AuraEnabled
	global static User getCurrentUser() {
		return [SELECT Id, Name, CommunityNickname FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
	}

	// LEX Mode
	@AuraEnabled
	global static Boolean getLexMode()
	{
		return networkId == null && strNetworkId == null;
	}

	 /*
		* MethodName		: getOrgNamespace
		* Description	   : Method for getting the namespace
	*/
	public static String getOrgNamespace() {
		String thisNameSpace = SVNSUMMITS_NewsBaseController.getModel().namespacePrefix;

		return String.isBlank(thisNameSpace) ? '' : thisNameSpace + '__';
	}

	// FOLLOWING
	@AuraEnabled
	global static Boolean isFollowing(String recordId) {
		return [
			SELECT COUNT()
			FROM EntitySubscription
			WHERE NetworkId = :System.Network.getNetworkId()
			AND ParentId = :recordId
			AND SubscriberId = :UserInfo.getUserId() LIMIT 1000
		] > 0;
	}

	@AuraEnabled
	global static Boolean followRecord(String recordId) {
		try {
			ConnectApi.ChatterUsers.follow(System.Network.getNetworkId(), UserInfo.getUserId(), recordId);
			return true;
		} catch (Exception e) {
			System.debug(e);
		}
		return false;
	}

	@AuraEnabled
	global static Boolean unfollowRecord(String recordId) {
		try {
			for (EntitySubscription follow : [SELECT Id FROM EntitySubscription WHERE NetworkId = :System.Network.getNetworkId() AND ParentId = :recordId AND SubscriberId = :UserInfo.getUserId()]) {
				ConnectApi.Chatter.deleteSubscription(System.Network.getNetworkId(), follow.Id);
				return true;
			}
		} catch (Exception e) {
			System.debug(e);
		}
		return false;
	}

	/*
	@Name		  :  isNicknameDisplayEnabled
	@Description   :  Method to fetch community setting for nick name to display users name or name as per setting.
	*/
	@AuraEnabled
	global static Boolean isNicknameDisplayEnabled() {

		if (!hasNicknameDisplayEnabledQueried) {
			try {
				Network currNetwork = [SELECT Id, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :networkId LIMIT 1];
				isNicknameDisplayEnabled = currNetwork.OptionsNicknameDisplayEnabled;
			} catch (Exception e) {
				isNicknameDisplayEnabled = true;
			} finally {
				hasNicknameDisplayEnabledQueried = true;
			}
		}
		return isNicknameDisplayEnabled;
	}
	@TestVisible private static Boolean hasNicknameDisplayEnabledQueried = false;
	@TestVisible private static Boolean isNicknameDisplayEnabled = true;

	// ACCESS TO OBJECT
	@AuraEnabled
	global static Boolean isObjectCreatable() {

		Boolean isCreateEnabled = false;
		if (Schema.SObjectType.News__c.isCreateable()) {
			isCreateEnabled = true;
		}
		return isCreateEnabled;
	}

	@AuraEnabled
	global static Boolean isObjectEditable() {

		Boolean isEditEnabled = false;
		if (Schema.SObjectType.News__c.isUpdateable()) {
			isEditEnabled = true;
		}
		return isEditEnabled ;
	}

	@AuraEnabled
	global static Boolean isRecordEditable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasEditAccess;
		} catch (Exception e) {
			return false;
		}
	}

	@AuraEnabled
	global static Boolean isRecordDeletable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasDeleteAccess;
		} catch (Exception e) {
			return false;
		}
	}

	@AuraEnabled
	global static Boolean deleteRecord(String recordId) {
		try {
			UserRecordAccess access = getUserRecordAccess(UserInfo.getUserId(), recordId);
			if (access.HasDeleteAccess) {
				System.debug('deleting record ' + recordId);
				delete new News__c(Id = recordId);
				return true;
			}
			else
			{
				System.debug('No delete access');
			}
		} catch (Exception e) {
			System.debug(e);
		}

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
		];
	}

	@AuraEnabled
	global static Boolean getNewsFeedEnabled() {
		return Schema.SObjectType.News__c.isFeedEnabled();
	}

	// GET NEWS
	/*
	@Name		  :  getNews
	@Description   :  Method to News Records as per different criteria in different components
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getNews(
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
		String toDate)
	{
		Datetime fromDt;
		Datetime toDt;
		String networkClause, topicNetworkClause;

		try {
			//create datetime instance of fromDate and toDate as we get them in string format
			if (String.isNotBlank(fromDate) || String.isNotBlank(toDate)) {

				if (String.isNotBlank(fromDate) && fromDate.length() > 0) {
					List<String> lstOfFromDt = fromDate.split('-');

					//Parsing date by splitting string because expected format is mm/dd/yyyy but we are getting string in yy/mm/dd
					fromDt = Datetime.parse(lstOfFromDt[1] + '/' + lstOfFromDt[2] + '/' + lstOfFromDt[0] + ' 12:00 AM');
				}

				if (String.isNotBlank(toDate) && toDate.length() > 0) {
					List<String> lstOfToDt = toDate.split('-');

					//Parsing date by splitting string because expected format is mm/dd/yyyy but we are getting string in yy/mm/dd
					toDt = Datetime.parse(lstOfToDt[1] + '/' + lstOfToDt[2] + '/' + lstOfToDt[0] + ' 11:59 PM');
				}
			}
		} catch (Exception e) {
			//return e.getMessage();
			//return null;
			return new SVNSUMMITS_WrapperNews('Date', e.getMessage());
		}

		try {
			// note this variable is also declared in the Wrapper
			// as we pass the QUERY string to the wrapper
			// not needed here but makes the code more readable
			Datetime rightNow = Datetime.now();

			Integer  intLimit = Integer.valueOf(numberOfNewsPerPage);
			String   recId    = validateId(strRecordId);

			// Group membership
			Boolean requireGroupId = requireGroupMembership();

			//set of topicIds ,authorIds and newsIds for filter criteria
			Set<String> topicIds = new Set<String>();
			Set<String> newsIds = new Set<String>();
			Set<String> authorIds = new Set<String>();

			//collect news id related to similar topics
			if (filterOn != STR_SEARCH_TERM && String.isNotBlank(strRecordId)) {
				System.debug('Search term: ' + STR_SEARCH_TERM + ' ' + String.valueOf(strRecordId));

				if (String.isNotBlank(recId)) {
					String queryTopicAssignment = getQueryString('TopicAssignment');

					if (String.isNotBlank(queryTopicAssignment)) {
						queryTopicAssignment += ' WHERE EntityId = \'' + String.valueOf(strRecordId) + '\'';

						topicNetworkClause = getNetworkClause('NetworkId', networkId, networkIds);

						if (String.isNotBlank(topicNetworkClause))
						{
							queryTopicAssignment += ' AND ' + topicNetworkClause;
						}

						queryTopicAssignment += ' LIMIT 1000';
						List<TopicAssignment> topicAssignments = Database.query(queryTopicAssignment);

						//collect all topics related to News__c object
						for (TopicAssignment topicAssignment : topicAssignments) {
							topicIds.add(topicAssignment.TopicId);
						}

						//collect all news Ids related to topicIds above
						String queryTopicSubAssignment = getQueryString('TopicAssignment');
						queryTopicSubAssignment += ' WHERE TopicId IN : topicIds';
						//queryTopicAssignment += String.isNotBlank(networkId) ? ' AND NetworkId = \'' + networkId + '\'' : ' AND NetworkId = null';
						//queryTopicAssignment += ' AND NetworkId = \'' + networkId + '\'';
						queryTopicSubAssignment += String.isNotBlank(networkId) ? ' AND NetworkId = \'' + networkId + '\'' : '';

						queryTopicSubAssignment += ' LIMIT 1000';
						List<TopicAssignment> topics = Database.query(queryTopicSubAssignment);

						for (TopicAssignment topicAssignment : topics) {
							newsIds.add(topicAssignment.EntityId);
						}
					}
				}
			}

			//fetch Query string for News__c (news) with child query attachment and user required fields
			String Query = getSobjectQueryString('News__c');

			if (String.isNotBlank(Query)) {

				if (getNewsFeedEnabled()) {
//					query += ' (SELECT COUNT() FROM FeedItems), (SELECT COUNT() FROM FeedComments)';
				}

				// get recommended news records
				if (filterOn == STR_NONE && String.isNotBlank(strRecordId) && String.isNotBlank(recId)) {

					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);
					if (String.isNotBlank(networkClause)) {
						Query += ' WHERE ' + networkClause;
					}

					if (String.isNotBlank(searchTerm)) {
						Query += String.isBlank(networkId) ? ' WHERE' : ' AND ';
						Query += ' Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}

					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';
					Query += ' AND Id IN : newsIds';
					Query += ' AND Id != \'' + strRecordId + '\'';
					Query += ' ORDER BY Publish_DateTime__c DESC ';
					Query += ' LIMIT : intLimit';

				}
				//get news records on search page as per searchterm entered with sort by filter selected by user
				else if (filterOn == STR_SEARCH_TERM && String.isNotBlank(searchTerm)) {
					System.debug('get news records on search page as per search term entered with sort by filter selected by user');

					if (String.isNotBlank(searchTerm) && searchTerm.trim().length() > 0) {
						searchTerm = String.escapeSingleQuotes(searchTerm.trim());
					}

					Query += ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';

					networkClause = getNetworkClause('NetworkId__c',networkId, networkIds);
					if (String.isNotBlank(networkClause)) {
						Query += ' AND ' + networkClause;
					}

					if (sortBy == 'Oldest First') {
						Query += ' ORDER BY Publish_DateTime__c';
					}

					if (sortBy == 'Most Recent') {
						Query += ' ORDER BY Publish_DateTime__c DESC';
					}
				}
				//get news records on Topic detail as per topicName selected by user
				else if (String.isNotBlank(topicName) && filterOn == STR_TOPIC_VALUE) {
					System.debug('Searching by topic: ' + topicName);

					newsIds = new Set<String>();

					if (Schema.getGlobalDescribe().get('Topic').getDescribe().accessible) {
						Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get('Topic').getDescribe().fields.getMap();

						if (strFldNameToFldDesc.get('Name').getDescribe().isAccessible()) {
							String queryStrTopic = getQueryString('TopicAssignment');

							if (String.isNotBlank(queryStrTopic)) {

								// hack for Topic names with spaces that are replaced with a '-' in the URL
								String subTopicQuery;

								// check if ID is passed as the parameter
								if (topicName instanceof Id)
								{
									subTopicQuery = ' WHERE Topic.Id = \'' + topicName + '\'';
								}
								else
								{
									if (topicName.indexOf('-') != -1)
									{
										subTopicQuery = ' WHERE Topic.Name LIKE \'%' + topicName.replace('-', '%') + '%\'';
									}
									else
									{
										subTopicQuery = ' WHERE Topic.Name = \'' + topicName + '\'';
									}
								}
								queryStrTopic += subTopicQuery;

								topicNetworkClause = getNetworkClause('NetworkId', networkId, networkIds);

								if (String.isNotBlank(topicNetworkClause))
								{
									queryStrTopic += ' AND ' + topicNetworkClause;
								}
								queryStrTopic += ' LIMIT 500';

								System.debug('Topic query: ' + queryStrTopic);

								List<TopicAssignment> topicsLst = Database.query(queryStrTopic);

								for (TopicAssignment topic : topicsLst) {
									newsIds.add(topic.EntityId);
								}

								System.debug('News IDs filtered by topic list: ' + newsIds);
							}
						}
					}

					Query += ' Where Id IN : newsIds';

					if (String.isNotBlank(searchTerm)) {
						Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}

					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';

					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);

					if (String.isNotBlank(networkClause))
					{
						Query += ' AND ' + networkClause;
					}

					if (sortBy == 'Oldest First') {
						Query += ' ORDER BY Publish_DateTime__c';
					}

					if (sortBy == 'Most Recent') {

						Query += ' ORDER BY Publish_DateTime__c DESC';
					}
				}
				// filter by group id (stored in topicName for now)
				else if (filterOn == FOR_GROUP_ID) {
					Query += ' WHERE GroupId__c  = \'' + topicName + '\'';
					System.debug('Query for Groups : ' + Query);
				}
				//get news records on List View as per combination of Topic, date, Author and sort by
				else if (String.isNotBlank(filterByTopic) ||
						String.isNotBlank(filterByAuthor) ||
						fromDt != null ||
						toDt != null ||
						String.isNotBlank(sortBy)) {

					Query += ' WHERE (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';

					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);

					if (String.isNotBlank(networkClause))
					{
						Query += ' AND ' + networkClause;
					}

					if (String.isNotBlank(searchTerm)) {
						Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}

		// PRIVATE GROUPS ---------------------------------------------------------------------------------
					// Hide Private items
					// re-purposed newsId for the group id's that the user is a member of
					// the 2 will never be used together in the same query
					// not great but it is difficult to add to the packaged WrapperNews parameters
					if (requireGroupId)
					{
						newsIds = getGroups().keySet();

						System.debug('My group list: ' + newsIds);

						Query += newsIds.size() > 0 ? ' AND (GroupId__c = null OR GroupId__c IN : newsIds)' : ' AND GroupId__c = null';
					}
					else
					{
						Query += ' AND Private_Group__c = false';
					}

					if (String.isNotBlank(filterByTopic) && filterByTopic.trim().length() > 0) {
						System.debug('Filter by topic: ' + filterByTopic);
						Set<String> topicLst = new Set<String>();
						topicLst.addAll(filterByTopic.split(';'));

						Boolean fieldIsId = false;

						for(String topicNameEntry: topicLst) {
							if (topicNameEntry instanceof Id) {
								fieldIsId = true;
							}
							else {
								if (topicNameEntry.indexOf('-') != -1) {
									topicLst.add(topicNameEntry.replace('-', ' '));
								}
							}
						}
						System.debug('Topic list: ' + topicLst);

						List<String> topicIdList = new List<String>();
						String targetName = fieldIsId ? 'Id' : 'name';
						String topicIdQuery = 'SELECT Id, Name FROM Topic WHERE ' +  targetName + ' IN : topicLst';
						List<Topic> topics = Database.query(topicIdQuery);
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
						authorIds.addAll(filterByAuthor.split(';'));

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
					} else {
						Query += ' AND Publish_DateTime__c <= :rightNow ' ;
					}

					if (String.isNotBlank(sortBy)) {
						if (sortBy == 'Oldest First') {
							intLimit = Integer.valueOf(numberOfNewsPerPage);

							Query += ' ORDER BY Publish_DateTime__c';
						}

						if (sortBy == 'Most Recent') {
							intLimit = Integer.valueOf(numberOfNewsPerPage);

							Query += ' ORDER BY Publish_DateTime__c DESC';
						}
					}

				}
				//when no criteria is selected without sort by as well
				else {
					networkClause = getNetworkClause('NetworkId__c', networkId, networkIds);

					if (String.isNotBlank(networkClause))
					{
						Query += ' WHERE ' + networkClause;
					}

					if (String.isNotBlank(searchTerm)) {
						Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}
					Query += ' AND Publish_DateTime__c <= :rightNow ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > :rightNow )';
					Query += ' ORDER BY Publish_DateTime__c DESC';
				}

				//calling wrapper class to execute query and set controller parameters
				return new SVNSUMMITS_WrapperNews(Query, intLimit, newsIds, authorIds, fromDt, toDt, false, null);
			} else {
				return null;
			}
		} catch (Exception e) {
			return new SVNSUMMITS_WrapperNews('others', e.getMessage());
		}
	}

	@TestVisible
	private static String getNetworkClause(String targetField, String networkId, String networkIds)
	{
		String networkClause = '';

		if (String.isNotBlank(networkId))
		{
			networkClause = targetField + ' = \'' + networkId + '\'';
		}
		else if (String.isNotBlank(networkIds))
		{
			List<String> idList = new List<String>();
			for (String idItem : networkIds.split(NEWS_FIELD_SEPARATOR))
			{
				idList.add(targetField + ' = \'' + idItem + '\'');
			}

			networkClause = String.join(idList, ' OR ');
		}
		else
		{
			networkClause = targetField + ' = null';
		}

		return ' ' + networkClause;
	}

	/*
	@Name		  :  nextPage
	@Description   :  Method used on click of "Next" in pagination to display news records as per numberOfNewsPerPage
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews nextPage(
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
		String toDate) {

		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		SVNSUMMITS_WrapperNews nlw = getNews(
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
			toDate);

		nlw.pageNumber = pageNumberValue;
		nlw.nextPage();

		return nlw;
	}

	/*
	@Name		  :  previousPage
	@Description   :  Method used on click of "Previous" in pagination to diaplay news records as per numberOfNewsPerPage
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews previousPage(
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
		String toDate) {

		//Integer listSizeValue = numberOfNewsPerPage != null ? Integer.valueOf(numberOfNewsPerPage) : 50;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		SVNSUMMITS_WrapperNews nlw = getNews(
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
			toDate);

		nlw.pageNumber = pageNumberValue;
		nlw.previousPage();

		return nlw ;
	}

	/*
	@Name		  :  getTopics
	@Description   :  Method to fetch topics and display in dropdown of "Topic Filter" component.
	*/
	@AuraEnabled
	global static Map<String, String> getTopics() {

		Map<String, String> topics = new Map<String, String>();
		List<Topic> topicList = new List<Topic>();

		String queryTopic = getQueryString('Topic');
		if (String.isNotBlank(queryTopic)) {
			if (String.isNotBlank(networkId)) {
				queryTopic += ' Where (NetworkId = \'' + networkId + '\'';
				queryTopic += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryTopic += ' WHERE NetworkId = null';
			}
			queryTopic += ' LIMIT 1000';
			topicList = Database.query(queryTopic);

			for (Topic t : topicList) {
				topics.put(t.Id, t.Name);
			}

			return topics;
		} else {
			return null;
		}
	}

	/*
	@Name		   : getGroups
	@Description	: Get a list of all the groups this user is a member of
	 */
	@AuraEnabled
	global static Map<String, String> getGroups() {
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

	/*
	@Name		   : getAllGroups
	@Description	: Get a list of all the groups
	 */
	@AuraEnabled
	global static Map<String, String> getAllGroups() {
		Map<String, String> groups = new Map<String, String>();

		for (CollaborationGroupMember member : [
				SELECT Id, CollaborationGroupId, CollaborationGroup.Name
				FROM CollaborationGroupMember WHERE NetworkId = :networkId
				LIMIT 1000
		]) {
			groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
		}

		return groups;
	}

	/*
	@Name		  :  getUsers
	@Description   :  Method to fetch users and display in dropdown of "Author Filter" component.
	*/
	@AuraEnabled
	global static Map<String, String> getUsers() {

		Map<String, String> users = new Map<String, String>();
		String queryUser = getQueryString('NetworkMember') + ' n';

		if (String.isNotBlank(queryUser)) {
			if (String.isNotBlank(networkId)) {
				queryUser += ' WHERE (NetworkId = \'' + networkId + '\'';
				queryUser += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryUser += ' WHERE NetworkId = null';
			}
			queryUser += ' AND n.Member.IsActive = true';
			queryUser += ' LIMIT ' + USER_SEARCH_LIMIT;

			System.debug(LoggingLevel.DEBUG, 'getUsers QRY: ' + queryUser);
			List<NetworkMember> userLst = Database.query(queryUser);


			for (NetworkMember u : userLst) {
				if (isNicknameDisplayEnabled()) {
					users.put(u.MemberId, u.Member.CommunityNickname);
				} else {
					users.put(u.MemberId, u.Member.Name);
				}
			}

			// make sure we add the current user
			User currentUser = getCurrentUser();

			if (!users.containsKey(currentUser.Id)) {
				if (isNicknameDisplayEnabled()) {
					users.put(currentUser.Id, currentUser.CommunityNickname);
				} else {
					users.put(currentUser.Id, currentUser.Name);
				}
			}

			return users;
		} else {
			return null;
		}
	}

	/*
	@Name		  :  searchUsers
	@Description   :  Method to search users and display for the dropdown of "Author Filter" component.
	*/
	@AuraEnabled
	global static Map<String, String> searchUsers(String searchString) {
		Map<String, String> users = new Map<String, String>();
		String queryUser = getQueryString('NetworkMember') + ' n ';

		if (String.isNotBlank(queryUser)) {
			if (String.isNotBlank(networkId)) {
				queryUser += ' WHERE (NetworkId = \'' + networkId + '\'';
				queryUser += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryUser += ' WHERE NetworkId = null';
			}

			if (String.isNotBlank(searchString)) {
				queryUser += ' AND (n.Member.Name LIKE \'%' + String.valueOf(searchString) + '%\')';
			}

			queryUser += ' AND n.Member.IsActive = true';
			queryUser += ' LIMIT ' + USER_SEARCH_LIMIT;

			System.debug(LoggingLevel.DEBUG, 'searchUsers QRY: ' + queryUser);
			List<NetworkMember> userLst = Database.query(queryUser);

			for (NetworkMember u : userLst) {
				if (isNicknameDisplayEnabled()) {
					users.put(u.MemberId, u.Member.CommunityNickname);
				} else {
					users.put(u.MemberId, u.Member.Name);
				}
			}

			return users;
		} else {
			return null;
		}
	}

	 /*
	@Name		  :  getAuthors
	@Description   :  Method to fetch users and display in dropdown of "Author Filter" component.
	*/
	@AuraEnabled
	global static Map<String, String> getAuthors() {
		Map<String, String> authors = new Map<String, String>();

		if (Schema.SObjectType.News__c.isAccessible() && Schema.SObjectType.News__c.fields.Author__c.isAccessible()) {
			String queryNews = 'SELECT Author__c authorId, Author__r.Name authorName, Author__r.CommunityNickname authorNickname';

			queryNews += ' FROM ';
			queryNews += getOrgNamespace();
			queryNews += TOKEN_SOBJECT_NAME;

			if (String.isNotBlank(networkId)) {
				queryNews += ' Where (NetworkId__c = \'' + networkId + '\'';
				queryNews += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryNews += ' Where NetworkId__c = null';
			}

			queryNews += ' AND Author__c != null';
			queryNews += ' GROUP BY Author__c, Author__r.Name, Author__r.CommunityNickname';
			queryNews += ' LIMIT ' + USER_SEARCH_LIMIT;

			System.debug(queryNews);
			List<AggregateResult> newsLst = Database.query(queryNews);

			for (AggregateResult n : newsLst) {
				if (isNicknameDisplayEnabled()) {
					authors.put(String.valueOf(n.get('authorId')), String.valueOf(n.get('authorNickname')));
				} else {
					authors.put(String.valueOf(n.get('authorId')), String.valueOf(n.get('authorName')));
				}
			}

			return authors;
		} else {
			return null;
		}

	}
	/*
	@Name		  :  getSitePrefix
	@Description   :  Method to fetch site prefix so that urls are redirected properly dynamically in any org.
	*/
	@AuraEnabled
	global static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	/*
	@Name		  :  getFeaturedNews
	@Description   :  Method to fetch featured news records to show on featured components.
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getFeaturedNews(String recordId1, String recordId2, String recordId3, String recordId4, String recordId5) {
		Boolean isFeatured = true;
		Map<String, String> featurdNewsIds = new Map<String, String>();
		Set<String> newsIds = new Set<String>();

		if (String.isNotBlank(recordId1)) {
			String newsRecordId1 = validateId(recordId1);
			if (String.isNotBlank(newsRecordId1)) {
				featurdNewsIds.put(newsRecordId1, newsRecordId1);
			}
		}
		if (String.isNotBlank(recordId2)) {
			String newsRecordId2 = validateId(recordId2);
			if (String.isNotBlank(newsRecordId2)) {
				featurdNewsIds.put(newsRecordId2, newsRecordId2);
			}
		}
		if (String.isNotBlank(recordId3)) {
			String newsRecordId3 = validateId(recordId3);
			if (String.isNotBlank(newsRecordId3)) {
				featurdNewsIds.put(newsRecordId3, newsRecordId3);
			}
		}
		if (String.isNotBlank(recordId4)) {
			String newsRecordId4 = validateId(recordId4);
			if (String.isNotBlank(newsRecordId4)) {
				featurdNewsIds.put(newsRecordId4, newsRecordId4);
			}
		}
		if (String.isNotBlank(recordId5)) {
			String newsRecordId5 = validateId(recordId5);
			if (String.isNotBlank(newsRecordId5)) {
				featurdNewsIds.put(newsRecordId5, newsRecordId5);
			}
		}

		newsIds = featurdNewsIds.keySet();

		String Query = getSobjectQueryString('News__c');

		if (String.isNotBlank(Query)) {
			Query += ' Where Id IN : newsIds';
			if (String.isNotBlank(networkId)) {
				Query += ' AND (NetworkId__c = \'' + networkId + '\'';
				Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				Query += ' AND NetworkId__c = null';
			}
			Query += ' LIMIT 5';

			return new SVNSUMMITS_WrapperNews(Query, 5, newsIds, null, null, null, isFeatured, featurdNewsIds);
		} else {
			return null;
		}
	}

	static public String validateId(String idParam) {
		try {
			String recId = String.escapeSingleQuotes(idParam);
			if (Id.valueOf(recId).getSobjectType() == News__c.SObjectType){return recId;} else {return null;}
		} catch (Exception e) {
			return null;
		}
	}

	/*
	@Name		  :  getNewsRecord
	@Description   :  Method to fetch news record as per newsRecordId used on news detail page components
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getNewsRecord(String newsRecordId) {
		String Query = getSobjectQueryString('News__c');

		if (String.isNotBlank(Query)) {
			Query += ' Where Id = \'' + newsRecordId + '\'';
			if (String.isNotBlank(networkId)) {
				Query += ' AND (NetworkId__c = \'' + networkId + '\'';
				Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				Query += ' AND NetworkId__c = null';
			}
			Query += ' LIMIT 1';

			return new SVNSUMMITS_WrapperNews(Query, 1, null, null, null, null, false, null);
		} else {
			return null;
		}
	}

	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getNewsRecord(String newsRecordId, String showNickName) {
		strShowNickName = showNickName;
		System.debug('---- strShowNickName ----' + strShowNickName);
		return getNewsRecord(newsRecordId);
	}

	/*
		Save news item
	 */
	@AuraEnabled
	global static News__c saveNewsItem(
			String newsName,
			String newsDetails,
			Boolean newsShowAuthor,
			String newsAuthor,
			String newsPublishDate,
			String newsArchiveDate,
			String newsGroupId,
			String strFilterByTopic	) {

		Datetime publishDate;

		if (String.isNotBlank(newsPublishDate)) {
			publishDate = Datetime.valueOf(newsPublishDate);
		}

		Datetime archiveDate;

		if (String.isNotBlank(newsArchiveDate)) {
			archiveDate = Datetime.valueOf(newsArchiveDate);
		}

		News__c news = new News__c(
				Name = newsName,
				Details__c = newsDetails,
				Show_Author__c = newsShowAuthor,
				Author__c = newsAuthor,
				Publish_DateTime__c = publishDate,
				Archive_DateTime__c = archiveDate,
				GroupId__c = newsGroupId);

		return saveNews(news, strFilterByTopic);
	}

	/*
	@Name		  :  saveNews
	@Description   :  Method to save new news object used on create news component.
	*/
	@AuraEnabled
	global static News__c saveNews(News__c newsObj, String strFilterByTopic) {
		System.debug('saveNews( ' + strFilterByTopic + ')');

		String strNamespacePrefix = getOrgNamespace();

		Schema.DescribeSObjectResult soBjRes = Schema.getGlobalDescribe().get(strNamespacePrefix + 'News__c').getDescribe();

		if (soBjRes.accessible && soBjRes.createable) {
			newsObj.NetworkId__c = networkId;

			Map<String, TopicAssignment> topicMap = new Map<String, TopicAssignment>();

			if (newsObj.Id != null) {
				String queryTopicAssignment = getQueryString('TopicAssignment');

				if (String.isNotBlank(queryTopicAssignment)) {
					queryTopicAssignment += ' WHERE EntityId = \'' + newsObj.Id + '\'';
					queryTopicAssignment += ' LIMIT 1000';
					List<TopicAssignment> topicAssignments = Database.query(queryTopicAssignment);
					for (TopicAssignment tAssgn : topicAssignments) {
						topicMap.put(tAssgn.TopicId, tAssgn);
					}
				}
			}

			upsert newsObj;

			if (String.isNotBlank(strFilterByTopic) && strFilterByTopic.trim().length() > 0) {
				List<TopicAssignment> topicAssignmentLst = new List<TopicAssignment>();
				Set<String> topicLst = new Set<String>();

				topicLst.addAll(strFilterByTopic.split(';'));
				Set<String> topicSet = new Set<String>();
				List<TopicAssignment> deleteAssignments = new List<TopicAssignment>();

				if (topicMap.size() > 0) {
					for (String topicId : topicMap.keySet()) {
						for (String tId : topicLst) {
							if (tId == topicId) {

							} else {
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
				} else {
					for (String strTopicId : topicLst) {
						TopicAssignment t = new TopicAssignment();
						t.EntityId = newsObj.Id;
						t.TopicId = strTopicId;
						topicAssignmentLst.add(t);
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

			System.debug('****newsObj******' + newsObj);

			return newsObj;
		} else {
			return null;
		}
	}

	//Delete attachment where user updates attachment on news edit page
	@AuraEnabled
	global static void deleteAttachment(String newsRecordId) {
		List<Attachment> attachments = new List<Attachment>();
		attachments = [SELECT Id FROM Attachment WHERE ParentId = :newsRecordId];
		if (!attachments.isEmpty()) {
			delete attachments;
		}
	}

	//get session id to use forcetk to upload attchment
	@AuraEnabled
	global static String getSessionId() {
		return String.isEmpty(UserInfo.getSessionId()) ? '' : UserInfo.getSessionId();
	}

	/*
	@Name		  :  getAccessibleFields
	@Description   :  Method to check all fields used in query are accessible
	*/
	public static List<String> getAccessibleFields(String strObj) {

		System.debug('--- strShowNickName access field ---' + strShowNickName);

		Set<String> NewsAccessFields = new Set<String>{
				'id',
				'name',
				'publish_datetime__c',
				'Author__c',
				'archive_datetime__c',
				'details__c',
				'networkid__c',
				'show_author__c',
				'groupid__c',
				'private_group__c',
				'Like_Count__c'
		};

		Set<String> TopicAssigmtAccessFields = new Set<String>{
				'entityid',
				'topicid'
		};
		Set<String> TopicAccessFields = new Set<String>{
				'name',
				'id'
		};
		Set<String> AttachmentAccessFields = new Set<String>{
				'id',
				'name'
		};

		String strNamespacePrefix = getOrgNamespace();

		if (strObj.contains('__c')) {
			strObj = strNamespacePrefix + strObj;
		}

		if (Schema.getGlobalDescribe().get(strObj).getDescribe().accessible) {

			String strFieldName = '';

			Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get(strObj).getDescribe().fields.getMap();
			List<String> objectAccessFields = new List<String>();

			for (String fieldToCheck : strFldNameToFldDesc.keySet()) {
				if (fieldToCheck.contains('__c')) {
					strFieldName = strNamespacePrefix + fieldToCheck;
				} else {
					strFieldName = fieldToCheck;
				}

				if (strObj == strNamespacePrefix + 'News__c' && NewsAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(strFieldName);
					}
				} else if (strObj == 'TopicAssignment' && TopicAssigmtAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(fieldToCheck);
					}
				} else if (strObj == 'Topic' && TopicAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(fieldToCheck);
					}
				} else if (strObj == 'Attachment' && AttachmentAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(fieldToCheck);
					}
				} else {
					if (strFldNameToFldDesc.get(fieldToCheck).getDescribe().isAccessible()) {
						if (fieldToCheck != 'body') {
							objectAccessFields.add(fieldToCheck);
						}
					}
				}
			}

			return objectAccessFields;
		} else {
			return null;
		}
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

			if (Schema.getGlobalDescribe().get('User').getDescribe().accessible) {
				Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap();
				if (strFldNameToFldDesc.get('Name').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('Author__r.Name'));
					objectAccessFields.add(String.escapeSingleQuotes('CreatedBy.Name'));
				}
				if (strFldNameToFldDesc.get('FullPhotoUrl').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('createdBy.FullPhotoUrl'));
					objectAccessFields.add(String.escapeSingleQuotes('Author__r.FullPhotoUrl'));
				}
				if (strFldNameToFldDesc.get('SmallPhotoUrl').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('createdBy.SmallPhotoUrl'));
					objectAccessFields.add(String.escapeSingleQuotes('Author__r.SmallPhotoUrl'));
				}
				if (strFldNameToFldDesc.get('CommunityNickname').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('Author__r.CommunityNickName'));
					objectAccessFields.add(String.escapeSingleQuotes('createdBy.CommunityNickname'));
				}
			}

			query += 'SELECT ';
			query += String.join(objectAccessFields, ',');
			if (childFields != null && childFields.size() > 0) {
				query += ',(' + 'SELECT ' + String.join(childFields, ',') + ' FROM Attachments )';
			}

			query += ' FROM ';
			if (strObj.contains('__c')) {
				query += getOrgNamespace();
			}
			query += strObj;

			return query;
		} else {
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
				if (Schema.getGlobalDescribe().get('Topic').getDescribe().accessible) {
					Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get('Topic').getDescribe().fields.getMap();
					if (strFldNameToFldDesc.get('Name').getDescribe().isAccessible()) {
						objectAccessFields.add(String.escapeSingleQuotes('Topic.Name'));
					}
				}
			}

			if (strObj == 'NetworkMember') {
				objectAccessFields.add(String.escapeSingleQuotes('member.CommunityNickname'));
				objectAccessFields.add(String.escapeSingleQuotes('member.Name'));
			}

			query += 'SELECT ';
			query += String.join(objectAccessFields, ',');

			query += ' FROM ';
			if (strObj.contains('__c')) {
				query += getOrgNamespace();
			}
			query += strObj;

			return query;
		} else {
			return null;
		}
	}

	// Liking
	@AuraEnabled
	global static Boolean isLiking(String recordId) {
		return SVNSUMMITS_NewsLikeController.isLiking(recordId);
	}

	@AuraEnabled
	public static Boolean likeNews(String recordId){
		return SVNSUMMITS_NewsLikeController.likeNews(recordId);
	}

	@AuraEnabled
	public static Boolean unLikeNews(String recordId){
		return SVNSUMMITS_NewsLikeController.unLikeNews(recordId);
	}

	private static List<News_Like__c> getNewsLikeRecords(String newsRecordId, String userId){
		return SVNSUMMITS_NewsController.getNewsLikeRecords(newsRecordId, userId);
	}
}