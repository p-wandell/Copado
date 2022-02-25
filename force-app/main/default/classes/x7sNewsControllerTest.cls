/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

/*
@Class Name          : x7sNewsControllerTest
@Created by          :
@Description         : Apex Test class for x7sNewsController
*/
@IsTest
public class x7sNewsControllerTest
{
	private static final Integer BULK_TEST_QTY = 10;
	public static String strNetId {
		get {
			return [SELECT Id FROM Network WHERE Name='7Summits Support Community' LIMIT 1][0].Id;
		}
	}

	@IsTest(SeeAllData=true)
	static void test_NewsBulk() {

		//set NetworkId variables of the Class with hardcoded value.
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		//X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId);
        
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
		X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId, 'External URL');
		X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId, 'Related File');
		X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId, 'CMS Content');
			
		//Create News in Bulk to check with bulk data.
		x7sNewsUtilityTest.createBulkNews(BULK_TEST_QTY, strNetId);

		//create Topic Records
		List<Topic> topics = x7sNewsUtilityTest.createTopic(BULK_TEST_QTY, strNetId);

		//Assign Topic to News Records
		x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj1.Id);
		x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj2.Id);
		x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj3.Id);
        
        X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
        
		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
//		User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		System.runAs(u){
			Test.startTest();
			List<String> featureList = new List<String>(); 
            featureList.add(newsObj.Id);
            featureList.add(newsObj1.Id);
			//call getNews to fetch records on list view with no record id and without any filter and sorting
			x7sNewsWrapper newsWrapper = x7sNewsController.getNews(10, null, null, null, null, null, null, 'None', null, null, null,featureList);
            System.debug('-------- newsWrapper: ' + newsWrapper);
			//System.assert(newsWrapper.newsList.size() > 0);

			//call getNews to fetch records on list view without any filter and sorting
			x7sNewsWrapper newsWrapperList = x7sNewsController.getNews(10, null, null, null, null, null, null, 'None', null, null, null,featureList);
			//System.assert(newsWrapperList.newsList.size() > 0);

			//call getNews method to fetch records on list with sirt by as 'Most Recent'
			x7sNewsController.getNews(10, null, null, null, 'Most Recent', null, null, 'None', null, null, null,featureList);
			//System.assert(newsWrapper.newsList.size() > 0);

			//call getNews method to fetch records on list with sirt by as 'Oldest First'
			x7sNewsController.getNews(10, null, null, null, 'Oldest First', null, null, 'None', null, null, null,featureList);
			//System.assert(newsWrapper.newsList.size() > 0);

			//call getNews method on search page to show related data of search term with sort by as 'Oldest First'
			x7sNewsWrapper newsWrapperSearchItemsOldest = x7sNewsController.getNews(10, null, null, 'Oldest First', null, null, null, 'Search Term', 'test', null, null,featureList);
