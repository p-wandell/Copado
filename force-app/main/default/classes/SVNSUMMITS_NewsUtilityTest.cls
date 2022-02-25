/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_NewsUtilityTest
@Created by          :
@Description         : Apex Utility class used for creating test records
*/
@isTest
global class SVNSUMMITS_NewsUtilityTest
{

	global static User userObj = createUser();
	//global static String strNetworkId = '0DB36000000PB5MGAW';

	global static String strNetworkId
	{
		get
		{
			return [SELECT Id FROM Network LIMIT 1][0].Id;
		}
	}

	//create News__c record
	global static News__c createNews()
	{
		News__c newsObj = new News__c(
			Name = 'Test News',
			Publish_DateTime__c = System.today().addDays(-5),
			Author__c = userObj.Id,
			NetworkId__c = strNetworkId);

		System.assertNotEquals(null, newsObj);
		insert newsObj;
		return newsObj;
	}

	//create News__c record with the NetworkID
	global static News__c createNews(String strNetId)
	{
		News__c newsObj = new News__c(Name = 'Test News', Publish_DateTime__c = System.today().addDays(-5),
			Author__c = userObj.Id, NetworkId__c = strNetId);

		System.assertNotEquals(null, newsObj);
		insert newsObj;
		return newsObj;
	}

	global static News__c createNewsWithGroup(String strNetId, String groupId)
	{
		News__c newsObj = new News__c(Name = 'Test News', Publish_DateTime__c = System.today().addDays(-5),
			Author__c = userObj.Id, NetworkId__c = strNetId, GroupId__c = groupId);

		System.assertNotEquals(null, newsObj);
		insert newsObj;

		return newsObj;
	}

	global static News__c createNewsWithGroupPrivate(String strNetId, String groupId)
	{
		News__c newsObj = new News__c(
			Name = 'Test News',
			Publish_DateTime__c = System.today().addDays(-5),
			Author__c = userObj.Id,
			NetworkId__c = strNetId,
			GroupId__c = groupId,
			Private_Group__c = true);

		System.assertNotEquals(null, newsObj);
		insert newsObj;

		return newsObj;
	}

	//create News__c record for the Bulk Insertion check
	global static List<News__c> createBulkNews(Integer howmany, String strNetId)
	{
		List<News__c> objNewzList = new List<News__c>();

		for (Integer i = 0; i < howmany; i++)
		{
			News__c newsObj = new News__c(Name = 'Test News' + i, Publish_DateTime__c = System.today().addDays(-5),
				Author__c = userObj.Id, NetworkId__c = strNetId);

			objNewzList.add(newsObj);
		}

		System.assertNotEquals(null, objNewzList);
		insert objNewzList;
		return objNewzList;
	}

	//create Topic record
	global static Topic createTopic()
	{

		return null;
	}

	//Create Topics in Bulk with the Network Id
	global static List<Topic> createTopic(Integer howMany, String strNetId)
	{
		List<Topic> topics = new List<Topic>();

		for (Integer i = 0; i < howMany; i++)
		{
			Topic topicObj = new Topic(Name = 'Test Topic' + i, Description = 'Test Topic', NetworkId = strNetId);
			topics.add(topicObj);
		}

		if (!topics.isEmpty())
		{
			insert topics;
		}
		System.assertNotEquals(null, topics);
		return topics;
	}

	//Assign Topic , create TopicAssignment with TopicId and entittId to which topic is to be assigned
	global static TopicAssignment createTopicAssignment(String strTopicId, String strEntityId)
	{
		TopicAssignment topicAssigmnt = new TopicAssignment(EntityId = strEntityId, TopicId = strTopicId);

		System.assertNotEquals(null, topicAssigmnt);

		insert topicAssigmnt ;
		return topicAssigmnt ;
	}

	//create user record
	global static User createUser()
	{
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
//		Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community User'];

		User u = new User(Alias = 'standt', Email = 'standarduser123@testorg.com',
			EmailEncodingKey = 'UTF-8', LastName = 'stand user', LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US', ProfileId = p.Id,
			TimeZoneSidKey = 'America/Los_Angeles', Username = 'standarduser1234@testorg.com');

		System.assertNotEquals(null, u);

		insert u;
		return u;
	}

	//Create User with given Profile name
	global static List<User> createUsers(Integer howMany, String profileName)
	{
		System.debug('Creating ' + howMany + ' users for profile ' + profileName);
		Account a = new Account(Name = 'TestAccount123') ;
		insert a;

		List<Contact> listOfContacts = new List<Contact>();
		Map<Integer, Contact> mapCont = new Map<Integer, Contact>();

		for (Integer i = 0; i < howMany; i++)
		{
			Contact c = new Contact(LastName = 'testCon' + i, AccountId = a.Id, Industry_Type__c = 'Government', Lead_Source__c = 'Referral');
			listOfContacts.add(c);
			mapCont.put(i, c);
		}
		insert listOfContacts;

		// by default bidders
		Id profileId;
		// to make user unique
		String type = 'com';
		Boolean useContact = true;

		if(DEFAULT_PROFILE_NAME != null)
		{
			System.debug('createCommunityUsers - Create user with ' + DEFAULT_PROFILE_NAME + ' profile');
			Profile p  = [SELECT Id, Name FROM Profile WHERE Name = :DEFAULT_PROFILE_NAME];
			profileId  = p.Id;
			useContact = false;
		}
		else if (profileName == COMPANY_COMMUNITY_PROFILE_NAME) {
			System.debug('createCommunityUsers - Create user with ' + COMPANY_COMMUNITY_PROFILE_NAME + ' profile');
			profileId = COMPANY_COMMUNITY_PROFILE_Id;
			type = 'com';
		} else {
			System.debug('createCommunityUsers - Create user with ' + profileName + ' profile');

			Profile p = [SELECT Id, Name FROM Profile WHERE Name = :profileName];
			profileId = p.Id;
		}

		List<User> listOfUsers = new List<User>();
		User usr;

		for (Integer key : mapCont.keySet()) {
			if (useContact)
			{
				usr = new User(Alias = type + key,
					Email = key + 'testtest@test.com',
					CommunityNickname = key + mapCont.get(key).LastName,
					EmailEncodingKey = 'UTF-8',
					LastName = 'Test' + type + key,
					LanguageLocaleKey = 'en_US',
					LocaleSidKey = 'en_US',
					ProfileId = profileId,
					ContactId = mapCont.get(key).Id,
					TimeZoneSidKey = 'America/Los_Angeles',
					Username = key + type + '@test.com');
			} else {
				usr = new User(Alias = type + key,
					Email = key + 'testtest@test.com',
					CommunityNickname = key + mapCont.get(key).LastName,
					EmailEncodingKey = 'UTF-8',
					LastName = 'Test' + type + key,
					LanguageLocaleKey = 'en_US',
					LocaleSidKey = 'en_US',
					ProfileId = profileId,
					TimeZoneSidKey = 'America/Los_Angeles',
					Username = key + type + '@test.com');
			}
			listOfUsers.add(usr);
		}
		insert listOfUsers;
		return listOfUsers;
	}

	global static User createAdminUser()
	{
		UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];

		Profile adminProfile =
		[
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

		System.assertNotEquals(null, admin);

		insert admin;
		return admin;
	}

	static final global Id MY_ID = UserInfo.getUserId();
	// Profiles
	static final global String COMPANY_COMMUNITY_PROFILE_NAME = '7S Customer Community Login User';
	static global Id COMPANY_COMMUNITY_PROFILE_Id
	{
		get
		{
			if (COMPANY_COMMUNITY_PROFILE_Id == null)
			{

				List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = :COMPANY_COMMUNITY_PROFILE_NAME];
				COMPANY_COMMUNITY_PROFILE_Id = profiles[0].Id;
			}
			System.assertNotEquals(null, COMPANY_COMMUNITY_PROFILE_Id);
			return COMPANY_COMMUNITY_PROFILE_Id;
		}
		set
		{
			COMPANY_COMMUNITY_PROFILE_Id = value;
			System.assertEquals(value, COMPANY_COMMUNITY_PROFILE_Id);
		}
	}

	static global String THIS_COMMUNITY_NAME
	{
		get
		{
			String commName = '';
			commName = [SELECT Id,Name FROM Network][0].Name;
			System.assertNotEquals(null, commName);
			return commName;
		}
	}

	// this is for standard user to know
	static global String NETWORK_ID
	{
		get
		{
			if (NETWORK_ID == null)
			{
				NETWORK_ID = [SELECT Id FROM Network WHERE Name = :THIS_COMMUNITY_NAME][0].Id;
			}
			System.assertNotEquals(null, NETWORK_ID);
			return NETWORK_ID;

		}
		set
		{
			NETWORK_ID = value;
			System.assertEquals(value, NETWORK_ID);
		}

	}

	//by sachin kadian to get profile name from custom metadata
	static global String DEFAULT_PROFILE_NAME{
		get{
			if(DEFAULT_PROFILE_NAME == null){
				List<SS_News_Settings__mdt> newsSetting = [SELECT Id,Applied_Test_Profile__c FROM SS_News_Settings__mdt  WHERE DeveloperName='Default'];
				if(newsSetting != null && newsSetting.size() >0){
					DEFAULT_PROFILE_NAME =  newsSetting[0].Applied_Test_Profile__c;
				}
			}

			return DEFAULT_PROFILE_NAME;
		}
	}

	// Used to create more than 1 user at a time...
	private static Integer userCount = 0;

	//Create Community User
	//As we are using custom object News, we have created user with the custom Community Profile,
	//Because standard community profile do not allow to give permissions to such custom objects.
	global static User createCommunityUsers(String profileName)
	{
		userCount++;

		if(DEFAULT_PROFILE_NAME != null){
			System.debug('createCommunityUsers - Create user with ' + DEFAULT_PROFILE_NAME + ' profile');
			Profile p = [SELECT Id, Name FROM Profile WHERE Name = :DEFAULT_PROFILE_NAME];

			User u = new User(Alias = 'Com',
					Email = 'testtestCommunity@test.com',
					EmailEncodingKey = 'UTF-8',
					LastName = 'Test',
					LanguageLocaleKey = 'en_US',
					LocaleSidKey = 'en_US',
					ProfileId = p.Id,
					TimeZoneSidKey = 'America/Los_Angeles',
					Username = 'testCommunityNews'+userCount+'@test.com');

			insert u;
			return u;
		}else{
			Account a = new Account(Name = 'TestAccount123') ;
			insert a;

			Contact c = new Contact(
				LastName = 'testCon' + userCount,
				AccountId = a.Id,
				Email = 'testCon' + userCount + '@test.com'
			);
			insert c;

			System.debug('createCommunityUsers - Create user '+  userCount + ' with ' + profileName + ' profile');

			Profile p = [SELECT Id, Name FROM Profile WHERE Name = :profileName];

			User u = new User(Alias = 'Com',
					Email = 'testtest1Community@test.com',
					CommunityNickname = 'NickName'+userCount+'@test.com',
					EmailEncodingKey = 'UTF-8',
					LastName = 'Test',
					LanguageLocaleKey = 'en_US',
					LocaleSidKey = 'en_US',
					ProfileId = p.Id,
					ContactId = c.Id,
					TimeZoneSidKey = 'America/Los_Angeles',
					Username = 'testCommunityNews'+userCount+'@test.com');

			insert u;

			return u;
		}
	}

	//Create User with given Profile name
	global static List<User> SVNSUMMITS_NewsControllerTest(Integer howMany, String profileName)
	{
		Account a = new Account(Name = 'TestAccount123') ;
		insert a;

		List<Contact> listOfContacts = new List<Contact>();
		Map<Integer, Contact> mapCont = new Map<Integer, Contact>();

		for (Integer i = 0; i < howMany; i++)
		{
			Contact c = new Contact(LastName = 'testCon' + i, AccountId = a.Id);
			listOfContacts.add(c);
			mapCont.put(i, c);
		}
		insert listOfContacts;

		// by default bidders
		Id profileId;
		// to make user unique
		String type;
		if (profileName == COMPANY_COMMUNITY_PROFILE_NAME)
		{
			profileId = COMPANY_COMMUNITY_PROFILE_Id;
			type = 'com';
		}

		List<User> listOfUsers = new List<User>();

		for (Integer key : mapCont.keySet())
		{
			User u = new User(Alias = type + key,
				Email = key + 'testtest@test.com',
				CommunityNickname = key + mapCont.get(key).LastName,
				EmailEncodingKey = 'UTF-8',
				LastName = 'Test' + type + key,
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				ProfileId = profileId,
				ContactId = mapCont.get(key).Id,
				TimeZoneSidKey = 'America/Los_Angeles',
				Username = key + type + '@test.com');

			listOfUsers.add(u);

		}

		System.assertNotEquals(null, listOfUsers);

		insert listOfUsers;
		return listOfUsers;
	}

	global static Id createTestGroup(Id ownerId, String groupName, List<User> users)
	{
		CollaborationGroup g = new CollaborationGroup(Name = groupName, CollaborationType = 'Public');
		g.OwnerId = ownerId;

		insert g;

		List<CollaborationGroupMember> groupMembers = new List<CollaborationGroupMember>();

		for (User user : users)
		{
			CollaborationGroupMember member = new CollaborationGroupMember();
			member.MemberId = user.Id ;
			member.CollaborationGroupId = g.Id ;
			groupMembers.add(member);
		}

		System.assertNotEquals(null, groupMembers);

		insert groupMembers;
		return g.Id ;
	}

	global static Id createTestGroup(String groupName)
	{
		CollaborationGroup myGroup = new CollaborationGroup();
		myGroup.Name               = groupName;
		myGroup.NetworkId          = strNetworkId;
		myGroup.CollaborationType  = 'Public'; //can be 'Public' or 'Private'

		System.assertNotEquals(null, myGroup);

		insert myGroup;
		return myGroup.Id;
	}

	global static void addTestGroupMember(String groupId, String userId)
	{
		CollaborationGroupMember groupMember = new CollaborationGroupMember();

		groupMember.CollaborationGroupId = groupId;
		groupMember.MemberId = userId;

		System.assertNotEquals(null, groupMember);

		insert groupMember;
	}
}