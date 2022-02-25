/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_NewsControllerTest
@Created by          :
@Description         : Apex Test class for SVNSUMMITS_NewsController
*/
@IsTest
public class SVNSUMMITS_NewsControllerTest {

	//Hardcoded Network Id as we can't able to get get Network Id in Test classes.
	//Packaging org
	//public Static String strNetId = '0DB36000000PB5MGAW';

	public static String strNetId {
		get {
			return [SELECT Id FROM Network LIMIT 1][0].Id;
		}
	}

	// Fran Summer 17 org
	//public Static String strNetId = '0DBB0000000CayaOAC';


	@IsTest
	static void test_NewsBulk() {

		//set NetworkId variables of the Class with hardcoded value.
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//Create News in Bulk to check with bulk data.
		List<News__c> objNewzBulkList = SVNSUMMITS_NewsUtilityTest.createBulkNews(1001, strNetId);

		//create Topic Records
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(1001, strNetId);

		//Assign Topic to News Records
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		TopicAssignment topicAssg1 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj1.Id);
		TopicAssignment topicAssg2 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj2.Id);
		TopicAssignment topicAssg3 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj3.Id);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		System.runAs(u){
			Test.startTest();

			//call getNews to fetch records on list view with no record id and without any filter and sorting
			SVNSUMMITS_WrapperNews newsWrapper = SVNSUMMITS_NewsController.getNews(10, null, null, null, null, null, null, 'None', null, null, null);
			System.assertEquals(newsWrapper.newsList.size(), 10);

			//call getNews to fetch records on list view without any filter and sorting
			SVNSUMMITS_WrapperNews newsWrapperList = SVNSUMMITS_NewsController.getNews(10, null, null, null, null, null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperList.newsList.size(), 10);

			//call getNews method to fetch records on list with sirt by as 'Most Recent'
			SVNSUMMITS_NewsController.getNews(10, null, null, null, 'Most Recent', null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperList.newsList.size(), 10);

			//call getNews method to fetch records on list with sirt by as 'Oldest First'
			SVNSUMMITS_NewsController.getNews(10, null, null, null, 'Oldest First', null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperList.newsList.size(), 10);

			//call getNews to fetch recommended records on detail page of news record
			SVNSUMMITS_WrapperNews newsWrapperRecomm = SVNSUMMITS_NewsController.getNews(10, newsObj.Id, null, null, null, null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperRecomm.newsList.size(), 3);

			//call getNews method on search page to show related data of search term with sort by as 'Most Recent'
			SVNSUMMITS_WrapperNews newsWrapperSearchItemsRecent = SVNSUMMITS_NewsController.getNews(10, null, null, 'Most Recent', null, null, null, 'Search Term', 'test', null, null);
			System.assertEquals(newsWrapperSearchItemsRecent.newsList.size(), 10);

			//call getNews method on search page to show related data of search term with sort by as 'Oldest First'
			SVNSUMMITS_WrapperNews newsWrapperSearchItemsOldest = SVNSUMMITS_NewsController.getNews(10, null, null, 'Oldest First', null, null, null, 'Search Term', 'test', null, null);
			System.assertEquals(newsWrapperSearchItemsOldest.newsList.size(), 10);


			Test.stopTest();
		}
	}

	@IsTest
	static void test_NewsBulkTopics()
	{
		//set NetworkId variables of the Class with hardcoded value.
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//Create News in Bulk to check with bulk data.
		List<News__c> objNewzBulkList = SVNSUMMITS_NewsUtilityTest.createBulkNews(1001, strNetId);

		//create Topic Records
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(1001, strNetId);

		//Assign Topic to News Records
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		TopicAssignment topicAssg1 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj1.Id);
		TopicAssignment topicAssg2 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj2.Id);
		TopicAssignment topicAssg3 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj3.Id);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		System.runAs(u)
		{
			Test.startTest();
			//call getNews method to show all news related to topic on topic detail page with sort by as 'Most Recent'
			SVNSUMMITS_WrapperNews newsWrapperTopicsRecent = SVNSUMMITS_NewsController.getNews(10, null, null, 'Most Recent', null, null, topics[0].Name, 'Topic Value', null, null, null);
			System.assertEquals(newsWrapperTopicsRecent.newsList.size(), 4);

			//call getNews method to show all news related to topic on topic detail page with sort by as 'Oldest First'
			SVNSUMMITS_WrapperNews newsWrapperTopicsOldest = SVNSUMMITS_NewsController.getNews(10, null, null, 'Oldest First', null, null, topics[0].Name, 'Topic Value', null, null, null);
			System.assertEquals(newsWrapperTopicsOldest.newsList.size(), 4);

			//call getNews method to filter list view on basis of topic filter
			SVNSUMMITS_WrapperNews newsWrapperTopicsFilter = SVNSUMMITS_NewsController.getNews(10,  null, null, 'Oldest First', topics[0].Name, null, null, null, null, null, null);
			System.assertEquals(newsWrapperTopicsFilter.newsList.size(), 4);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_GetNews() {

		//set NetworkId variables of the Class with hardcoded value.
		//String strNetId = '0DB36000000PB5MGAW';
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//create Topic Records
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(1001, strNetId);

		//Assign Topic to News Records
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		TopicAssignment topicAssg1 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj1.Id);
		TopicAssignment topicAssg2 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj2.Id);
		TopicAssignment topicAssg3 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj3.Id);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');
		System.runAs(u){
			Test.startTest();

			//call getNews method to filter list view on basis of date filter
			SVNSUMMITS_WrapperNews newsWrapperDateFilter = SVNSUMMITS_NewsController.getNews(10, null, null, 'Oldest First', null, null, null, null, null,
					String.valueOf(System.today().addDays(-15)), String.valueOf(System.today().addDays(15)));
			System.assertEquals(newsWrapperDateFilter.newsList.size(), 5);

			//call getNews method to filter list view on basis of date filter and topic Filter
			SVNSUMMITS_WrapperNews newsWrapperDateTopicFilter = SVNSUMMITS_NewsController.getNews(10, null, null, 'Oldest First', topics[0].Name, null, null, null, null,
					String.valueOf(System.today().addDays(-15)), String.valueOf(System.today().addDays(15)));
			System.assertEquals(newsWrapperDateTopicFilter.newsList.size(), 4);

			//Get Authors for Author dropdown in List view of news
			Map<String, String> authorMap = SVNSUMMITS_NewsController.getAuthors();
			String authorId ;
			for (String str : authorMap.keySet()) {
				authorId = str;
			}
			System.assertEquals(authorMap.size(), 1);

			//update news record show author as true
			newsObj.Show_Author__c = true;
			update newsObj;

			//call getNews method to filter list view on basis of Author filter
			SVNSUMMITS_WrapperNews newsWrapperAuthorFilter = SVNSUMMITS_NewsController.getNews(10, null, null, 'Oldest First', null, authorId, null, null, null, null, null);
			System.assertEquals(newsWrapperAuthorFilter.newsList.size(), 1);

			//call getNews to fetch records on list view with no recordid,without any filter and sorting
			SVNSUMMITS_WrapperNews newsWrapperlst = SVNSUMMITS_NewsController.getNews(2, null, null, null, null, null, null, 'None', null, null, null);

			//call nextPage method to perform next operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstnextPage = SVNSUMMITS_NewsController.nextPage(2, 1, null, null, null, null, null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperlstnextPage.newsList.size(), 2);
			System.assertEquals(2, newsWrapperlstnextPage.pageNumber);

			//call nextPage method to perform next operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstnextPage1 = SVNSUMMITS_NewsController.nextPage(2, 2, null, null, null, null, null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperlstnextPage1.newsList.size(), 1);
			System.assertEquals(3, newsWrapperlstnextPage1.pageNumber);

			//call previousPage method to perform previous operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstprevPage = SVNSUMMITS_NewsController.previousPage(2, 3, null, null, null, null, null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperlstprevPage.newsList.size(), 2);
			System.assertEquals(2, newsWrapperlstprevPage.pageNumber);

			//call previousPage method to perform previous operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstprevPage1 = SVNSUMMITS_NewsController.previousPage(2, 2, null, null, null, null, null, null, 'None', null, null, null);
			System.assertEquals(newsWrapperlstprevPage1.newsList.size(), 2);
			System.assertEquals(1, newsWrapperlstprevPage1.pageNumber);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_News() {

		//set NetworkId variables of the Class with hardcoded value.
		//String strNetId = '0DB36000000PB5MGAW';
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//Create Topic Record
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);

		//Create Community user
		//List<user> lstOfUser = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User');

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');
		System.runAs(u){
			Test.startTest();

			//Get Topics for Topic dropdown in List view of news
			Map<String, String> topicMap = SVNSUMMITS_NewsController.getTopics();
			System.assertEquals(topicMap.size(), 2);

			//call method to check if object is creatable to show hide "Add new" button on header in list view page
			SVNSUMMITS_NewsController.isObjectCreatable();

			//call method to check if object creatable and updateable to show hide edit button on detail page of news
			SVNSUMMITS_NewsController.isObjectEditable();

			//call method to get session Id of user
			String sessionId = SVNSUMMITS_NewsController.getSessionId();
			System.assertNotEquals(sessionId, null);

			//call method to get Site Prefix
			String strSitePathPrefix = SVNSUMMITS_NewsController.getSitePrefix();
			System.assertEquals(strSitePathPrefix, System.Site.getPathPrefix());

			//call method to check if "display community nick name" is true or false in community
			SVNSUMMITS_NewsController.isNicknameDisplayEnabled();

			//Get Featured News 1+4 Across
			SVNSUMMITS_WrapperNews featured14newsWrapper = SVNSUMMITS_NewsController.getFeaturedNews(newsObj.Id, newsObj1.Id, newsObj2.Id, newsObj3.Id, newsObj4.Id);
			System.assertEquals(featured14newsWrapper.newsList.size(), 5);

			//Get Featured News 3 Across
			SVNSUMMITS_WrapperNews featuredNewsWrapper = SVNSUMMITS_NewsController.getFeaturedNews(newsObj.Id, newsObj1.Id, newsObj2.Id, null, null);
			System.assertEquals(featuredNewsWrapper.newsList.size(), 3);

			//Get Featured News 3 Across with invalid Id
			SVNSUMMITS_WrapperNews featuredNewsWrapper1 = SVNSUMMITS_NewsController.getFeaturedNews(newsObj.Id, newsObj1.Id, '12343534', null, null);
			System.assertEquals(featuredNewsWrapper1.newsList.size(), 2);

			//Get News Record for detail page
			SVNSUMMITS_WrapperNews newsRecord = SVNSUMMITS_NewsController.getNewsRecord(newsObj.Id);
			System.assertEquals(newsRecord.newsList.size(), 1);

			//create new News Object to pass it to save method to create new news record
			News__c newNewsObj = new News__c(Name = 'Test New News', Details__c = 'Test Description', Publish_DateTime__c = System.today().addDays(5));

			//Call Save method to insert new News record
			SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id);
			System.assertNotEquals(newNewsObj.Id, null);

			//create Attachment related to news object created
			Attachment attach = new Attachment();
			attach.Name = 'Unit Test Attachment';
			Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
			attach.Body = bodyBlob;
			attach.ParentId = newNewsObj.Id;
			insert attach;

			//updated news records with one more topic added
			SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id + ';' + topics[1].Id);

			//Check if topic updated is assigned to news record
			TopicAssignment topicAssgnmentNew = [select Id,EntityId from TopicAssignment where TopicId = :topics[1].Id and EntityId = :newNewsObj.Id];
			System.assertNotEquals(topicAssgnmentNew.Id, null);

			//Delete attchment if user updates attchment
			SVNSUMMITS_NewsController.deleteAttachment(newNewsObj.Id);
			List<Attachment> attachment = [select Id from Attachment where ParentId = :newNewsObj.Id];
			System.assertEquals(attachment.size(), 0);

			//updated news records with by removing one topic
			SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id);

			//Check if topic assignment is deleted when it is removed on updating news record
			List<TopicAssignment> topicAssgnmentDeleted = [select Id,EntityId from TopicAssignment where TopicId = :topics[1].Id and EntityId = :newNewsObj.Id];
			System.assertEquals(topicAssgnmentDeleted.size(), 0);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_Authors() {
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//Create Topic Record
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);

		//Create Community user
		//List<user> lstOfUser = SVNSUMMITS_NewsUtilityTest.createUsers(1, '7S Customer Community Login User');

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');
		System.runAs(u){
			Test.startTest();

			//Get Authors for Author dropdown in List view of news
			Map<String, String> authorMap = SVNSUMMITS_NewsController.getAuthors();
			System.assertNotEquals(null, authorMap);

			//Get Network Members for Author dropdown in Create news Page
			Map<String, String> getUsers = SVNSUMMITS_NewsController.getUsers();
			System.debug('get users: ' + getUsers);
			System.assertNotEquals(null, getUsers);

			Map<String, String>searchUsers = SVNSUMMITS_NewsController.searchUsers('michael');
			System.debug('get users: ' + searchUsers);
			System.assertNotEquals(null, searchUsers);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_saveNewsItem() {
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');

		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		System.runAs(u) {
			Test.startTest();

			News__c news = SVNSUMMITS_NewsController.saveNewsItem(
					'News for 2',
					'<p>News text for two</p>',
					true,
					u.Id,
					'2017-06-02 17:10:00',
					'','',''
					);

			System.assert(news.Id != null);
			Test.stopTest();
		}
	}

	@IsTest
	static void test_Topics() {
		//Create Topic Record
		//List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2000);
		//Get Topics for Topic dropdown in List view of news
		//Map<String,String> topicMap = SVNSUMMITS_NewsController.getTopics();
		//System.assertEquals(topicMap.size(),2000);

		//set NetworkId variables of the Class with hardcoded value.
		//String strNetId = '0DB36000000PB5MGAW';
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		List<User> users = SVNSUMMITS_NewsUtilityTest.createUsers(1, '7S Customer Community Login User');
		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				Test.startTest();

				//Create Topic Record
				List<Topic> topics1 = SVNSUMMITS_NewsUtilityTest.createTopic(2000, strNetId);
				System.assertEquals(topics1.size(), 2000);
				//Get Topics for Topic dropdown in List view of news
				Map<String, String> topicMap1 = SVNSUMMITS_NewsController.getTopics();

				//System.assertEquals(topicMap1.size(),2000);
				Test.stopTest();
			}
		}
	}

	@IsTest
	static void test_Groups() {
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		List<User> users = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User');
		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				Test.startTest();

				Map<String, String> groupList = SVNSUMMITS_NewsController.getAllGroups();
				System.assertNotEquals(null, groupList);

				Test.stopTest();
			}
		}
	}

	@IsTest
	static void test_newsItemWithGroup() {
		String testGroup = 'Test group X7S 001';
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');

		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		System.runAs(u) {
			Test.startTest();

			Id testGroupId = SVNSUMMITS_NewsUtilityTest.createTestGroup(testGroup);
			String testGroupIdStr = (String) testGroupId;

			Map<String, String> groupList = SVNSUMMITS_NewsController.getGroups();
			System.assertNotEquals(null, groupList);

			News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNewsWithGroup(strNetId, testGroupIdStr);
			System.assertEquals(testGroupIdStr, newsObj.GroupId__c);
			System.assertEquals(false, newsObj.Private_Group__c);

			News__c newsPrivate = SVNSUMMITS_NewsUtilityTest.createNewsWithGroupPrivate(strNetId, testGroupIdStr);
			System.assertEquals(testGroupIdStr, newsPrivate.GroupId__c);
			System.assertEquals(true, newsPrivate.Private_Group__c);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_saveNewsWithGroup() {
		String testGroup = 'Test group X7S 002';
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		//Create Topic Record
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2, strNetId);

		Test.startTest();

		Id testGroupId = SVNSUMMITS_NewsUtilityTest.createTestGroup(testGroup);
		String testGroupIdStr = (String) testGroupId;

		//create new News Object to pass it to save method to create new news record
		News__c newNewsObj = new News__c(
				Name = 'Test New News',
				Details__c = 'Test Description',
				Publish_DateTime__c = System.today().addDays(5),
				GroupId__c = testGroupIdStr,
				Private_Group__c = false);

		//Call Save method to insert new News record
		News__c savedNews = SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id);
		System.assertNotEquals(savedNews.Id, null);

		SVNSUMMITS_WrapperNews newsWrapper = SVNSUMMITS_NewsController.getNewsRecord(savedNews.Id, 'true');
		System.assertNotEquals(newsWrapper.groupIdToName, null);
		System.assertEquals(testGroup, newsWrapper.groupIdToName.get(testGroupId));

		Test.stopTest();
	}

	@IsTest
	private static void test_isRecordEditable() {
		User user1 = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');
		User user2 = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');

		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strNetworkId = strNetId;

		Test.startTest();

		News__c newsObj;
		System.runAs(user1) {
			newsObj = new News__c(Name = 'Test News', Publish_DateTime__c = System.today().addDays(-5),
					Author__c = user1.Id, NetworkId__c = strNetId);
			insert newsObj;

			// Evaluates to true, user is owner of record
			System.assertEquals(true, SVNSUMMITS_NewsController.isRecordEditable(newsObj.Id));

			// Can user delete
			System.assertEquals(true, SVNSUMMITS_NewsController.isRecordDeletable(newsObj.Id));
		}

		System.runAs(user2) {
			// Evaluates to true: OWD Public Read/Write
			// Evaluates to false: OWD Private or Public Read
			System.assertEquals([
					SELECT RecordId, HasEditAccess
					FROM UserRecordAccess
					WHERE UserId = :user2.Id AND RecordId = :newsObj.Id
			].HasEditAccess,
					SVNSUMMITS_NewsController.isRecordEditable(newsObj.Id));
		}

		Test.stopTest();
	}

	@IsTest
	static void test_deleteRecord() {
		News__c adminNews = SVNSUMMITS_NewsUtilityTest.createNews();
		User u = SVNSUMMITS_NewsUtilityTest.createUsers(1, '7S Customer Community Login User')[0];

		System.runAs(u) {

			Test.startTest();

			Boolean adminAccess = SVNSUMMITS_NewsController.getUserRecordAccess(UserInfo.getUserId(), adminNews.Id).HasDeleteAccess;
			System.assertEquals(adminAccess, SVNSUMMITS_NewsController.deleteRecord(adminNews.Id));
			if (adminAccess) {
				System.assertEquals(0, [SELECT COUNT() FROM News__c WHERE Id = :adminNews.Id]);
			} else {
				System.assertEquals(1, [SELECT COUNT() FROM News__c WHERE Id = :adminNews.Id]);
			}

			if (SVNSUMMITS_NewsController.isObjectCreatable()) {
				News__c myNews = SVNSUMMITS_NewsUtilityTest.createNews();

				Boolean myAccess = SVNSUMMITS_NewsController.isRecordDeletable(myNews.Id);
				myAccess = SVNSUMMITS_NewsController.getUserRecordAccess(UserInfo.getUserId(), myNews.Id).HasDeleteAccess;

				System.assertEquals(myAccess, SVNSUMMITS_NewsController.deleteRecord(myNews.Id));

				if (myAccess) {
					System.assertEquals(0, [SELECT COUNT() FROM News__c WHERE Id = :myNews.Id]);
				} else {
					System.assertEquals(1, [SELECT COUNT() FROM News__c WHERE Id = :myNews.Id]);
				}
			}

			Test.stopTest();
		}
	}

	@IsTest
	static void test_LikeUnlikeNews(){
		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		Test.startTest();
		SVNSUMMITS_NewsController.likeNews(newsObj.Id);
		SVNSUMMITS_NewsController.likeNews(newsObj1.Id);
		SVNSUMMITS_NewsController.likeNews(newsObj2.Id);
		SVNSUMMITS_NewsController.likeNews(newsObj3.Id);
		SVNSUMMITS_NewsController.likeNews(newsObj4.Id);

		List<News_Like__c> newsLikes = [
				SELECT Id
				FROM News_Like__c
				WHERE User__c = :UserInfo.getUserId()
		];
		System.assert(newsLikes.size() == 5);

		SVNSUMMITS_NewsController.unLikeNews(newsObj.Id);
		SVNSUMMITS_NewsController.unLikeNews(newsObj1.Id);
		SVNSUMMITS_NewsController.unLikeNews(newsObj2.Id);
		SVNSUMMITS_NewsController.unLikeNews(newsObj3.Id);
		SVNSUMMITS_NewsController.unLikeNews(newsObj4.Id);

		newsLikes = [
				SELECT Id
				FROM News_Like__c
				WHERE User__c = :UserInfo.getUserId()
		];
		System.assert(newsLikes.size() == 0);

		Test.stopTest();
	}

	@IsTest
	static void test_getCurrentUser() {
		User u = SVNSUMMITS_NewsUtilityTest.createUsers(1, '7S Customer Community Login User')[0];

		System.runAs(u) {
			User usr = SVNSUMMITS_NewsController.getCurrentUser();
			System.assertNotEquals(null, usr);
		}
	}

	@IsTest
	static void test_isFollowing() {
		User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('7S Customer Community Login User');

		System.runAs(u) {
			Test.startTest();

			News__c newsItem = SVNSUMMITS_NewsUtilityTest.createNews();
			Boolean userIsFollowing = SVNSUMMITS_NewsController.isFollowing(newsItem.Id);
			System.assertEquals(false, userIsFollowing);

			userIsFollowing = SVNSUMMITS_NewsController.followRecord(newsItem.Id);
			//System.assertEquals(true, userIsFollowing);

			userIsFollowing = SVNSUMMITS_NewsController.unfollowRecord(newsItem.Id);
			//System.assertEquals(true, userIsFollowing);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_userAuthorizedToPost() {
		Boolean canPost = SVNSUMMITS_NewsController.userAuthorizedToPost();
		System.assertNotEquals(null, canPost);
		System.debug('test_userAuthorizedToPost = ' + canPost);
	}

	@IsTest
	static void test_requireGroupMembership()
	{
		Boolean requireGroup = SVNSUMMITS_NewsController.requireGroupMembership();
		System.assertNotEquals(null, requireGroup);
		System.debug('requireGroupMembership = ' + requireGroup);
	}

	@IsTest
	static void test_getNameSpacePrefix() {
		SVNSUMMITS_NewsBaseController baseController = new SVNSUMMITS_NewsBaseController();
		SVNSUMMITS_NewsBaseController.BaseModel testBaseModel = SVNSUMMITS_NewsBaseController.getModel();
		String testNameSpace = testBaseModel.namespacePrefix;
		System.debug('test namespace = ' + testNameSpace);
		System.assertNotEquals(null, baseController);
	}

	@IsTest
	static void test_getLexMode() {
		SVNSUMMITS_NewsBaseController.BaseModel testBaseModel = SVNSUMMITS_NewsBaseController.getModel();
		System.assertNotEquals(null, testBaseModel.lexMode);
	}

	@IsTest
	static void test_wrapperCtor() {
		SVNSUMMITS_WrapperNews wrapper = new SVNSUMMITS_WrapperNews('field1', 'error message');
		System.assertEquals('field1', wrapper.field);
	}

	@IsTest
	static void test_getNetworkClause()
	{
		String networkClause = SVNSUMMITS_NewsController.getNetworkClause('NetworkId__c', '', 'X1,X2');
		System.assertEquals(' NetworkId__c = \'X1\' OR NetworkId__c = \'X2\'', networkClause);

		networkClause = SVNSUMMITS_NewsController.getNetworkClause('NetworkId__c', 'X0','');
		System.assertEquals(' NetworkId__c = \'X0\'', networkClause);

		networkClause = SVNSUMMITS_NewsController.getNetworkClause('NetworkId__c', '','');
		System.assertEquals(' NetworkId__c = null', networkClause);
	}
}