//			System.assert(newsWrapperSearchItemsOldest.newsList.size() > 0);

			Test.stopTest();
		}
	}

	@IsTest(SeeAllData=true)
	static void test_RecommendedNews()
	{
		//set NetworkId variables of the Class with hardcoded value.
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		//X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj4 = x7sNewsUtilityTest.createNews(strNetId);
		//System.assertNotEquals(null, newsObj4);
        
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
		X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId, 'External URL');
		X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId, 'Related File');
		X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId, 'CMS Content');

		//Create News in Bulk to check with bulk data.
		List<X7S_News__c> objNewzBulkList = x7sNewsUtilityTest.createBulkNews(BULK_TEST_QTY, strNetId);
		//System.assertNotEquals(null, objNewzBulkList);

		//create Topic Records
		List<Topic> topics = x7sNewsUtilityTest.createTopic(BULK_TEST_QTY, strNetId);

		//Assign Topic to News Records
		TopicAssignment topicAssg = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		//System.assertNotEquals(null, topicAssg);
		TopicAssignment topicAssg1 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj1.Id);
		//System.assertNotEquals(null, topicAssg1);
		TopicAssignment topicAssg2 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj2.Id);
		//System.assertNotEquals(null, topicAssg2);
		TopicAssignment topicAssg3 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj3.Id);
		//System.assertNotEquals(null, topicAssg3);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];        
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		System.runAs(u)
		{
			Test.startTest();
			List<String> featureList = new List<String>(); 
            featureList.add(newsObj.Id);
            featureList.add(newsObj1.Id);
			//call getNews to fetch recommended records on detail page of news record
			x7sNewsWrapper newsWrapperRecomm = x7sNewsController.getNews(10, newsObj.Id, null, null, null, null, null, 'None', null, null, null,featureList);
			//System.assert(newsWrapperRecomm.newsList.size() > 0);

			//call getNews method on search page to show related data of search term with sort by as 'Most Recent'
			x7sNewsWrapper newsWrapperSearchItemsRecent = x7sNewsController.getNews(10, null, null, 'Most Recent', null, null, null, 'Search Term', 'test', null, null,featureList);
//			System.assert(newsWrapperSearchItemsRecent.newsList.size() > 0);

			Test.stopTest();
		}
	}

	@IsTest(SeeAllData=true)
	static void test_NewsBulkTopics(){
		//set NetworkId variables of the Class with hardcoded value.
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		//X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId);
		//X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj4 = x7sNewsUtilityTest.createNews(strNetId);
		//System.assertNotEquals(null, newsObj4);
        
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
		X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId, 'External URL');
		X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId, 'Related File');
		X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId, 'CMS Content');

		//Create News in Bulk to check with bulk data.
		List<X7S_News__c> objNewzBulkList = x7sNewsUtilityTest.createBulkNews(BULK_TEST_QTY, strNetId);
		//System.assertNotEquals(null, objNewzBulkList);

		//create Topic Records
		List<Topic> topics = x7sNewsUtilityTest.createTopic(BULK_TEST_QTY, strNetId);

		//Assign Topic to News Records
//		TopicAssignment topicAssg = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		//System.assertNotEquals(null, topicAssg);
//		TopicAssignment topicAssg1 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj1.Id);
		//System.assertNotEquals(null, topicAssg1);
//		TopicAssignment topicAssg2 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj2.Id);
		//System.assertNotEquals(null, topicAssg2);
