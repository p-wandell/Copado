/* Copyright �2016-2019 7Summits Inc. All rights reserved. */

/**
* SVNSUMMITS_EventListController
* Apex class for lightning components for Events records displaying list view, featured,
* and creating Event__c and Event_RSVP__c records
**/
global with sharing class SVNSUMMITS_EventListController
{
	private static final Integer DEFAULT_LIST_SIZE  = 50;
	private static final Integer DEFAULT_PAGE_VALUE = 1;
	private static final String  SEARCH_SEPARATOR   = ';';
	private static final String  SEARCH_FIELD	    = ':';
	private static final String  FIELD_SEPARATOR    = ',';
	private static final String  EVENT_OBJECT_NAME  = 'Event__c';
	private static final Integer MAX_TOPICS         = 1000;

	// Current community ID
	private static Id    communityId = System.Network.getNetworkId();

	// Set of fields used for checking TopicAssignment fields
	private static String [] TopicAssigmtAccessFields = new String []
	{
		'EntityId',
		'TopicId'
	};

	// Set of fields used for checking access to Topic fields
	private static String [] TopicAccessFields = new String []
	{
		'Name',
		'Id'
	};

	// Set of fields used for inserting TopicAssignment fields
	private static String [] TopicAssigmtInsertFields = new String []
	{
		'EntityId',
		'TopicId'
	};

	// Set of fields used for inserting fields while creating Events
	private static String [] eventInsertFields = new String []
	{
		'NetworkId__c',
		'Start_DateTime__c',
		'End_DateTime__c',
		'All_Day_Event__c',
		'Details__c',
		'Location_Address__c',
		'Location_Name__c',
		'Ticket_Price__c',
		'Venue_Information__c',
		'Location_URL__c',
		'Payment_URL__c',
		'Event_Type__c',
		'GroupId__c'
	};

	// Set of fields used for fetching Event records
	private static String [] EventAccessFields = new String []
	{
		'Id',
		'Name',
		'All_Day_Event__c',
		'Details__c',
		'Enable_Pricing_Payment__c',
		'Enable_RSVP__c',
		'End_DateTime__c',
		'Location_Address__c',
		'Location_Name__c',
		'Location_URL__c',
		'NetworkId__c',
		'Number_of_Attendees__c',
		'Payment_URL__c',
		'Event_Type__c',
		'RSVP_Count_Threshold__c',
		'Start_DateTime__c',
		'Ticket_Price__c',
		'Venue_Information__c',
		'GroupId__c'
	};

	private static List<String> customFieldList
	{
		get;
		set;
	}

	private static String filterString
	{
		get;
		set;
	}

	// Set of fields used for checking access to Attachment records
	private static String [] AttachmentAccessFields = new String []
	{
		'Id',
		'Name'
	};

	// Set of fields used for inserting Attachment records
	private static String [] AttachmentInsertFields = new String []
	{
		'parentId',
		'Body',
		'Name',
		'ContentType'
	};

	private static String nameSpace
	{
		get
		{
			if (nameSpace == null)
			{
				String ns = getNameSpacePrefix();
				nameSpace = String.isBlank(ns) ? '' : ns + '__';
			}
			return nameSpace;
		}
	}

	@AuraEnabled
	global static String getNameSpacePrefix()
	{
		return SVNSUMMITS_EventBaseController.getModel().namespacePrefix;
	}

	@AuraEnabled
	global static String getSitePrefix()
	{
		return System.Site.getPathPrefix();
	}

	@AuraEnabled
	global static String getSessionId()
	{
		return String.isEmpty(UserInfo.getSessionId()) ? '' : UserInfo.getSessionId();
	}

	/* ---------------------------------------------------------
	 * EVENT CUSTOM METADATA SETTINGS RELATED
	 */

	@AuraEnabled
	global static Boolean userAuthorizedToPost()
	{
		Boolean userAuthorized = false;

		try
		{
			Events_Settings__mdt setting =
			[
				SELECT PermissionSetName__c
				FROM Events_Settings__mdt
				WHERE DeveloperName = 'Default'
			];

			System.debug('userAuthorizedToPost name = ' + setting.PermissionSetName__c);
			userAuthorized = [
				SELECT COUNT()
				FROM PermissionSetAssignment
				WHERE AssigneeId = :UserInfo.getUserId()
				AND PermissionSet.Name = :setting.PermissionSetName__c
			] > 0;
		}
		catch (Exception e)
		{
			System.debug(System.LoggingLevel.ERROR, 'Events_Settings__mdt not configured Permission set name');
		}

		return userAuthorized;
	}

	@AuraEnabled
	global static Boolean requireGroupMembership()
	{
		Boolean requireMembership = false;

		try
		{
			Events_Settings__mdt setting =
			[
				SELECT Require_Group_Membership__c
				FROM Events_Settings__mdt
				WHERE DeveloperName = 'Default'
			];

			requireMembership = setting.Require_Group_Membership__c;
		}
		catch(Exception e)
		{
			System.debug(System.LoggingLevel.ERROR, 'Events_Settings__mdt not configured for Require Group Membership');
		}

		return requireMembership;
	}

	@TestVisible
	private static Integer getTopicLimit()
	{
		Integer topicLimit = MAX_TOPICS;

		try
		{
			Events_Settings__mdt setting =
			[
				SELECT Topic_Limit__c
				FROM Events_Settings__mdt
				WHERE DeveloperName = 'Default'
			];

			topicLimit = Integer.valueOf(setting.Topic_Limit__c);
		}
		catch(Exception e)
		{
			System.debug(System.LoggingLevel.ERROR, 'Events_Settings__mdt not configured for Topic Limit');
		}

		return topicLimit;
	}

	/* ---------------------------------------------------------
		* MethodName	: deleteAttachment
		* param			: eventRecordId
		* Description	: Method for deleting the first attachment for a particular record when user selects another record in Edit Detail page.
	*/
	@AuraEnabled
	global static List<Attachment> deleteAttachment(String eventRecordId)
	{
		List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId = :eventRecordId];
		if (!attachments.isEmpty()) { delete attachments;}

		return attachments;
	}

	/*
		* MethodName		: isObjectCreatable
		* param			 :
		* Description	   : Method to check whether Event__c object is creatable or not.
	*/
	@AuraEnabled
	global static Boolean isObjectCreatable()
	{
		return Schema.SObjectType.Event__c.isCreateable() ? true : false;
	}

	/*
		* MethodName		: isObjectEditable
		* param			 :
		* Description	   : Method to check whether Event__c object is Updateable or not.
	*/
	@AuraEnabled
	global static Boolean isObjectEditable()
	{
		return Schema.SObjectType.Event__c.isUpdateable() ? true : false;
	}

	@AuraEnabled
	global static Boolean isRecordEditable(String eventRecordId)
	{
		List<UserRecordAccess> userRecordAccess = new List<UserRecordAccess>();

		userRecordAccess = [SELECT HasEditAccess, RecordId FROM UserRecordAccess WHERE RecordId = :eventRecordId AND UserId = :UserInfo.getUserId()];

		return (!userRecordAccess.isEmpty() && userRecordAccess[0].HasEditAccess) ? true : false;
	}

	/*
		* MethodName	: saveEvents
		* params		: eventObj, strfilterByTopic, allDayEventStartDate, allDayEventEndDate
		* Description	: Method for saving all event records for create as well ad detail page.
	*/
	@AuraEnabled
	global static Event__c saveEvents(Event__c eventObj, String strfilterByTopic, String allDayEventStartDate, String allDayEventEndDate)
	{
		//Updating  all DML to be wrapped in a Database.savepoint() in case we need to roll back due to failure of a DML
		Savepoint SP_PreEventDMLState = Database.setSavepoint();

		if (Schema.SObjectType.Event__c.isCreateable())
		{
			// Obtaining the field name/token map for the Event object
			Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.Event__c.fields.getMap();
			Map<String, Schema.SObjectField> TAFldMap = Schema.SObjectType.TopicAssignment.fields.getMap();

			for (String fieldToCheck : eventInsertFields)
			{
				String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

				// Check if the user has access to view field
				// exception Search and pass error to client
				if (!eventFldMap.get(fullFieldName).getDescribe().isCreateable()) { throw new System.NoAccessException();}
			}

			for (String fieldToCheck : TopicAssigmtInsertFields)
			{
				// Check if the user has access to view field
				//  exception Search and pass error to client
				if (!TAFldMap.get(fieldToCheck).getDescribe().isCreateable()) { throw new System.NoAccessException();}
			}

			//Set communtyId for Newly Created Event
			eventObj.NetworkId__c = communityId;

			if (eventObj.All_Day_Event__c)
			{
				Datetime dt1 = Datetime.valueOf(allDayEventStartDate + ' ' + '00:00:00');
				eventObj.Start_DateTime__c = dt1;

				if (String.isNotBlank(allDayEventEndDate) && allDayEventEndDate.contains('-'))
				{
					Datetime dt2 = Datetime.valueOf(allDayEventEndDate + ' ' + '23:59:59');
					eventObj.End_DateTime__c = dt2;

				}
				//Checking if 'allDayEventEndDate' is null
				if (allDayEventEndDate == null || String.isBlank(allDayEventEndDate))
				{
					eventObj.End_DateTime__c = null;
				}
			}
			// Insert or upsert topics for create as well as edit Event page
			// get this from events settings CMT
			Integer maxTopics      = getTopicLimit();
			String  entityTypeName = nameSpace + EVENT_OBJECT_NAME;

			Map<String, TopicAssignment> topicMap = new Map<String, TopicAssignment>();
			if (eventObj.Id != null)
			{
				List<TopicAssignment> topicAssignments = [SELECT Id, EntityId, Topic.Id, Topic.Name FROM TopicAssignment WHERE NetworkId = :communityId AND EntityId = :eventObj.Id  AND EntityType = :entityTypeName LIMIT :maxTopics];
				for (TopicAssignment tAssgn : topicAssignments) { topicMap.put(tAssgn.TopicId, tAssgn);}
			}

			try
			{
				upsert eventObj;
			}
			catch (DmlException dmlExp)
			{
				Database.rollback(SP_PreEventDMLState);
			}

			// Check for existing topics on edit page for Events such that if no change for topics on Edit
			// then will remains same else will update the topics
			if (String.isNotBlank(strfilterByTopic) && strfilterByTopic.trim().length() > 0)
			{
				List<TopicAssignment> topicAssignmentLst = new List<TopicAssignment>();
				Set<String> topicLst = new Set<String>();
				topicLst.addAll(strfilterByTopic.split(';'));

				Set<String> topicSet = new Set<String>();
				List<TopicAssignment> deleteAssignmentsLst = new List<TopicAssignment>();
				if (topicMap.size() > 0)
				{
					for (String topicId : topicMap.keySet())
					{
						for (String tId : topicLst)
						{
							if (tId != topicId && !topicSet.contains(tId))
							{
								topicSet.add(tId);
								topicAssignmentLst.add(new TopicAssignment(EntityId = eventObj.Id, TopicId = tId));
							}
						}

						if (!topicLst.contains(topicId)) { deleteAssignmentsLst.add(topicMap.get(topicId));}
					}
				}
				else
				{
					for (String strTopicId : topicLst)
					{
						TopicAssignment t = new TopicAssignment();
						t.NetworkId = communityId;
						t.EntityId = eventObj.Id;
						t.TopicId = strTopicId;
						topicAssignmentLst.add(t);
					}
				}
				try
				{
					delete deleteAssignmentsLst;
					upsert topicAssignmentLst;
				}
				catch (DmlException exp)
				{
					Database.rollback(SP_PreEventDMLState);
				}
			}

			return eventObj;
		}
		else
		{
			return null;
		}
	}

	/*
		* MethodName : saveEvents
		* param		 : fldMap, objectAccess
		* Description: Method for Checking no access exception for specific fields in the map.
	*/
	private static Boolean checkFieldType(Map<String, Schema.SObjectField> fldMap, String[] objectAccess)
	{
		for (String fieldToCheck : objectAccess)
		{
			String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

			if (!fldMap.get(fullFieldName).getDescribe().isAccessible())
			{
				System.debug(LoggingLevel.ERROR, 'Access failed for field: ' + fullFieldName);
				return false;
			}
		}
		return true;
	}

	/*
	@Name		: getGroups
	@Description: Get a list of all the groups this user is a member of
	 */
	@AuraEnabled
	global static Map<String, String> getGroups()
	{
		Map<String, String> groups = new Map<String, String>();

		for (CollaborationGroupMember member :
		[
			SELECT Id, CollaborationGroupId, CollaborationGroup.Name
			FROM CollaborationGroupMember
			WHERE MemberId = :UserInfo.getUserId() AND NetworkId = :communityId
			LIMIT 1000
		])
		{
			groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
		}

		return groups;
	}

	/*
	@Name		   : getAllGroups
	@Description	: Get a list of all the groups on the org
	 */
	@AuraEnabled
	global static Map<String, String> getAllGroups()
	{
		Map<String, String> groups = new Map<String, String>();

		for (CollaborationGroupMember member :
		[
			SELECT Id, CollaborationGroupId, CollaborationGroup.Name
			FROM CollaborationGroupMember WHERE NetworkId = :communityId
			LIMIT 1000
		])
		{
			groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
		}

		return groups;
	}

	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper getEventsList(
		Boolean compactMode,
		Integer recordSize,
		Integer listSize,
		String  strFilterType,
		String  sortBy,
		String  filterByTopic,
		String  topicName,
		String  searchTerm,
		String  filterOn,
		String  fromDate,
		String  toDate,
		String  listViewMode,
		String  customFields,
		String  filters)
	{
		customFieldList = getCustomFields(customFields);
		filterString	= filters;

		return getEvents(compactMode, recordSize, listSize, 0, strFilterType, topicName, '', sortBy, filterByTopic, topicName, false, searchTerm, filterOn, fromDate, toDate, listViewMode);
	}

	/*
	 * MethodName : getEvents
	 * param	  : eventListFlag, numberofresults, listSize, pageNumber, strfilterType
	 *				strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm,
	 *				searchTerm, filterOn, fromDate, toDate, listViewMode
	 * Description: Method to fetch all event records for list view, topic and search pages.
	 */
	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper getEvents(
		Boolean eventListFlag,
		Integer numberofresults,
		Integer listSize,
		Integer pageNumber,
		String strfilterType,
		String strRecordId,
		String networkId,
		String sortBy,
		String filterByTopic,
		String topicName,
		Boolean filterBySearchTerm,
		String searchTerm,
		String filterOn,
		String fromDate,
		String toDate,
		String listViewMode)
	{
		System.debug('calling getEvents');

		// get this from events settings CMT
		Integer maxTopics      = getTopicLimit();
		String  entityTypeName = nameSpace + EVENT_OBJECT_NAME;

		// Obtaining the field name/token map for the Event object
		Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.Event__c.fields.getMap();
		Map<String, Schema.SObjectField> topicFldMap = Schema.SObjectType.Topic.fields.getMap();
		Map<String, Schema.SObjectField> TAFldMap	 = Schema.SObjectType.TopicAssignment.fields.getMap();

		// Checking no access exception for EventAccessFields, TopicAccessFields and TopicAssigmtAccessFields
		if (!checkFieldType(eventFldMap, EventAccessFields))
		{
			System.debug('ACCESS CHECK failed for EventAccessFields');
			throw new System.NoAccessException();
		}
		if (!checkFieldType(topicFldMap, TopicAccessFields))
		{
			System.debug('ACCESS CHECK failed for TopicAccessFields');
			throw new System.NoAccessException();
		}
		if (!checkFieldType(TAFldMap, TopicAssigmtAccessFields))
		{
			System.debug('ACCESS CHECK failed for TopicAssigmtAccessFields');
			throw new System.NoAccessException();
		}

		listSize = Integer.valueOf(listSize);

		Datetime fromDt;
		Datetime toDt;

		try
		{
			//create datetime instance of fromDate and toDate as we get them in string format
			if (String.isNotBlank(fromDate) || String.isNotBlank(toDate))
			{
				if (String.isNotBlank(fromDate))
				{
					fromDt = Datetime.valueOf(fromDate + ' ' + '00:00:00');
				}
				if (String.isNotBlank(toDate))
				{
					toDt = Datetime.valueOf(toDate + ' ' + '23:59:00');
				}
			}
		}
		catch (Exception e)
		{
			return new SVNSUMMITS_EventListWrapper('Date', e.getMessage());
			System.debug('ERROR:' + e);
		}

		Integer limitInt = Integer.valueOf(numberofresults);
		Set<String> topicIds = new Set<String>();
		Set<String> groupEventIds = null;

		// this fails to yield results in very large communities
		for (TopicAssignment topicAssignment : [SELECT Id, EntityId, Topic.Id FROM TopicAssignment WHERE NetworkId = :communityId AND  EntityId = :String.valueOf(strRecordId) AND EntityType = :entityTypeName LIMIT :maxTopics])
		{
			topicIds.add(topicAssignment.Topic.Id);
		}

		Set<String> eventIds = new Set<String>();
		for (TopicAssignment topicAssignment : [SELECT Id, EntityId, Topic.Id FROM TopicAssignment WHERE NetworkId = :communityId AND Topic.Id IN :topicIds  AND EntityType = :entityTypeName LIMIT :maxTopics])
		{
			eventIds.add(topicAssignment.EntityId);
		}

		List<String> keywordSetCategoriesList = new List<String>(eventIds);
		String categoriesJoined = '(\'' + String.join(keywordSetCategoriesList, '\',\'') + '\')';

		// Group membership
		Boolean requireGroupId = requireGroupMembership();

		List<String> myEventIds = new List<String>();

		if (filterOn.startsWith('My Events'))
		{
			// IF on a profile page, the user Id is tacked on to the filterOn string
			// - filterOn == 'My Events':recordId
			// else use the current userId
			String userId = UserInfo.getUserId();

			if (filterOn.indexOf(':') > 0) { userId = filterOn.substringAfterLast(SEARCH_FIELD);}

			for(Event_RSVP__c myRsvp : [SELECT Event__c FROM Event_RSVP__c WHERE User__c = :userId]) { myEventIds.add(myRsvp.Event__c);}
		}

		/* **************************************************
		 * Main query string
		 ************************************************** */
		String Query = getSelectClause();
		Query	   += getFromClause();
//		Query	   += listViewMode == 'Calendar' ? getCalendarWhereClause(filterByTopic) : getWhereClause();
		Query	   += getWhereClause();

		//Event records fetched in case of Recommended for you and eventListFlag = false
		if (filterOn == 'None' && limitInt != null && eventListFlag == false)
		{
			Query += categoriesJoined.length() > 5 ? ' AND Id IN ' + categoriesJoined : ' ';

			if (String.isBlank(fromDate))
			{
				Query += ' AND Start_DateTime__c >= TODAY';
			}

			if (String.isNotBlank(strRecordId)) { Query += ' And Id != \'' + strRecordId + '\'';}
		}

		//Fetching event records in case of Search page - List view
		if (String.isNotBlank(searchTerm))
		{
			if (String.isNotBlank(searchTerm) && searchTerm.trim().length() > 0)
			{
				searchTerm = String.escapeSingleQuotes(searchTerm.trim());
			}

			Query += ' AND Name LIKE \'%' + searchTerm + '%\'';
		}

		//Fetch Event Records related Topic Page
		if (filterOn == 'Topic Value')
		{
			System.debug('Topic Value selected -- topic name = ' + topicName);
			String queryStrTopic = 'SELECT Id, EntityId, Topic.Id, Topic.Name FROM TopicAssignment ';

			eventIds = new Set<String>();

			// hack for Topic names with spaces that are replaced with a '-' in the URL
			queryStrTopic += topicName.indexOf('-') != -1 ? ' WHERE Topic.Name LIKE \'%' + topicName.replace('-', '%') + '%\'' : ' WHERE Topic.Name = \'' + topicName + '\'';
			queryStrTopic += ' AND EntityType = :entityTypeName';
			queryStrTopic += ' LIMIT :maxTopics';

			System.debug('Topic query: ' + queryStrTopic);

			List<TopicAssignment> topicsLst = Database.query(queryStrTopic);

			for (TopicAssignment t : topicsLst)
			{
				eventIds.add(t.EntityId);
			}

			Query += ' AND Id IN : eventIds ';
			Query += ' AND NetworkId__c = \'' + communityId + '\'';
		}

		if (filterOn == 'Group')
		{
			Query += ' AND GroupId__c  = \'' + topicName + '\'';
			System.debug('Query for Groups : ' + Query);
		}

		if (filterOn == 'LocationName' && String.isNotBlank(strfilterType))
		{
			Query += ' AND Location_Name__c  = \'' + strfilterType + '\'';
			System.debug('Query for location : ' + Query);
		}

		if (filterOn == 'Event_Type__c' && String.isNotBlank(strfilterType))
		{
			Query += ' AND Event_Type__c  = \'' + strfilterType + '\'';
			System.debug('Query for Event Type : ' + Query);
		}

		if (filterOn.startsWith('My Events'))
		{
			String myEventIdString = '(\'' + String.join(myEventIds, '\',\'') + '\')';

			Query += ' AND Id IN ' + myEventIdString;
		}

		// Filter string pattern
		//  field1:value1;field2:value2;
		System.debug('filter string: ' + filterString);
		if (String.isNotBlank(filterString))
		{
			Query += getCustomFilterClause(filterString);
		}

		if (fromDt != null || toDt != null || String.isNotBlank(filterByTopic) || String.isNotBlank(sortBy))
		{
			if (fromDt != null)
			{
				Query += ' And Start_DateTime__c >=: fromDt ';
			}
			if (toDt != null)
			{
				Query += ' And Start_DateTime__c <=:  toDt ' ;
			}

			if (String.isNotBlank(filterByTopic))
			{
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

				eventIds = new Set<String>();
				for (TopicAssignment t : [SELECT Id, EntityId, Topic.Id FROM TopicAssignment WHERE NetworkId = :communityId AND Topic.Id = :topicIdList AND EntityType = :entityTypeName LIMIT :maxTopics])
				{
					eventIds.add(t.EntityId);
				}
				Query += ' And Id IN :eventIds ';
			}
		}

		if (requireGroupId)
		{
			groupEventIds = getGroups().keySet();

			System.debug('My group list: ' + groupEventIds);

			Query += groupEventIds.size() > 0 ? ' AND (GroupId__c = null OR GroupId__c IN : groupEventIds)' : ' AND GroupId__c = null';
		}

		Query += getSortClause(sortBy);
		Query += getLimitClause(limitInt);

		System.debug('Query to EventListWrapper: ' + Query);
		return new SVNSUMMITS_EventListWrapper(Query, listSize, fromDt, toDt, eventIds, listViewMode, false, null, groupEventIds);
	}

	public static String getSelectClause()
	{
		String fields = String.join(EventAccessFields, ',');
		fields = fields.removeEnd(',');

		// Main query string
		String selectClause = 'SELECT ' + fields + ', (SELECT Id FROM Attachments)';

		if (customFieldList != null)
		{
			System.debug('Adding custom fields: ');
			for (String field : customFieldList)
			{
				System.debug('	field: ' + field);
				selectClause += ', ' + field.trim();
			}
		}

		return selectClause;
	}

	private static String getFromClause()
	{
		return ' FROM ' + EVENT_OBJECT_NAME;
	}

	public static String getCalendarWhereClause(String filterByTopic)
	{
		String query = getWhereClause();

		if (String.isNotBlank(filterByTopic))
		{
			query += ' And Id IN :eventIds';
		}

		return query;
	}

	public static String getWhereClause()
	{
		String query = ' WHERE NetworkId__c = ';
		query += String.isNotBlank(communityId) ?  '\'' + communityId + '\'' : 'null';

		return query;
	}

	public static String getSortClause(String sortBy)
	{
		System.debug('sortBy = ' + sortBy);

		String sortByClause = '';

		if (sortBy == 'Upcoming')
		{
			sortByClause += ' ORDER BY Start_DateTime__c';
		}
		// sort event records in calendar mode for Top attendees
		else if (sortBy == 'TopAttendance')
		{
			sortByClause += ' ORDER BY Number_of_Attendees__c DESC';
		}
		else
		{
			sortByClause += ' ORDER BY Start_DateTime__c';
		}

		return sortByClause;
	}

	public static String getLimitClause(Integer limitValue)
	{
		return  limitValue != null ? ' LIMIT ' + limitValue : '';
	}

	public static String getCustomFilterClause(String filterString)
	{
		System.debug('getCustomFilterClause - filter string: ' + filterString);
		String filterQuery = '';

		if (String.isNotBlank(filterString))
		{
			List<String> searchParts = filterString.split(SEARCH_SEPARATOR);

			for (Integer i = 0; i < searchParts.size(); i++)
			{
				if (searchParts[i].indexOf(SEARCH_FIELD) != -1)
				{
					String fieldName  = searchParts[i].substringBefore(SEARCH_FIELD);
					String fieldValue = searchParts[i].substringAfter(SEARCH_FIELD);

					filterQuery += ' AND '
						+ fieldName.trim()
						+ ' LIKE \'%'
						+ String.escapeSingleQuotes(fieldValue)
						+ '%\'';
				}
			}
		}

		System.debug('Custom filter query: ' + filterQuery);
		return filterQuery;
	}

	public static List<String> getCustomFields(String fieldList)
	{
		System.debug('getCustomFields : ' + fieldList);
		List<String> fieldsSet = fieldList.split(FIELD_SEPARATOR);

		// prefix the namespace
		for(Integer pos = 0; pos < fieldsSet.size(); pos++)
		{
			String fieldValue = fieldsSet.get(pos);
			fieldsSet.set(pos, nameSpace + fieldValue);
		}

		List<String> fields	= new List<String>();

		Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.Event__c.fields.getMap();

		for(String field: fieldsSet)
		{
			if (eventFldMap.containsKey(field.trim()))
			{
				fields.add(field.trim());
			}
			else
			{
				System.debug('Custom field ' + field + ' not found on the Event__C record');
			}
		}

		return fields;
	}


	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper nextPageList(
		Integer pageNumber,
		Boolean compactMode,
		Integer recordSize,
		Integer listSize,
		String  strFilterType,
		String  sortBy,
		String  filterByTopic,
		String  topicName,
		String  searchTerm,
		String  filterOn,
		String  fromDate,
		String  toDate,
		String  listViewMode,
		String  customFields,
		String  filters)
	{
		customFieldList = getCustomFields(customFields);
		filterString	= filters;

		return  nextPage(compactMode, recordSize, listSize, pageNumber, strFilterType, topicName, '', sortBy, filterByTopic, topicName, false, searchTerm, filterOn, fromDate, toDate, listViewMode);
	}
	/*
		* MethodName		: nextPage
		* param			 : eventListFlag, numberofresults, numberofresults, listSize,toDate,
							  pageNumber, strfilterType, strRecordId, networkId, sortBy,searchTerm,
							  filterByTopic, topicName, filterBySearchTerm, filterOn, fromDate, listViewMode
		* Description	   : Method to fetch all event records for next page pagination.
	*/
	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper nextPage(Boolean eventListFlag, Integer numberofresults, Integer listSize, Integer pageNumber, String strfilterType, String strRecordId, String networkId, String sortBy, String filterByTopic, String topicName, Boolean filterBySearchTerm, String searchTerm, String filterOn, String fromDate, String toDate, String listViewMode)
	{
		Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : DEFAULT_LIST_SIZE;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : DEFAULT_PAGE_VALUE;

		SVNSUMMITS_EventListWrapper ilw = getEvents(eventListFlag, numberofresults, listSizeValue, pageNumberValue, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);
		ilw.pageNumber = pageNumberValue;

		ilw.nextPage();

		return ilw;
	}

	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper previousPageList(
		Integer pageNumber,
		Boolean compactMode,
		Integer recordSize,
		Integer listSize,
		String  strFilterType,
		String  sortBy,
		String  filterByTopic,
		String  topicName,
		String  searchTerm,
		String  filterOn,
		String  fromDate,
		String  toDate,
		String  listViewMode,
		String  customFields,
		String  filters)
	{
		customFieldList = getCustomFields(customFields);
		filterString	= filters;

		return  previousPage(compactMode, recordSize, listSize, pageNumber, strFilterType, topicName, '', sortBy, filterByTopic, topicName, false, searchTerm, filterOn, fromDate, toDate, listViewMode);
	}
	/*
		* MethodName		: previousPage
		* param			 : eventListFlag, numberofresults, numberofresults, listSize,toDate,
							  pageNumber, strfilterType, strRecordId, networkId, sortBy,searchTerm,
							  filterByTopic, topicName, filterBySearchTerm, filterOn, fromDate, listViewMode
		* Description	   : Method to fetch all event records for previous page pagination.
	*/
	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper previousPage(Boolean eventListFlag, Integer numberofresults, Integer listSize, Integer pageNumber, String strfilterType, String strRecordId, String networkId, String sortBy, String filterByTopic, String topicName, Boolean filterBySearchTerm, String searchTerm, String filterOn, String fromDate, String toDate, String listViewMode)
	{
		Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : DEFAULT_LIST_SIZE;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : DEFAULT_PAGE_VALUE;

		SVNSUMMITS_EventListWrapper ilw = getEvents(eventListFlag, numberofresults, listSizeValue, pageNumberValue, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);
		ilw.pageNumber = pageNumberValue;

		ilw.previousPage();

		return ilw;
	}

	/*
		* MethodName  : getTopics
		* Description : Method to fetch all topics records.
	*/
	@AuraEnabled
	global static Map<String, String> getTopics()
	{
		Map<String, String> topics = new Map<String, String>();
		List<Topic> topicList = new List<Topic>();
		Map<String, Schema.SObjectField> topicFldMap = Schema.SObjectType.Topic.fields.getMap();

		if (communityId != null)
		{
			for (String fieldToCheck : TopicAccessFields)
			{
				// Check if the user has access to view field
				// exception Search and pass error to client
				if (!topicFldMap.get(fieldToCheck).getDescribe().isAccessible()){ throw new System.NoAccessException();}
			}
			topicList =
			[
				SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
				FROM Topic
				WHERE NetworkId = :communityId
			];
		}
		else
		{
			for (String fieldToCheck : TopicAccessFields)
			{
				// Check if the user has access to view field
				// exception Search and pass error to client
				if (!topicFldMap.get(fieldToCheck).getDescribe().isAccessible()) { throw new System.NoAccessException();}
			}

			topicList =
			[
				SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
				FROM Topic
				LIMIT 2000
			];
		}

		for (Topic t : topicList)
		{
			topics.put(t.Id, t.Name);
		}

		return topics;
	}

	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper getEventRecord(String eventRecordId, String customFields)
	{
		System.debug('New getEventRecord call with' + customFields);
		if (String.isNotBlank(customFields))
		{
			customFieldList = getCustomFields(customFields);
		}
		return getEventRecord(eventRecordId);
	}

	/*
		* MethodName		: getEventRecord
		* param			 : eventRecordId
		* Description	   : Method to fetch particular event record on call of edit page.
	*/

	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper getEventRecord(String eventRecordId)
	{
		System.debug('getting event record:');

		Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.Event__c.fields.getMap();
		Map<String, Schema.SObjectField> attFldMap = Schema.SObjectType.Attachment.fields.getMap();

		for (String fieldToCheck : EventAccessFields)
		{
			String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

			System.debug('	: ' + fullFieldName);

			// Check if the user has access to view field
			// exception Search and pass error to client
			if (!eventFldMap.get(fullFieldName).getDescribe().isAccessible()) { throw new System.NoAccessException();}
		}
		for (String fieldToCheck : AttachmentAccessFields)
		{

			// Check if the user has access to view field
			// Search and pass error to client
			if (!attFldMap.get(fieldToCheck).getDescribe().isAccessible()) { throw new System.NoAccessException();}
		}

		Set<String> eventIds = new Set<String>();

		String Query = getSelectClause();

		Query += getFromClause();
		Query += getWhereClause();
		Query += ' AND  Id = \'' + eventRecordId + '\'';

		System.debug('query = ' + Query);

		return new SVNSUMMITS_EventListWrapper(Query, 1, null, null, eventIds, null, false, null, null);
	}

	/*
		* MethodName		: getEventName
		* param			 : eventRecordId
		* Description	   : Method to fetch particular event record's Name.
	*/
	@AuraEnabled
	global static String getEventName(String eventRecordId)
	{
		String[] flds = new String[]
		{
			'Id', 'Name'
		};
		Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.Event__c.fields.getMap();

		for (String fieldToCheck : flds)
		{
			// Check if the user has access to view field
			// exception Search and pass error to client
			if (!eventFldMap.get(fieldToCheck).getDescribe().isAccessible()) { throw new System.NoAccessException();}
		}

		return [SELECT Id, Name FROM Event__c WHERE Id = :eventRecordId AND NetworkId__c = :communityId].Name;

	}

	/*
		* MethodName		: getFeaturedEvents
		* param			 : recordId1, recordId2, recordId3, recordId4, recordId5
		* Description	   : Method to fetch featured and featured 1+4 event records.
	*/
	@AuraEnabled
	global static SVNSUMMITS_EventListWrapper getFeaturedEvents(String recordId1, String recordId2, String recordId3, String recordId4, String recordId5)
	{
		Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.Event__c.fields.getMap();
		Map<String, Schema.SObjectField> attFldMap = Schema.SObjectType.Attachment.fields.getMap();

		for (String fieldToCheck : EventAccessFields)
		{
			String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

			// Check if the user has access to view field
			// exception Search and pass error to client
			if (!eventFldMap.get(fullFieldName).getDescribe().isAccessible()) { throw new System.NoAccessException();}
		}
		for (String fieldToCheck : AttachmentAccessFields)
		{

			// Check if the user has access to view field
			// exception Search and pass error to client
			if (!attFldMap.get(fieldToCheck).getDescribe().isAccessible()) { throw new System.NoAccessException();}
		}
		// fetching all five records related to featured 1+4 records
		Boolean isFeatured = true;
		Set<String> eventIds = new Set<String>();
		Map<String, String> featurdEventIds = new Map<String, String>();

		if (recordId1 != null && !String.isEmpty(recordId1))
		{
			featurdEventIds.put(recordId1, recordId1);
		}
		if (recordId2 != null && !String.isEmpty(recordId2))
		{
			featurdEventIds.put(recordId2, recordId2);
		}
		if (recordId3 != null && !String.isEmpty(recordId3))
		{
			featurdEventIds.put(recordId3, recordId3);
		}
		if (recordId4 != null && !String.isEmpty(recordId4))
		{
			featurdEventIds.put(recordId4, recordId4);
		}
		if (recordId5 != null && !String.isEmpty(recordId5))
		{
			featurdEventIds.put(recordId5, recordId5);
		}

		eventIds = featurdEventIds.keySet();

		String Query = 'Select ' + String.join(EventAccessFields, ',') + ',(select Id,Name from Attachments limit 1) FROM Event__c Where Id IN : eventIds And NetworkId__c = \'' + communityId + '\'';

		return new SVNSUMMITS_EventListWrapper(Query, 5, null, null, eventIds, null, isFeatured, featurdEventIds, null);
	}

	/*
		* MethodName		: getRSVPMemberAttendes
		* param			 : EventName
		* Description	   : Method to fetch the rsvp member status. Whether they are joining or not.
	*/
	@AuraEnabled
	global static Boolean getRSVPMemberAttendes(Id EventName)
	{
		List<Event_RSVP__c> lstEventRSVP = new List<Event_RSVP__c>([
			SELECT Id, Name, Event__c, User__c
			FROM Event_RSVP__c
			WHERE Event__c = :EventName
			AND User__c = :UserInfo.getUserId()
		]);

		return lstEventRSVP.isEmpty() ? false : true;
	}

	/*
		 * MethodName		: createRSVPevents
		 * param			 : EventName, response
		 * Description	   : Method to create Event_RSVP__c records on clicking yes on the RSVP component.
	 */
	@AuraEnabled
	global static Event_RSVP__c createRSVPevents(Id EventName, String response)
	{
		if (Schema.SObjectType.Event_RSVP__c.isCreateable())
		{
			if ([SELECT COUNT() FROM Event_RSVP__c WHERE Event__c = :EventName AND User__c = :UserInfo.getUserId()] <= 0)
			{
				Event_RSVP__c eventRSVPList = new Event_RSVP__c();
				eventRSVPList.Event__c = EventName;
				eventRSVPList.User__c = UserInfo.getUserId();
				eventRSVPList.Response__c = response;
				insert eventRSVPList;

			}
		}
		return null;
	}

	/*
		* MethodName		: deleteRSVPevents
		* param			 : EventId
		* Description	   : Method to delete Event_RSVP__c records on clicking No on RSVP component.
	*/
	@AuraEnabled
	global static Event_RSVP__c deleteRSVPevents(Id EventId)
	{
		if (EventId != null)
		{
			delete
			[
				SELECT Id
				FROM Event_RSVP__c
				WHERE User__c = :UserInfo.getUserId()
				AND Event__c = :EventId
				LIMIT 1
			];
		}
		return null;
	}

	/*
		* MethodName		: deleteRSVPevents
		* param			 : EventId
		* Description	   : Method to delete Event_RSVP__c records on clicking No on RSVP component.
	*/
	@AuraEnabled
	global static Boolean checkRSVPevents(Id EventId)
	{
		return [
			SELECT COUNT()
			FROM Event_RSVP__c
			WHERE User__c = :UserInfo.getUserId()
			AND Event__c = :EventId AND Event__r.NetworkId__c = :communityId
			LIMIT 1
		] > 0 ? true : false;
	}

	@AuraEnabled
	global static Decimal getRSVPAttendeeCount(Id eventId)
	{
		Event__c[] events = [SELECT Id, Number_of_Attendees__c FROM Event__c WHERE Id = :eventId];

		return (events.size() > 0) ? events[0].Number_of_Attendees__c : 0;
	}

	@AuraEnabled
	global static List<String> getEventsPicklist(String fieldName, String searchString)
	{
		List<String> values = new List<String>();

		Integer recordLimit = DEFAULT_LIST_SIZE;
		String fieldString = 'e.' + nameSpace + fieldName;

		String query = 'SELECT ' + fieldString;

		query += ' location,';
		query += ' COUNT_DISTINCT(e.Id)';
		query += ' FROM ';
		query += nameSpace + 'Event__c e';

		if (String.isNotBlank(searchString))
		{
			query += ' WHERE (' + fieldString + ' LIKE \'%' + searchString + '%\')';
		}

		query += ' GROUP BY ' + fieldString;
		query += ' LIMIT ' + recordLimit;

		List<AggregateResult> results = Database.query(query);

		for (AggregateResult ar : results)
		{
			String entry = (String) ar.get('location');

			if (String.isNotBlank(entry))
			{
				values.add(entry);
			}
		}

		return values;
	}

	@AuraEnabled
	global static List<String> getPicklistValues(String objName, String fieldName) {
		List<String> options = new List<String>();

		Schema.SObjectType objType = Schema.getGlobalDescribe().get(nameSpace + objName);
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

		Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		List<Schema.PicklistEntry> values = fieldMap.get(nameSpace + fieldName).getDescribe().getPicklistValues();

		for (Schema.PicklistEntry a : values) {
			options.add(a.getLabel());
		}
		return options;
	}

	@AuraEnabled
	global static List<String> getEventPickList(String fieldName, String searchString)
	{
		List<String> values	  = new List<String>();

		String query	   = 'SELECT e.';

		query += nameSpace + fieldName;
		query += ' c, ';
		query += ' COUNT_DISTINCT(e.Id)';
		query += ' FROM ';
		query += nameSpace + 'Event__c e';

		if (String.isNotBlank(searchString)) {
			query += ' WHERE (' + fieldName + ' LIKE \'%' + searchString + '%\')';
		}

		query += ' GROUP BY ' + fieldName;
		query += ' LIMIT '	+ 100;

		List<AggregateResult> results = Database.query(query);

		for (AggregateResult ar: results) {
			String entry = (String)ar.get('c');

			if (String.isNotBlank(entry)) {
				values.add(entry);
			}
		}

		return values;
	}

	public static Map<String, String> getCustomFieldTypes(String customFields)
	{
		Map<String, String> fieldTypeMap = new Map<String, String>();

		Map<String, Schema.SObjectType>  globalDescribe		  = Schema.getGlobalDescribe();
		Schema.SObjectType				 objectType			  = globalDescribe.get(nameSpace + 'Event__c');
		Schema.DescribeSObjectResult	 objectDescribeResult = objectType.getDescribe();
		Map<String, Schema.SObjectField> objectFieldMap		  = objectDescribeResult.fields.getMap();

		for(String field : getCustomFields(customFields))
		{
			Schema.SObjectField objectField = objectFieldMap.get(nameSpace + field);
			Schema.DescribeFieldResult fieldDescription = objectField.getDescribe();

			fieldTypeMap.put(field, fieldDescription.getType().name());
		}

		return fieldTypeMap;
	}

}