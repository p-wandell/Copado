/*
 * Copyright (c) 2020. 7Summits Inc.
 */

/*
	 Name : x7sEventsListControllerTest
	Description : Test class for x7sEventsListController class
	Date : 25/5/2016
*/

@IsTest(SeeAllData=true)
global class x7sEventsListControllerTest {

	private static final String RELATED_FILES = 'Related File';

	@IsTest
	static void test_EventsFeatures() {
		x7sEventsListWrapper eventWrapper = new x7sEventsListWrapper();
		System.assertNotEquals(null, eventWrapper);

		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(100);
		System.assertEquals(eventList.size(), 100);

		List<Topic> topics = x7sEventsUtility.createTopic(100);
		System.assertEquals(topics.size(), 100);

		List<X7S_Event_RSVP__c> eventRSVPlst = x7sEventsUtility.createRSVPRecords(7, eventList);
		System.assertEquals(eventRSVPlst.size(), 7);

		eventRSVPlst = x7sEventsUtility.deleteRSVPRecords(3, eventRSVPlst);

		x7sEventsUtility.createTopicAssignment(topics[0].Id, eventList[0].Id);

		Boolean eventListFlag = true;
		Integer numberofresults = 100;
		Integer listSize = 100;
		Integer pageNumber = 1;
		String strfilterType = null;
		String strRecordId = '';
		String networkId = '';
		String sortBy = null;
		String filterByTopic = null;
		String topicName = null;
		Boolean filterBySearchTerm = false;
		String searchTerm = null;
		String filterOn = 'None';
		String fromDate = null;
		String toDate = null;
		String listViewMode = 'List';

		x7sEventsListController.getSitePrefix();
		x7sEventsListController.getSessionId();

		//Create Community user
		x7sEventsUtility.createUsers(1, x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER);

		//Create Community User
		//As we are using custom object News, we have created user with a CUSTOM Community Profile,
		//Because standard community profile do not allow to give permissions to custom objects.
		User communityUser = x7sEventsUtility.createCommunityUsers(x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser) {
			Test.startTest();
			//check with date filter on list view with topic filter and sort by filter

			List<String> eventsList = new List<String>();


			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			fromDate = String.valueOf(System.today());
			toDate = String.valueOf(System.today().addDays(5));
			filterByTopic = topics[0].Id;
			topicName = 'Test000';
			sortBy = 'Upcoming';

			x7sEventsListController.deleteAttachment(strRecordId);
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			fromDate = String.valueOf(System.today());
			toDate = null;
			filterByTopic = topics[0].Id;
			topicName = 'Test000';
			sortBy = 'Top Attendees';

			x7sEventsListWrapper wrapper =  x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);
			System.assertNotEquals(null, wrapper);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_eventPagination()
	{
		Boolean eventListFlag = true;
		Integer numberofresults = 100;
		Integer listSize = 100;
		Integer pageNumber = 1;
		String strfilterType = null;
		String strRecordId = '';
		String networkId = '';
		String sortBy = null;
		String filterByTopic = null;
		String topicName = null;
		Boolean filterBySearchTerm = false;
		String searchTerm = null;
		String filterOn = 'None';
		String fromDate = null;
		String toDate = null;
		String listViewMode = 'List';

		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(10);
		System.assertEquals(eventList.size(), 10);

		//Create Community User
		//As we are using custom object News, we have created user with a CUSTOM Community Profile,
		//Because standard community profile do not allow to give permissions to custom objects.
		User communityUser = x7sEventsUtility.createCommunityUsers(x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser)
		{
			Test.startTest();
			List<String> eventsList = new List<String>();

			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			//check with pagination next previous
			x7sEventsListController.nextPage(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);
			x7sEventsListController.previousPage(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);
			System.assertEquals(pageNumber, 1);

			Test.stopTest();

		}
	}

	@IsTest(SeeAllData=true)
	static void test_calendarMode() {
		x7sEventsListWrapper eventWrapper = new x7sEventsListWrapper();
		System.assertNotEquals(null, eventWrapper);

		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(1001);
		System.assertEquals(eventList.size(), 1001);

		List<Topic> topics = x7sEventsUtility.createTopic(1001);
		System.assertEquals(topics.size(), 1001);

		List<X7S_Event_RSVP__c> eventRSVPlst = x7sEventsUtility.createRSVPRecords(7, eventList);
		System.assertEquals(eventRSVPlst.size(), 7);

		eventRSVPlst = x7sEventsUtility.deleteRSVPRecords(3, eventRSVPlst);

		x7sEventsUtility.createTopicAssignment(topics[0].Id, eventList[0].Id);

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

		x7sEventsListController.getSitePrefix();
		x7sEventsListController.getSessionId();

		//Create Community user
		x7sEventsUtility.createUsers(1, x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER);

		//Create Community User
		//As we are using custom object News, we have created user with a CUSTOM Community Profile,
		//Because standard community profile do not allow to give permissions to custom objects.
		User communityUser = x7sEventsUtility.createCommunityUsers(x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser)
		{
			Test.startTest();

			List<String> eventsList = new List<String>();

			//check for calendar mode
			listViewMode = 'Calendar';
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			listViewMode = 'Calendar';
			sortBy = 'Upcoming';
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, '', filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);
			//check save event
			X7S_Event__c eventObj = new X7S_Event__c(Name = 'Test Event', Start_DateTime__c = System.today().addDays(2), End_DateTime__c = System.today().addDays(5));
			insert eventObj;

			x7sEventsUtility.createTopicAssignment(topics[0].Id, eventObj.Id);
			
			x7sEventsListController.saveEvents(eventObj, topics[0].Id, allDayEventStartDate, allDayEventEndDate,'');
			System.assertNotEquals(eventObj.Id, null);

			allDayEventStartDate = String.valueOf(System.today());
			allDayEventEndDate = String.valueOf(System.today().addDays(3));
			X7S_Event__c eventObjNew = new X7S_Event__c(Name = 'Test Event', All_Day_Event__c = true, End_DateTime__c = System.today().addDays(5));
			x7sEventsListController.isObjectEditable();
			//x7sEventsListController.saveEvent(eventObjNew, topics[0].Id);
			x7sEventsListController.saveEvents(eventObjNew, topics[0].Id, allDayEventStartDate, allDayEventEndDate,'');
			System.assertNotEquals(eventObjNew.Id, null);

			Test.stopTest();

		}
	}

	@IsTest
	static void test_eventObjAccess(){
		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(1001);
		System.assertEquals(eventList.size(), 1001);

		//Create Community user
		x7sEventsUtility.createUsers(1, x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		User communityUser = x7sEventsUtility.createCommunityUsers(x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser) {
			Test.startTest();

			//fetch Event Record
			x7sEventsListController.getEventRecord(eventList[0].Id);
			x7sEventsListController.getEventName(eventList[0].Id);

			//call method to check if object is creatable to show hide "Add new" button on header in list view page
			x7sEventsListController.isObjectCreatable();
			x7sEventsListController.isRecordEditable(eventList[0].Id);

			//fetch Featured Event Records
			x7sEventsListController.getFeaturedEvents(eventList[0].Id, eventList[1].Id, eventList[2].Id, eventList[3].Id, eventList[4].Id);
			try {
				//create RSVP Event record
				x7sEventsListController.createRSVPevents(eventList[0].Id, 'Test Response');
			} catch (Exception e) {
				System.debug(e.getMessage());
			}

			//Delete RSVP Event
			x7sEventsListController.deleteRSVPevents(eventList[0].Id);
			X7S_Event_RSVP__c objhere ;
			for (X7S_Event_RSVP__c obj: [SELECT Id FROM X7S_Event_RSVP__c WHERE Id = :eventList[0].Id]) {
				objhere = obj;
			}
			System.assertEquals(objhere, null);

			// get the RSVP count
			Decimal rsvpCount = x7sEventsListController.getRSVPAttendeeCount(eventList[0].Id);
			System.assertEquals(0, rsvpCount);

			//check if Event is RSVP or not
			x7sEventsListController.checkRSVPevents(eventList[0].Id);
			System.assertNotEquals(x7sEventsListController.checkRSVPevents(eventList[0].Id), null);

			//x7sEventsListController.isRecordEditable(eventList[0].Id);
			x7sEventsListController.getRSVPMemberAttendes(eventList[0].Id);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_Topics() {
		List<User> users = x7sEventsUtility.createUsers(1, x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER);		

		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				//Create Topic Record
				List<Topic> topics1 = x7sEventsUtility.createTopic(200);
				System.assertEquals(topics1.size(), 200);

				x7sEventsListWrapper wrapper = new x7sEventsListWrapper('field1', 'message1');
				System.assertEquals('field1', wrapper.field);
				System.assertEquals('message1', wrapper.errorMsg);
			}
		} 

	}

	@IsTest
	static void test_getAllGroups() {
		List<User> users = x7sEventsUtility.createUsers(1, x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER);

		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				Map<String, String> groupList = x7sEventsListController.getAllGroups();

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

			x7sEventsUtility.createTestGroup('Test group X1');

			Map<String, String> groupList = x7sEventsListController.getGroups();
			System.assertNotEquals(null, groupList);
			Test.stopTest();
		}
	}

	@IsTest
	static void test_userAuthorizedToPost() {
		Boolean canPost = x7sEventsListController.userAuthorizedToPost();
		System.debug('test_userAuthorizedToPost = ' + canPost);
		System.assertNotEquals(null, canPost);
	}

	@IsTest
	static void test_getTopicLimit() {
		Integer topicLimit = x7sEventsListController.getTopicLimit();
		System.debug('test_getTopicLimit: ' + topicLimit);
		System.assertNotEquals(null, topicLimit);
	}

	@IsTest
	static void test_getNameSpacePrefix() {
		x7sEventsBaseController base = new x7sEventsBaseController();
		System.assertNotEquals(null, base);
		x7sEventsBaseController.BaseModel model = x7sEventsBaseController.getModel();
		System.assertNotEquals(null, model);
		String sitePrefix = x7sEventsBaseController.getSitePrefix();
		System.assertNotEquals(null, sitePrefix);
	}

	@IsTest
	static void test_EventsPickList() {
		String location = 'Location_Name__c';
		Integer testSize = 11;

		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(testSize);
		System.assert(eventList.size() > 0);

		List<String> locations = x7sEventsListController.getEventsPicklist(location, '');
		System.assertNotEquals(null, locations);
		System.assert(locations.size() > 0);

		locations = x7sEventsListController.getEventsPicklist(location, '1');
		System.assert(locations.size() > 0);

		List<String> pickListValues = x7sEventsListController.getEventTypeList();
		System.assertNotEquals(null, pickListValues);
	}

	@IsTest
	static void test_checkCustomFields()
	{
		String customFieldString = 'Location_Name__c';
		List<String> customFields = x7sEventsListController.getCustomFields(customFieldString);
		System.assertNotEquals(null,  customFields);

		customFieldString += ', Event_Type__c ';
		customFields = x7sEventsListController.getCustomFields(customFieldString);
		System.assertNotEquals(null,  customFields);

		String invalidField = 'abc';
		customFieldString += ',' + invalidField;
		customFields = x7sEventsListController.getCustomFields(customFieldString);
		System.assertNotEquals(null, customFields);

		System.debug(customFields);
	}

	@IsTest
	static void test_getCustomFieldTypes()
	{
		String customFieldList = 'Location_Name__c, Event_Type__c';
		Map<String, String> fieldMap = x7sEventsListController.getCustomFieldTypes(customFieldList);
		System.assertNotEquals(null, fieldMap);
		System.debug('fieldMap:' + fieldMap);
	}

	@IsTest
	static void test_GetCustomFilterClause()
	{
		String filterString = 'field1:value1;field2:value2;';
		String query = x7sEventsListController.getCustomFilterClause(filterString);
		System.assertNotEquals(null, query);
	}
	
	@IsTest
	static void test_getLanguage(){
		String  userLanguage = x7sEventsListController.getLanguage();
		System.debug('test_getLanguage = ' + userLanguage);
		System.assertEquals('en_US', userLanguage);		
	}

	@IsTest
	static void test_getComboboxValue(){
		Map<String, String> languageMap = x7sEventsListController.getLanguageOption();
		System.assertEquals( languageMap.size(), languageMap.size());
	}

	@IsTest
	static void test_getCurrentUser() {
		User u = x7sEventsUtility.createUsers(1, 'Customer Community User')[0];
		System.runAs(u) {
			User usr = x7sEventsListController.getCurrentUser();
			System.assertNotEquals(null, usr);
		}
	}

	@IsTest
	static void test_multiLanguageSet() {
		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(10);

		set<String> duplicate = new set<String>();
		List<String> myEvents = new List<String>();

		for(X7S_Event__c record :eventList){
			duplicate.add(record.id);
			myEvents.add(record.id);
		}
		Test.startTest();
		set<String> mulitlanguage= x7sEventsListController.multiLanguageSet(myEvents,duplicate);
		System.assertNotEquals(null, mulitlanguage.size());
		Test.stopTest();    		
	}

	@IsTest
	static void test_updateImage() {
		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(1);

		//create Attachment related to news object created
		Attachment attach = new Attachment();
		attach.Name = 'Unit Test Attachment';
		Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
		attach.Body = bodyBlob;
		attach.ParentId = eventList[0].Id;
		attach.ContentType = 'image/png';
		insert attach;
		
		Test.startTest();
		Attachment imageTest= x7sEventsListController.updateImage(eventList[0].Id,'image/png','Unit Test Attachment','Unit Test Attachment Body');
		System.assertNotEquals(null, imageTest);
		Test.stopTest(); 
	}

	@IsTest
	static void test_getPicklistValues() {
		x7sEventsUtility.createEventsRecords(1);
		
		Test.startTest();
		List<String> eventPicklistValue = x7sEventsListController.getEventPickList('School__c','event');
		System.assertNotEquals(null, eventPicklistValue.size());

		List<String> picklistValue = x7sEventsListController.getPicklistValues('School__c','event');
		System.assertEquals(null, picklistValue);

		Test.stopTest(); 
	}

	@IsTest
	static void test_getEventRecord() {		
			
			Test.startTest();			
			String query = x7sEventsListController.getCalendarWhereClause('customFieldString');
			System.assertNotEquals(null, query);
			Test.stopTest(); 		
	}

	@IsTest
	static void test_getCalendarWhereClause() {

		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(1);
		String customFieldString = 'Location_Name__c';
		System.debug(customFieldString);

		User communityUser = x7sEventsUtility.createCommunityUsers(x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

			System.runAs(communityUser) {
			Test.startTest();			
			x7sEventsListController.getEventRecord(eventList[0].Id,'customFieldString');
			Test.stopTest(); 

		}
	}

	@IsTest
	static void test_getTimeZone() {			
			Test.startTest();			
			String currentTime = x7sEventsListController.getTimeZone();
			System.assertNotEquals(null, currentTime);
			Test.stopTest(); 		
	}
	
	@IsTest(SeeAllData=true)
	static void test_previousPageList() {
			Test.startTest();
		List<String> eventsList = new List<String>();

		x7sEventsListController.previousPageList(1,true,10,10,'','','','','','','','','','','', eventsList);
			Test.stopTest(); 		
	}

	@IsTest(SeeAllData=true)
	static void test_nextPageList() {
			Test.startTest();
		List<String> eventsList = new List<String>();
			x7sEventsListController.nextPageList(1,true,10,10,'','','','','','','','','','','', eventsList);
			Test.stopTest(); 		
	}
	@IsTest(SeeAllData=true)
	static void test_getEventsList() {
			Test.startTest();
		List<String> eventsList = new List<String>();

		x7sEventsListController.getEventsList(false,10,10,'','','','','','','','','','','', eventsList);
			Test.stopTest(); 		
	}

	@IsTest(SeeAllData=true)
	static void test_EventsFeaturesRemain() {
		x7sEventsListWrapper eventWrapper = new x7sEventsListWrapper();
		System.assertNotEquals(null, eventWrapper);

		List<X7S_Event__c> eventList = x7sEventsUtility.createEventsRecords(100);
		System.assertEquals(eventList.size(), 100);

		List<Topic> topics = x7sEventsUtility.createTopic(100);
		System.assertEquals(topics.size(), 100);

		List<X7S_Event_RSVP__c> eventRSVPlst = x7sEventsUtility.createRSVPRecords(7, eventList);
		System.assertEquals(eventRSVPlst.size(), 7);

		eventRSVPlst = x7sEventsUtility.deleteRSVPRecords(3, eventRSVPlst);

		x7sEventsUtility.createTopicAssignment(topics[0].Id, eventList[0].Id);

		Boolean eventListFlag = true;
		Integer numberofresults = 100;
		Integer listSize = 100;
		Integer pageNumber = 1;
		String strfilterType = null;
		String strRecordId = '';
		String networkId = '';
		String sortBy = null;
		String filterByTopic = null;
		String topicName = null;
		Boolean filterBySearchTerm = false;
		String searchTerm = null;
		String filterOn = 'None';
		String fromDate = null;
		String toDate = null;
		String listViewMode = 'List';

		x7sEventsListController.getSitePrefix();
		x7sEventsListController.getSessionId();

		//Create Community user
		x7sEventsUtility.createUsers(1, x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER);

		//Create Community User
		//As we are using custom object News, we have created user with a CUSTOM Community Profile,
		//Because standard community profile do not allow to give permissions to custom objects.
		User communityUser = x7sEventsUtility.createCommunityUsers(x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER_CLONE);

		System.runAs(communityUser) {
			Test.startTest();

			//Check with Featured Event Id

			List<String> featuredEventsList = new List<String>();
			featuredEventsList.add(eventList[0].Id);
			featuredEventsList.add(eventList[1].Id);
			x7sEventsListWrapper evtWrapper = x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, featuredEventsList);
			System.assertNotEquals(null, evtWrapper);
			System.assertEquals(2, evtWrapper.totalResults);

			List<String> eventsList = new List<String>();

			//check for search page
			searchTerm = 'event';
			sortBy = 'Upcoming';
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			//check for topic page
			filterOn = 'Topic Value';
			topicName = 'Test000';
			sortBy = 'Upcoming';
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			topicName = 'Test000';
			sortBy = 'Top Attendees';
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			//check for recommended on detail page
			eventListFlag = false;
			filterOn = 'None';
			x7sEventsListController.getEvents(eventListFlag, numberofresults, listSize, pageNumber, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventsList);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_breakUpDetails() {
		Test.startTest();
		String sampleData = 'Short string';

		System.assertEquals(x7sEventsListController.breakUpDetails(sampleData).length(), sampleData.length());

		sampleData = '<p>Sample Event <b>Summary</b> 2</p> <HTML><BODY><br/><br/><a href="https:\n' +
				'     //fran-dev-events-w18-developer-edition.gus.force.com/s/event/a01B0000007R';
		System.assertEquals(x7sEventsListController.breakUpDetails(sampleData).length(), sampleData.length() + 3);

		Test.stopTest();
	}

	@IsTest
	static void test_saveRelatedFile() {

		Test.startTest();
			List<Topic> topics = x7sEventsUtility.createTopic(1);
		    System.assertEquals(topics.size(), 1);

            X7S_Event__c objEvent = new X7S_Event__c();

            objEvent.Name = 'UnitTestEvent';
            objEvent.Start_DateTime__c = System.today();
			objEvent.End_DateTime__c = System.today().addDays(5);
			objEvent.Details__c = 'Event Details is here.';
			objEvent.Location_Name__c = 'Test Location';
            objEvent.Enable_RSVP__c = false;
			objEvent.Image_Type__c = RELATED_FILES;

            x7sEventsListController.saveEvents(objEvent, topics[0].Id, '', '','');
			System.assertNotEquals(null, objEvent.Id);
			
			ContentDocumentLink contentDoc = x7sEventsListController.saveRelatedFile(objEvent.Id, 'Attachment1', 'This is test image');
			System.assertNotEquals(null, contentDoc.Id);

			x7sEventsContentDocModel contentModel = new x7sEventsContentDocModel();
			System.assertEquals('', contentModel.latestImageVersionId);
			
		Test.stopTest();
	}

}