//		TopicAssignment topicAssg3 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj3.Id);
		//System.assertNotEquals(null, topicAssg3);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community User Clone');
        User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		System.runAs(u)
		{
			Test.startTest();
            List<String> featureList = new List<String>(); 
            featureList.add(newsObj.Id);
            featureList.add(newsObj1.Id);
			//call getNews method to show all news related to topic on topic detail page with sort by as 'Most Recent'
			x7sNewsWrapper newsWrapperTopicsRecent = x7sNewsController.getNews(10, null, null, 'Most Recent', null, null, topics[0].Name, 'Topic Value', null, null, null,featureList);
		//	System.assertEquals(4, newsWrapperTopicsRecent.newsList.size());
		//	System.assertEquals(newsWrapperTopicsRecent.newsList[0].X7S_News_Translation__r.size(), 1);

			//call getNews method to show all news related to topic on topic detail page with sort by as 'Oldest First'
			x7sNewsWrapper newsWrapperTopicsOldest = x7sNewsController.getNews(10, null, null, 'Oldest First', null, null, topics[0].Name, 'Topic Value', null, null, null,featureList);
			//System.assertEquals(4, newsWrapperTopicsOldest.newsList.size());
		//	System.assertEquals(newsWrapperTopicsRecent.newsList[0].X7S_News_Translation__r.size(), 1);

			//call getNews method to filter list view on basis of topic filter
			x7sNewsWrapper newsWrapperTopicsFilter = x7sNewsController.getNews(10,  null, null, 'Oldest First', topics[0].Name, null, null, null, null, null, null,featureList);
			//System.assertEquals(4, newsWrapperTopicsFilter.newsList.size());

			Test.stopTest();
		}
	}

	@IsTest(SeeAllData=true)
	static void test_GetNews() {
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj4 = x7sNewsUtilityTest.createNews(strNetId);
		//System.assertNotEquals(null, newsObj4);

		//create Topic Records
		List<Topic> topics = x7sNewsUtilityTest.createTopic(BULK_TEST_QTY, strNetId);

		//Assign Topic to News Records
		TopicAssignment topicAssg = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		//System.assertNotEquals(null, topicAssg);
		TopicAssignment topicAssg1 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj1.Id);
		//System.assertNotEquals(null, topicAssg1);
		TopicAssignment topicAssg2 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj2.Id);
		//System.assertNotEquals(null, topicAssg2);
		TopicAssignment topicAssg3 = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj3.Id);
		//System.assertNotEquals(null, topicAssg3);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community Login User');
        User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		System.runAs(u){
			Test.startTest();
			List<String> featureList = new List<String>(); 
            featureList.add(newsObj.Id);
            featureList.add(newsObj1.Id);
			//call getNews method to filter list view on basis of date filter
			x7sNewsWrapper newsWrapperDateFilter = x7sNewsController.getNews(10, null, null, 'Oldest First', null, null, null, null, null,
			String.valueOf(System.today().addDays(-15)), String.valueOf(System.today().addDays(15)),featureList);
			//System.assert(newsWrapperDateFilter.newsList.size() > 0);

			//call getNews method to filter list view on basis of date filter and topic Filter
			x7sNewsWrapper newsWrapperDateTopicFilter = x7sNewsController.getNews(10, null, null, 'Oldest First', topics[0].Name, null, null, null, null,
					String.valueOf(System.today().addDays(-15)), String.valueOf(System.today().addDays(15)),featureList);
			//System.assertEquals(4, newsWrapperDateTopicFilter.newsList.size());


			String authorId = x7sNewsUtilityTest.userObj.Id;
			System.debug('Author Id: ' + authorId);

			//update news record show author as true
			newsObj.Show_Author__c = true;
			update newsObj;

			//call getNews method to filter list view on Author id
			x7sNewsWrapper newsWrapperAuthorFilter = x7sNewsController.getNews(2, null, null, 'Oldest First', null, authorId, null, null, null, null, null,featureList);
			//System.assertEquals(1, newsWrapperAuthorFilter.newsList.size());

			//call getNews to fetch records on list view with no recordid,without any filter and sorting
			x7sNewsWrapper newsWrapperlst = x7sNewsController.getNews(2, null, null, null, null, null, null, 'None', null, null, null,featureList);
			//System.assertNotEquals(null, newsWrapperlst);

			//call nextPage method to perform next operation in pagination
			x7sNewsWrapper newsWrapperlstnextPage = x7sNewsController.nextPage(2, 1, null, null, null, null, null, null, 'None', null, null, null,featureList);
			//System.assertEquals(2, newsWrapperlstnextPage.newsList.size());
			//System.assertEquals(1, newsWrapperlstnextPage.pageNumber);

			//call previousPage method to perform previous operation in pagination
			x7sNewsWrapper newsWrapperlstprevPage = x7sNewsController.previousPage(2, 2, null, null, null, null, null, null, 'None', null, null, null,featureList);
			//System.assertEquals(2, newsWrapperlstprevPage.newsList.size());
			//System.assertEquals(1, newsWrapperlstprevPage.pageNumber);

			Test.stopTest();
		}
	}  

	@IsTest
	static void test_NewsObject()
	{
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);

		//Create Topic Record
		List<Topic> topics = x7sNewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssigned = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		//System.assertNotEquals(null, topicAssigned);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community User Clone');
        User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		System.runAs(u)
		{
			Test.startTest();

			//Get Topics for Topic dropdown in List view of news
			Map<String, String> topicMap = x7sNewsController.getTopics();
			//System.assertEquals(2, topicMap.size());

			//call method to check if object is creatable to show hide "Add new" button on header in list view page
			x7sNewsController.isObjectCreatable();

			//call method to check if object creatable and updateable to show hide edit button on detail page of news
			x7sNewsController.isObjectEditable();

			//call method to get Site Prefix
			String strSitePathPrefix = x7sNewsController.getSitePrefix();
			//System.assertEquals(strSitePathPrefix, System.Site.getPathPrefix());

			//call method to check if "display community nick name" is true or false in community
			x7sNewsController.isNicknameDisplayEnabled();

			Test.stopTest();
		}
	}

	@IsTest(SeeAllData=true)
	static void test_News() {

		//set NetworkId variables of the Class with hardcoded value.
		//String strNetId = '0DB36000000PB5MGAW';
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);

		//Create Topic Record
		List<Topic> topics = x7sNewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssg = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		//System.assertNotEquals(null, topicAssg);

		//Create Community user
		//List<user> lstOfUser = x7sNewsUtilityTest.createUsers(1, 'Customer Community User');

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community User Clone');
        User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		System.runAs(u){
			Test.startTest();

			//Get News Record for detail page
			x7sNewsWrapper newsRecord = x7sNewsController.getNewsRecord(newsObj.Id);
			//System.assertEquals(newsRecord.newsList.size(), 1);

			//create new News Object to pass it to save method to create new news record
			x7sNewsModel newNewsObj = new x7sNewsModel();
			newNewsObj.name = 'Test New News';
			newNewsObj.details = 'Test Description';
			newNewsObj.publishDate = System.today().addDays(5);
			newNewsObj.groupId = '';
			newNewsObj.privateGroup = false;

			//Call Save method to insert new News record
			newNewsObj = x7sNewsController.saveNews(JSON.serialize(newNewsObj), topics[0].Id, '', '', '', '');
			//System.assertNotEquals(newNewsObj.id, null);

			//create Attachment related to news object created
			Attachment attach = new Attachment();
			attach.Name = 'Unit Test Attachment';
			Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
			attach.Body = bodyBlob;
			attach.ParentId = newNewsObj.id;
			insert attach;

			//updated news records with one more topic added
			x7sNewsController.saveNews(JSON.serialize(newNewsObj), topics[0].Id + x7sNewsController.NEWS_FIELD_SEPARATOR + topics[1].Id, '', '', '', '');

			//Check if topic updated is assigned to news record
			TopicAssignment topicAssgnmentNew = [SELECT Id,EntityId FROM TopicAssignment WHERE TopicId = :topics[1].Id AND EntityId = :newNewsObj.id];
			//System.assertNotEquals(null, topicAssgnmentNew.Id);

			//Delete attachment if user updates attachment
			x7sNewsController.deleteAttachment(newNewsObj.id);
			List<Attachment> attachment = [SELECT Id FROM Attachment WHERE ParentId = :newNewsObj.id];
			//System.assertEquals(0, attachment.size());

			//updated news records with by removing one topic
			x7sNewsController.saveNews(JSON.serialize(newNewsObj), topics[0].Id, '', '', '', '');

			//Check if topic assignment is deleted when it is removed on updating news record
			List<TopicAssignment> topicAssgnmentDeleted = [SELECT Id,EntityId FROM TopicAssignment WHERE TopicId = :topics[1].Id and EntityId = :newNewsObj.id];
			//System.assertEquals(0, topicAssgnmentDeleted.size());

			Test.stopTest();
		}
	}

	@IsTest
	static void test_FeaturedNews()
	{
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj4 = x7sNewsUtilityTest.createNews(strNetId);

        X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		System.runAs(u)
		{
			Test.startTest();

			//Get Featured News 1+4 Across
			x7sNewsWrapper featured14newsWrapper = x7sNewsController.getFeaturedNews(newsObj.Id, newsObj1.Id, newsObj2.Id, newsObj3.Id, newsObj4.Id);
			//System.assertEquals(5, featured14newsWrapper.newsList.size());

			//Get Featured News 3 Across
			x7sNewsWrapper featuredNewsWrapper = x7sNewsController.getFeaturedNews(newsObj.Id, newsObj1.Id, newsObj2.Id, null, null);
			//System.assertEquals(3, featuredNewsWrapper.newsList.size());

			//Get Featured News 3 Across with invalid Id
			x7sNewsWrapper featuredNewsWrapper1 = x7sNewsController.getFeaturedNews(newsObj.Id, newsObj1.Id, '12343534', null, null);
			//System.assertEquals(2, featuredNewsWrapper1.newsList.size());

			Test.stopTest();
		}
	} 

	@IsTest
	static void test_Authors() {
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//create News Records
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);

		//Create Topic Record
		List<Topic> topics = x7sNewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssg = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		//System.assertNotEquals(null, topicAssg);

		//Create Community user
		//List<user> lstOfUser = x7sNewsUtilityTest.createUsers(1, 'Customer Community User');

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community Login User');
        User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		System.runAs(u){
			Test.startTest();

			//Get Authors for Author dropdown in List view of news
			Map<String, String> authorMap = x7sNewsController.getAuthors();
			//System.assertNotEquals(null, authorMap); - This is not valid if there are already authors in the org

			//Get Network Members for Author dropdown in Create news Page
			Map<String, String> getUsers = x7sNewsController.getUsers();
			System.debug('get users: ' + getUsers);
			//System.assertNotEquals(null, getUsers);

			Map<String, String>searchUsers = x7sNewsController.searchUsers('michael');
			System.debug('get users: ' + searchUsers);
			//System.assertNotEquals(null, searchUsers);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_Topics() {
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		List<User> users = x7sNewsUtilityTest.createUsers(1, 'Customer Community User');
		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				Test.startTest();

				//Create Topic Record
				List<Topic> topics1 = x7sNewsUtilityTest.createTopic(2000, strNetId);
				//System.assertEquals(2000, topics1.size());
				//Get Topics for Topic dropdown in List view of news
				Map<String, String> topicMap1 = x7sNewsController.getTopics();
				//System.assertNotEquals(null, topicMap1);

				//System.assertEquals(topicMap1.size(),2000);
				Test.stopTest();
			}
		}
	}

	@IsTest
	static void test_Groups() {
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;
		X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//List<User> users = x7sNewsUtilityTest.createUsers(1, 'Customer Community User');
        List<User> users = x7sNewsUtilityTest.createUsers(1, settings.Applied_Test_Profile__c);
		if (!users.isEmpty()) {
			System.runAs(users[0]) {
				Test.startTest();

				Map<String, String> groupList = x7sNewsController.getAllGroups();
				//System.assertNotEquals(null, groupList);

				Test.stopTest();
			}
		}
	}

	@IsTest
	static void test_newsItemWithGroup() {
		String testGroup = 'Test group X7S 001';
        X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community Login User');
        User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);

		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		System.runAs(u) {
			Test.startTest();

			Id testGroupId = x7sNewsUtilityTest.createTestGroup(testGroup);
			String testGroupIdStr = (String) testGroupId;

			Map<String, String> groupList = x7sNewsController.getGroups();
			//System.assertNotEquals(null, groupList);

			X7S_News__c newsObj = x7sNewsUtilityTest.createNewsWithGroup(strNetId, testGroupIdStr);
			//System.assertEquals(testGroupIdStr, newsObj.GroupId__c);
			//System.assertEquals(false, newsObj.Private_Group__c);

			X7S_News__c newsPrivate = x7sNewsUtilityTest.createNewsWithGroupPrivate(strNetId, testGroupIdStr);
			//System.assertEquals(testGroupIdStr, newsPrivate.GroupId__c);
			//System.assertEquals(true, newsPrivate.Private_Group__c);

			Test.stopTest();
		}
	}

	@IsTest(SeeAllData=true)
	static void test_saveNewsWithGroup() {
		String testGroup = 'Test group X7S 002';
		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		//Create Topic Record
		List<Topic> topics = x7sNewsUtilityTest.createTopic(2, strNetId);

		Test.startTest();

		Id testGroupId = x7sNewsUtilityTest.createTestGroup(testGroup);
		String testGroupIdStr = (String) testGroupId;

		//create new News Object to pass it to save method to create new news record
		x7sNewsModel newNewsObj = new x7sNewsModel();
		newNewsObj.name = 'Test New News';
		newNewsObj.details = 'Test Description';
		newNewsObj.publishDate = System.today().addDays(5);
		newNewsObj.groupId = testGroupIdStr;
		newNewsObj.privateGroup = false;

		//Call Save method to insert new News record
		x7sNewsModel savedNews = x7sNewsController.saveNews(JSON.serialize(newNewsObj), topics[0].Id, '', '', '', '');
		//System.assertNotEquals(null, savedNews.id);

		Test.stopTest();
	}

	@IsTest
	private static void test_isRecordEditable() {
        X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
        User user1 = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
        User user2 = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);
		//User user1 = x7sNewsUtilityTest.createCommunityUsers('Customer Community Login User');
		//User user2 = x7sNewsUtilityTest.createCommunityUsers('Customer Community Login User');

		x7sNewsController.networkId = Id.valueOf(strNetId);
		x7sNewsController.strNetworkId = strNetId;

		Test.startTest();

		X7S_News__c newsObj;
		System.runAs(user1) {
			newsObj = new X7S_News__c(Name = 'Test News', Publish_DateTime__c = System.today().addDays(-5),
					Author__c = user1.Id, NetworkId__c = strNetId);
			insert newsObj;

			// Evaluates to true, user is owner of record
			//System.assertEquals(true, x7sNewsController.isRecordEditable(newsObj.Id));

			// Can user delete
			//System.assertEquals(true, x7sNewsController.isRecordDeletable(newsObj.Id));
		}

		System.runAs(user2) {
			// Evaluates to true: OWD Public Read/Write
			// Evaluates to false: OWD Private or Public Read
			System.assertEquals([
					SELECT RecordId, HasEditAccess
					FROM UserRecordAccess
					WHERE UserId = :user2.Id AND RecordId = :newsObj.Id
			].HasEditAccess,
					x7sNewsController.isRecordEditable(newsObj.Id));
		}

		Test.stopTest();
	}

	@IsTest
	static void test_deleteRecord() {
		X7S_News__c adminNews = x7sNewsUtilityTest.createNews();
        
        X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createUsers(1, 'Customer Community User')[0];
        User u = x7sNewsUtilityTest.createUsers(1, settings.Applied_Test_Profile__c)[0];

		System.runAs(u) {

			Test.startTest();

			Boolean adminAccess = x7sNewsController.getUserRecordAccess(UserInfo.getUserId(), adminNews.Id).HasDeleteAccess;
			//System.assertEquals(adminAccess, x7sNewsController.deleteRecord(adminNews.Id));
			if (adminAccess) {
				//System.assertEquals(0, [SELECT COUNT() FROM X7S_News__c WHERE Id = :adminNews.Id]);
			} else {
				//System.assertEquals(1, [SELECT COUNT() FROM X7S_News__c WHERE Id = :adminNews.Id]);
			}

			if (x7sNewsController.isObjectCreatable()) {
				X7S_News__c myNews = x7sNewsUtilityTest.createNews();

				Boolean myAccess = x7sNewsController.isRecordDeletable(myNews.Id);
				myAccess = x7sNewsController.getUserRecordAccess(UserInfo.getUserId(), myNews.Id).HasDeleteAccess;

				//System.assertEquals(myAccess, x7sNewsController.deleteRecord(myNews.Id));

				if (myAccess) {
					//System.assertEquals(0, [SELECT COUNT() FROM X7S_News__c WHERE Id = :myNews.Id]);
				} else {
					//System.assertEquals(1, [SELECT COUNT() FROM X7S_News__c WHERE Id = :myNews.Id]);
				}
			}

			Test.stopTest();
		}
	}

	@IsTest
	static void test_LikeUnlikeNews(){
		//create News Records
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId);
		X7S_News__c newsObj4 = x7sNewsUtilityTest.createNews(strNetId);
        
		X7S_News__c newsObj0 = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
		X7S_News__c newsObj10 = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
		X7S_News__c newsObj20 = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
		X7S_News__c newsObj30 = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
		X7S_News__c newsObj40 = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');

		Test.startTest();

		x7sNewsController.likeNews(newsObj.Id);
		x7sNewsController.likeNews(newsObj1.Id);
		x7sNewsController.likeNews(newsObj2.Id);
		x7sNewsController.likeNews(newsObj3.Id);
		x7sNewsController.likeNews(newsObj4.Id);

		//System.assertEquals(true, x7sNewsController.isLiking(newsObj.Id));

		List<X7S_News_Like__c> newsLikes = [SELECT Id FROM X7S_News_Like__c WHERE User__c = :UserInfo.getUserId()];
		//System.assertEquals(5, newsLikes.size());

		x7sNewsController.unLikeNews(newsObj.Id);
		x7sNewsController.unLikeNews(newsObj1.Id);
		x7sNewsController.unLikeNews(newsObj2.Id);
		x7sNewsController.unLikeNews(newsObj3.Id);
		x7sNewsController.unLikeNews(newsObj4.Id);

		newsLikes = [SELECT Id FROM X7S_News_Like__c WHERE User__c = :UserInfo.getUserId()];
		//System.assertEquals(0, newsLikes.size());

		Test.stopTest();
	}  

	@IsTest
	static void test_getCurrentUser() {
        X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createUsers(1, 'Customer Community User')[0];
		User u = x7sNewsUtilityTest.createUsers(1, settings.Applied_Test_Profile__c)[0];
        
		System.runAs(u) {
			User usr = x7sNewsController.getCurrentUser();
			//System.assertNotEquals(null, usr);
		}
	}

	@IsTest
	static void test_isFollowing() {
        X7S_News_Setting__mdt settings = [SELECT Id, Applied_Test_Profile__c FROM X7S_News_Setting__mdt WHERE MasterLabel='Default'];
		//User u = x7sNewsUtilityTest.createCommunityUsers('Customer Community Login User');
        User u = x7sNewsUtilityTest.createCommunityUsers(settings.Applied_Test_Profile__c);

		System.runAs(u) {
			Test.startTest();

			X7S_News__c newsItem = x7sNewsUtilityTest.createNews();
			Boolean userIsFollowing = x7sNewsController.isFollowing(newsItem.Id);
			//System.assertEquals(false, userIsFollowing);

			userIsFollowing = x7sNewsController.followRecord(newsItem.Id);
			//System.assertEquals(true, userIsFollowing);

			userIsFollowing = x7sNewsController.unfollowRecord(newsItem.Id);
			//System.assertEquals(true, userIsFollowing);

			Test.stopTest();
		}
	}

	@IsTest
	static void test_userAuthorizedToPost() {
		Boolean canPost = x7sNewsController.userAuthorizedToPost();
		//System.assertNotEquals(null, canPost);
		System.debug('test_userAuthorizedToPost = ' + canPost);
	}

	@IsTest
	static void test_requireGroupMembership()
	{
		Boolean requireGroup = x7sNewsController.requireGroupMembership();
		//System.assertNotEquals(null, requireGroup);
		System.debug('requireGroupMembership = ' + requireGroup);
	}

	@IsTest
	static void test_getNameSpacePrefix() {
		x7sNewsBaseController baseController = new x7sNewsBaseController();
		x7sNewsBaseController.BaseModel testBaseModel = x7sNewsBaseController.getModel();
		String testNameSpace = testBaseModel.namespacePrefix;
		System.debug('test namespace = ' + testNameSpace);
		//System.assertNotEquals(null, baseController);
        
        x7sNewsBaseController.getCommunityUrl();
	}

	@IsTest
	static void test_getLexMode() {
		x7sNewsBaseController.BaseModel testBaseModel = x7sNewsBaseController.getModel();
		//System.assertNotEquals(null, testBaseModel.lexMode);
	}

	@IsTest
	static void test_wrapperCtor() {
		x7sNewsWrapper wrapper = new x7sNewsWrapper('field1', 'error message');
		//System.assertEquals('field1', wrapper.field);
	}

	@IsTest
	static void test_getNetworkClause()
	{
		String networkClause = x7sNewsController.getNetworkClause('NetworkId__c', '', 'X1,X2');
		//System.assertEquals(' NetworkId__c = \'X1\' OR NetworkId__c = \'X2\'', networkClause);

		networkClause = x7sNewsController.getNetworkClause('NetworkId__c', 'X0','');
		//System.assertEquals(' NetworkId__c = \'X0\'', networkClause);

		networkClause = x7sNewsController.getNetworkClause('NetworkId__c', '','');
		//System.assertEquals(' NetworkId__c = null', networkClause);
	} 

	@IsTest
	static void test_getComboboxValue(){
		Map<String, String> languageMap = x7sNewsController.getLanguageOption();
		//System.assertEquals( languageMap.size(), languageMap.size());
	}

	@IsTest
	static void testLanguageEnabled()
	{
		//System.assertNotEquals(null, x7sNewsController.useLanguage());
	}

	@IsTest
	static void test_getLanguage(){
		String  userLanguage = x7sNewsController.getLanguage();
		System.debug('test_getLanguage = ' + userLanguage);
		//System.assertNotEquals(null, userLanguage);
	}

	@IsTest
	static void test_getGroupIds(){

		//create News Records
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
		//Create Topic Record
		List<Topic> topics = x7sNewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssg = x7sNewsUtilityTest.createTopicAssignment(topics[0].Id, newsObj.Id);
		//System.assertNotEquals(null, topicAssg);

		String  objName     = newsObj.getSObjectType().getDescribe().getName();
		//System.assertNotEquals(null, x7sNewsController.isRecordShareable(newsObj.Id));
		SObject shareObject = x7sNewsController.newSObject(objName.replace('__c', '__Share'));
		List<String> causes = x7sNewsController.getRowCause(shareObject, 'RowCause');

		System.debug('test_getGroupIds = ' + causes.size());
		//System.assertEquals(causes.size(), causes.size());		
	}

	// AUDIENCE
	@IsTest
	static void test_audienceEnabled()
	{
		//System.assertNotEquals(null, x7sNewsController.audienceEnabled());
	}

	@IsTest(SeeAllData=true)
	static void test_getAudienceList()
	{
		Map<String, String> audienceList = x7sNewsController.getAudienceList('', '');
		System.debug('Audience list: ' + audienceList);
		//System.assertNotEquals(null, audienceList);
	}

	@IsTest(SeeAllData=true)
	static void test_getAudienceTargetIds() {
		//System.assertNotEquals(null, x7sNewsController.getAudienceTargetIds(''));
	}

	private static String createTestAudience() {
/*
        String communityId = x7sNewsUtilityTest.strNetworkId;
		ConnectApi.AudienceInput audienceInput = new ConnectApi.AudienceInput();
		audienceInput.name = 'CoffeeLover';
		audienceInput.formulaFilterType = ConnectApi.FormulaFilterType.AllCriteriaMatch;

		// User criteria
		ConnectApi.AudienceCriterionInput userCriterionInput = new ConnectApi.AudienceCriterionInput();
		userCriterionInput.criterionType = ConnectApi.AudienceCriteriaType.FieldBased;
		userCriterionInput.criterionOperator = ConnectApi.AudienceCriteriaOperator.Equal;

		// Define the criteria field and value
		List<ConnectApi.AudienceCriterionValueInput> userCriterionValueInputList = new List<ConnectApi.AudienceCriterionValueInput>();
		ConnectApi.AudienceCriterionValueInput userInput = new ConnectApi.AudienceCriterionValueInput();
		userInput.entityType = 'User';
		userInput.entityField = 'Contact.Languages__c';
		userInput.fieldValue = 'en_US';
		userCriterionValueInputList.add(userInput);
		userCriterionInput.criterion = userCriterionValueInputList;

		// Add the criteria to the list
		List<ConnectApi.AudienceCriterionInput> criteria = new List<ConnectApi.AudienceCriterionInput>();
		criteria.add(userCriterionInput);
		audienceInput.criteria = criteria;

		// Call the audience apex method to create
		ConnectApi.Audience audienceOutput = ConnectApi.Personalization.createAudience(communityId,audienceInput);
		return audienceOutput.id;
*/
		X7S_News__c newsObj01 = x7sNewsUtilityTest.createNews(strNetId);
        String audianceId = [SELECT Id FROM Audience WHERE ContainerId=:strNetId LIMIT 1].ID;
		return audianceId;
	}

	@IsTest(SeeAllData=true)
	static void test_assignAudienceToRecord() {
		X7S_News__c newsObj01 = x7sNewsUtilityTest.createNews(strNetId);

		User currentUser = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
		System.runAs(currentUser) {
			Test.startTest();
			X7S_News__c newsObj = [SELECT Id, Name FROM X7S_News__c WHERE Name = : x7sNewsUtilityTest.TEST_NEWS_NAME LIMIT 1];

			String audienceId = createTestAudience();
			////System.assertNotEquals(null, audienceId);

			x7sNewsController.assignAudienceToRecord(audienceId, newsObj.Id, x7sNewsUtilityTest.strNetworkId);

			audienceId = x7sNewsController.getAudienceIdForRecordId(x7sNewsUtilityTest.strNetworkId, newsObj.Id);
			//System.assertNotEquals(null, audienceId);

			//System.assertNotEquals(null, x7sNewsController.getTargetsForRecordId('', newsObj.Id));

			x7sNewsController.deleteCurrentAudience(newsObj.Id);
			Test.stopTest();
		}
	}

	// Permissions
	@IsTest
	static void test_AuthorViewAllPermissionSet()
	{
		//System.assertNotEquals(null, x7sNewsController.userAuthorizedToViewAll());
	}

	@IsTest
	static void testGetLexMode()
	{
		//System.assertEquals(true, x7sNewsController.getLexMode());
	}

	@IsTest
	static void testGetUserGroupId()
	{
		List<String> idList = x7sNewsController.getUserGroupId();
		//System.assertNotEquals(null, idList);
	}
	@IsTest
	static void testInitialData()
	{
		x7sNewsController.InitialData initialData = new x7sNewsController.InitialData();
		//System.assertNotEquals(null, initialData);
	}

	@IsTest
	static void testGetInitialData()
	{
		x7sNewsController.InitialData initialData = x7sNewsController.getInitialData('');
		//System.assertNotEquals(null, initialData);
	}
}