/* Copyright ©2016-2018 7Summits Inc. All rights reserved. */

/*
	 Name : SVNSUMMITS_EventListController_Test
	Description : Test class for SVNSUMMITS_EventListController class
	Date : 25/5/2016
*/

@IsTest
global class SVNSUMMITS_EventListController_Test {


	static testMethod void test_EventsFeatures() {
		SVNSUMMITS_EventListWrapper eventWrapper = new SVNSUMMITS_EventListWrapper();
		System.assertNotEquals(null, eventWrapper);

		List<Event__c> eventList = SVNSUMMITS_EventUtility.createEventsRecords(1001);
		System.assertEquals(eventList.size(), 1001);

		List<Topic> topics = SVNSUMMITS_EventUtility.createTopic(1001);
		System.assertEquals(topics.size(), 1001);

		List<Event_RSVP__c> eventRSVPlst = SVNSUMMITS_EventUtility.createRSVPRecords(7, eventList);
		System.assertEquals(eventRSVPlst.size(), 7);

		eventRSVPlst = SVNSUMMITS_EventUtility.deleteRSVPRecords(3, eventRSVPlst);

		TopicAssignment topicAssignment = SVNSUMMITS_EventUtility.createTopicAssignment(topics[0].Id, eventList[0].Id);

		Boolean eventListFlag = true;
		Integer numberofresults = 1001;
		Integer listSize = 1001;
		Integer pageNumber = 1;
		String strfilterType = null;
		String strRecordId = '';
		String networkId = '';
		String allDayEventStartDate = '';
		String allDayEventEndDate = '';
		String sortBy = null;
		String filterByTopic = null;
		String topicName = null;
		Boolean filterBySearchTerm = false;
		String searchTerm = null;
		String filterOn = 'None';
		String fromDate = null;
		String toDate = null;
		String listViewMode = 'List';

		SVNSUMMITS_EventListController.getSitePrefix();
		SVNSUMMITS_EventListController.getSessionId();

		//Create Community user
		List<User> lstOfUser = SVNSUMMITS_EventUtility.createUsers(1, SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER);

		//Create Community User
		//As we are using custom object News, we have created user with a CUSTOM Community Profile,
		//Because standard community profile do not allow to give permissions to custom objects.
		User communityUser = SVNSUMMITS_EventUtility.createCommunityUsers(SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser) {
			Test.startTest();
			//check with date filter on list view with topic filter and sort by filter

			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			fromDate = String.valueOf(System.today());
			toDate = String.valueOf(System.today().addDays(5));
			filterByTopic = topics[0].Id;
			topicName = 'Test000';
			sortBy = 'Upcoming';

			SVNSUMMITS_EventListController.deleteAttachment(strRecordId);
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			fromDate = String.valueOf(System.today());
			toDate = null;
			filterByTopic = topics[0].Id;
			topicName = 'Test000';
			sortBy = 'Top Attendees';

			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			fromDate = null;
			toDate = String.valueOf(System.today().addDays(5));
			filterByTopic = topics[0].Id;
			topicName = 'Test000';
			sortBy = '';
			System.assertEquals(numberofresults, 1001);

			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			//check with pagination next previous
			SVNSUMMITS_EventListController.nextPage(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);
			SVNSUMMITS_EventListController.previousPage(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);
			System.assertEquals(pageNumber, 1);

			//check for search page
			searchTerm = 'event';
			sortBy = 'Upcoming';
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			searchTerm = 'event';
			sortBy = 'Top Attendees';
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			//check with pagination next previous
			SVNSUMMITS_EventListController.nextPage(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);
			SVNSUMMITS_EventListController.previousPage(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);
			System.assertEquals(numberofresults, 1001);
			searchTerm = null;

			//check for topic page
			filterOn = 'Topic Value';
			topicName = 'Test000';
			sortBy = 'Upcoming';
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			topicName = 'Test000';
			sortBy = 'Top Attendees';
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			//check for recommended on detail page
			eventListFlag = false;
			filterOn = 'None';
			//SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_calendarMode() {
		SVNSUMMITS_EventListWrapper eventWrapper = new SVNSUMMITS_EventListWrapper();
		System.assertNotEquals(null, eventWrapper);

		List<Event__c> eventList = SVNSUMMITS_EventUtility.createEventsRecords(1001);
		System.assertEquals(eventList.size(), 1001);

		List<Topic> topics = SVNSUMMITS_EventUtility.createTopic(1001);
		System.assertEquals(topics.size(), 1001);

		List<Event_RSVP__c> eventRSVPlst = SVNSUMMITS_EventUtility.createRSVPRecords(7, eventList);
		System.assertEquals(eventRSVPlst.size(), 7);

		eventRSVPlst = SVNSUMMITS_EventUtility.deleteRSVPRecords(3, eventRSVPlst);

		TopicAssignment topicAssignment = SVNSUMMITS_EventUtility.createTopicAssignment(topics[0].Id, eventList[0].Id);

		Boolean eventListFlag = true;
		Integer numberofresults = 1001;
		Integer listSize = 1001;
		Integer pageNumber = 1;
		String strfilterType = null;
		String strRecordId = '';
		String networkId = '';
		String allDayEventStartDate = '';
		String allDayEventEndDate = '';
		String sortBy = null;
		String filterByTopic = null;
		String topicName = null;
		Boolean filterBySearchTerm = false;
		String searchTerm = null;
		String filterOn = 'None';
		String fromDate = null;
		String toDate = null;
		String listViewMode = 'List';

		SVNSUMMITS_EventListController.getSitePrefix();
		SVNSUMMITS_EventListController.getSessionId();

		//Create Community user
		List<User> lstOfUser = SVNSUMMITS_EventUtility.createUsers(1, SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER);

		//Create Community User
		//As we are using custom object News, we have created user with a CUSTOM Community Profile,
		//Because standard community profile do not allow to give permissions to custom objects.
		User communityUser = SVNSUMMITS_EventUtility.createCommunityUsers(SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser)
		{
			Test.startTest();

			//check for calendar mode
			listViewMode = 'Calendar';
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			listViewMode = 'Calendar';
			sortBy = 'Upcoming';
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);
			SVNSUMMITS_EventListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, '', filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode);

			//check save event
			Event__c eventObj = new Event__c(Name = 'Test Event', Start_DateTime__c = System.today().addDays(2), End_DateTime__c = System.today().addDays(5));
			SVNSUMMITS_EventListController.saveEvents(eventObj, topics[0].Id, allDayEventStartDate, allDayEventEndDate);
			System.assertNotEquals(eventObj.Id, null);

			allDayEventStartDate = String.valueOf(System.today());
			allDayEventEndDate = String.valueOf(System.today().addDays(3));
			Event__c eventObjNew = new Event__c(Name = 'Test Event', All_Day_Event__c = true, End_DateTime__c = System.today().addDays(5));
			SVNSUMMITS_EventListController.isObjectEditable();
			//SVNSUMMITS_EventListController.saveEvent(eventObjNew, topics[0].Id);
			SVNSUMMITS_EventListController.saveEvents(eventObjNew, topics[0].Id, allDayEventStartDate, allDayEventEndDate);
			System.assertNotEquals(eventObjNew.Id, null);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_eventObjAccess(){
		List<Event__c> eventList = SVNSUMMITS_EventUtility.createEventsRecords(1001);
		System.assertEquals(eventList.size(), 1001);

		//Create Community user
		List<User> lstOfUser = SVNSUMMITS_EventUtility.createUsers(1, SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		User communityUser = SVNSUMMITS_EventUtility.createCommunityUsers(SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser) {
			Test.startTest();

			//fetch Event Record
			SVNSUMMITS_EventListController.getEventRecord(eventList[0].Id);
			SVNSUMMITS_EventListController.getEventName(eventList[0].Id);

			//call method to check if object is creatable to show hide "Add new" button on header in list view page
			SVNSUMMITS_EventListController.isObjectCreatable();
			SVNSUMMITS_EventListController.isRecordEditable(eventList[0].Id);

			//fetch Featured Event Records
			SVNSUMMITS_EventListController.getFeaturedEvents(eventList[0].Id, eventList[1].Id, eventList[2].Id, eventList[3].Id, eventList[4].Id);
			try {
				//create RSVP Event record
				SVNSUMMITS_EventListController.createRSVPevents(eventList[0].Id, 'Test Response');
			} catch (Exception e) {
			}

			//Delete RSVP Event
			SVNSUMMITS_EventListController.deleteRSVPevents(eventList[0].Id);
			Event_RSVP__c objhere ;
			for (Event_RSVP__c obj: [SELECT Id FROM Event_RSVP__c WHERE Id = :eventList[0].Id]) {
				objhere = obj;
			}
			System.assertEquals(objhere, null);

			// get the RSVP count
			Decimal rsvpCount = SVNSUMMITS_EventListController.getRSVPAttendeeCount(eventList[0].Id);
			System.assertEquals(0, rsvpCount);

			//check if Event is RSVP or not
			SVNSUMMITS_EventListController.checkRSVPevents(eventList[0].Id);
			System.assertNotEquals(SVNSUMMITS_EventListController.checkRSVPevents(eventList[0].Id), null);

			//SVNSUMMITS_EventListController.isRecordEditable(eventList[0].Id);
			SVNSUMMITS_EventListController.getRSVPMemberAttendes(eventList[0].Id);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_Topics() {
		List<User> users = SVNSUMMITS_EventUtility.createUsers(1, SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER);
		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				//Create Topic Record
				List<Topic> topics1 = SVNSUMMITS_EventUtility.createTopic(2000);
				System.assertEquals(topics1.size(), 2000);

				//Get Topics for Topic dropdown in List view of news
				Map<String, String> topicMap1 = SVNSUMMITS_EventListController.getTopics();

				SVNSUMMITS_EventListWrapper wrapper = new SVNSUMMITS_EventListWrapper('field1', 'message1');
				System.assertEquals('field1', wrapper.field);
				System.assertEquals('message1', wrapper.errorMsg);
			}
		}
	}

	@IsTest
	static void test_getAllGroups() {
		List<User> users = SVNSUMMITS_EventUtility.createUsers(1, SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER);

		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				Map<String, String> groupList = SVNSUMMITS_EventListController.getAllGroups();

				System.assertNotEquals(null, groupList);
			}
		}
	}

	@IsTest
	static void test_getGroups() {
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile adminProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'System Administrator'
				LIMIT 1
		];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				UserRoleId = portalRole.Id,
				LanguageLocaleKey = 'en_US');

		System.runAs(admin) {
			Test.startTest();

			Id testGroupId = SVNSUMMITS_EventUtility.createTestGroup('Test group X1');
			String testGroupIdStr = (String) testGroupId;

			Map<String, String> groupList = SVNSUMMITS_EventListController.getGroups();
			System.assertNotEquals(null, groupList);
			Test.stopTest();
		}
	}

	@IsTest
	static void test_userAuthorizedToPost() {
		Boolean canPost = SVNSUMMITS_EventListController.userAuthorizedToPost();
		System.debug('test_userAuthorizedToPost = ' + canPost);
		System.assertNotEquals(null, canPost);
	}

	@IsTest
	static void test_getTopicLimit() {
		Integer topicLimit = SVNSUMMITS_EventListController.getTopicLimit();
		System.debug('test_getTopicLimit: ' + topicLimit);
		System.assertNotEquals(null, topicLimit);
	}

	@IsTest
	static void test_getNameSpacePrefix() {
		SVNSUMMITS_EventBaseController base = new SVNSUMMITS_EventBaseController();
		System.assertNotEquals(null, base);
		SVNSUMMITS_EventBaseController.BaseModel model = SVNSUMMITS_EventBaseController.getModel();
		System.assertNotEquals(null, model);
		String sitePrefix = SVNSUMMITS_EventBaseController.getSitePrefix();
		System.assertNotEquals(null, sitePrefix);
	}

	@IsTest
	static void test_EventsPickList() {
		String location = 'Location_Name__c';
		Integer testSize = 11;

		List<Event__c> eventList = SVNSUMMITS_EventUtility.createEventsRecords(testSize);
		System.assertEquals(testSize, eventList.size());

		List<String> locations = SVNSUMMITS_EventListController.getEventsPicklist(location, '');
		System.assertNotEquals(null, locations);
		System.assertEquals(testSize, locations.size());

		locations = SVNSUMMITS_EventListController.getEventsPicklist(location, '1');
		System.assertEquals(2, locations.size());

		List<String> eventTypes = SVNSUMMITS_EventListController.getEventPickList('Event_Type__c', '');
		System.assertNotEquals(null, eventTypes);

		List<String> pickListValues = SVNSUMMITS_EventListController.getPicklistValues('Event__c', 'Event_Type__c');
		System.assertNotEquals(null, pickListValues);
	}

	@IsTest
	static void test_checkCustomFields()
	{
		String customFieldString = 'Location_Name__c';
		List<String> customFields = SVNSUMMITS_EventListController.getCustomFields(customFieldString);
		System.assertNotEquals(null,  customFields);

		customFieldString += ', Event_Type__c ';
		customFields = SVNSUMMITS_EventListController.getCustomFields(customFieldString);
		System.assertNotEquals(null,  customFields);

		String invalidField = 'abc';
		customFieldString += ',' + invalidField;
		customFields = SVNSUMMITS_EventListController.getCustomFields(customFieldString);
		System.assertNotEquals(null, customFields);

		System.debug(customFields);
	}

	@IsTest
	static void test_getCustomFieldTypes()
	{
		String customFieldList = 'Location_Name__c, Event_Type__c';
		Map<String, String> fieldMap = SVNSUMMITS_EventListController.getCustomFieldTypes(customFieldList);
		System.assertNotEquals(null, fieldMap);
		System.debug('fieldMap:' + fieldMap);
	}

	@IsTest
	static void test_GetCustomFilterClause()
	{
		String filterString = 'field1:value1;field2:value2;';
		String query = SVNSUMMITS_EventListController.getCustomFilterClause(filterString);
		System.assertNotEquals(null, query);
	}
}