/*
 * Copyright (c) 2020. 7Summits Inc.
 */

/*
    Name : x7sEventsUtility
    Description : Utility class for test data creation
    Date : 25/5/2016
*/
@isTest
public with sharing class x7sEventsUtility {

	public static String strNetworkId { get { return [SELECT Id FROM Network LIMIT 1][0].Id;} }

	/*
		 Method Name : createTopic
		 Description : Method for creating topics
	*/
	public static List<Topic> createTopic(Integer noOfEvents)
	{
		List<Topic> topicList = new List<Topic>();

		for (Integer i = 0; i < noOfEvents; i++) {
			Topic topicObj = new Topic(Name = 'Test00' + i, Description = 'Test');
			topicList.add(topicObj);
		}
		insert topicList;

		return topicList;
	}

    /*
         Method Name : createEventsRecords
         Description : Method for creating event records
    */
	public static List<X7S_Event__c> createEventsRecords(Integer noOfEvents)
	{
		List<X7S_Event__c> eventList = new List<X7S_Event__c>();

		for (Integer i = 0; i < noOfEvents; i++) {
			X7S_Event__c objEvent = new X7S_Event__c();

			objEvent.Name = 'event' + i;
			objEvent.Start_DateTime__c = Date.today();
			objEvent.End_DateTime__c = Date.today();
			objEvent.Details__c = 'Event Details is here.';
			objEvent.Location_Name__c = 'Location' + i;
			objEvent.Enable_RSVP__c = false;

			eventList.add(objEvent);
		}
		insert eventList;


		//create 	NewsTranslation__c record
		List<X7S_Event_Translation__c> eventTraslation = new List<X7S_Event_Translation__c>();
		for(X7S_Event__c record:eventList){

			X7S_Event_Translation__c eventTranslationObj = new X7S_Event_Translation__c(
			Name = 'Test Events Translate',
			Detail__c = 'Detail Test',
			Parent__c = record.id,
			Language__c = 'en_US',
			Title__c = 'Test Title');			
			eventTraslation.add(eventTranslationObj);
		}				
		insert eventTraslation; 

		return eventList;
	}

    /*
         Method Name : createTopicAssignment
         Description : Method for creating topic assignments
    */
	public static TopicAssignment createTopicAssignment(String strTopicId, String strEntityId)
	{
		TopicAssignment topicAssignment = new TopicAssignment(EntityId = strEntityId, TopicId = strTopicId);

		insert topicAssignment ;
		return topicAssignment ;
	}

    /*
         Method Name : createRSVPRecords
         Description : Method for creating RSVP records
    */
	public static List<X7S_Event_RSVP__c> createRSVPRecords(Integer noOfEvents, List<X7S_Event__c> eventList)
	{
		List<X7S_Event_RSVP__c> eventRSVPList = new List<X7S_Event_RSVP__c>();

		for (Integer i = 0; i < noOfEvents; i++) {
			X7S_Event_RSVP__c objEvent = new X7S_Event_RSVP__c();

			objEvent.Event__c = eventList[0].Id;
			objEvent.Response__c = 'YES';
			objEvent.User__c = UserInfo.getUserId();

			eventRSVPList.add(objEvent);
		}
		insert eventRSVPList;

		return eventRSVPList;
	}

    /*
         Method Name : deleteRSVPRecords
         Description : Method for deleting RSVP records
    */
	public static List<X7S_Event_RSVP__c> deleteRSVPRecords(Integer noOfEvents, List<X7S_Event_RSVP__c> eventRSVPList)
	{
		delete eventRSVPList;
		return eventRSVPList;
	}

	static final public String COMPANY_COMMUNITY_PROFILE_NAME = x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER;

	static public Id COMPANY_COMMUNITY_PROFILE_Id {
		get {
			if (COMPANY_COMMUNITY_PROFILE_Id == null) {

				List<Profile> profiles = [SELECT Id from Profile where Name = :COMPANY_COMMUNITY_PROFILE_NAME];
				COMPANY_COMMUNITY_PROFILE_Id = profiles[0].Id;
			}
            System.assert(COMPANY_COMMUNITY_PROFILE_Id != null);
			return COMPANY_COMMUNITY_PROFILE_Id;
		}
		set {
			COMPANY_COMMUNITY_PROFILE_Id = value;
			System.assertEquals(value, COMPANY_COMMUNITY_PROFILE_Id);
		}
	}

	static public String THIS_COMMUNITY_NAME {
		get {
			String commName = '';
			commName = [SELECT Id,Name from Network][0].Name;
			System.assertNotEquals(null, commName);
			return commName;
		}
	}

	//by sachin kadian to get profile name from custom metadata
	static public String DEFAULT_PROFILE_NAME{
		get{
			List<X7S_Events_Setting__mdt> eventsSetting = [SELECT Id,Default_Test_Profile__c FROM X7S_Events_Setting__mdt  WHERE DeveloperName='Default'];
			if(eventsSetting != null && eventsSetting.size() >0){
				return eventsSetting[0].Default_Test_Profile__c;
			}
			return null;
		}
	}

	//Create User with given Profile name
	public static List<User> createUsers(Integer howMany, String profileName)
	{
		Account a = new Account(Name = 'TestAccount123', Industry_Type__c = 'Retail') ;
		insert a;

		List<Contact> listOfContacts = new List<Contact>();
		Map<Integer, Contact> mapCont = new Map<Integer, Contact>();

		for (Integer i = 0; i < howMany; i++) {
			Contact c = new Contact(LastName = 'testCon' + i, AccountId = a.Id);
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

		for (Integer key : mapCont.keySet())
		{
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

	//Create Community User
	//As we are using custom object Events, created a user with the custom Community Profile,
	//As standard community profiles do not allow to give permissions to such custom objects.
	public static User createCommunityUsers(String profileName)
	{
		if(DEFAULT_PROFILE_NAME != null){
			Profile p = [SELECT Id, Name FROM Profile WHERE Name = :DEFAULT_PROFILE_NAME];

			User u = new User(Alias = 'Com',
					Email = 'testtestCommunity@test.com',
					EmailEncodingKey = 'UTF-8',
					LastName = 'Test',
					LanguageLocaleKey = 'en_US',
					LocaleSidKey = 'en_US',
					ProfileId = p.Id,
					TimeZoneSidKey = 'America/Los_Angeles',
					Username = 'testtestCommunity@test.com');

			insert u;
			return u;
		} else {
			Account a = new Account(Name = 'TestAccount123') ;
			insert a;

			Contact c = new Contact(LastName = 'testCon', AccountId = a.Id);
			insert c;


			Profile p = [SELECT Id, Name FROM Profile WHERE Name = :profileName];

			User u = new User(Alias = 'Com',
					Email = 'testtestCommunity@test.com',
					CommunityNickname = c.LastName,
					EmailEncodingKey = 'UTF-8',
					LastName = 'Test',
					LanguageLocaleKey = 'en_US',
					LocaleSidKey = 'en_US',
					ProfileId = p.Id,
					ContactId = c.Id,
					TimeZoneSidKey = 'America/Los_Angeles',
					Username = 'testtestCommunity@test.com');

			insert u;

			return u;
		}
	}

	public static Id createTestGroup(String groupName)
	{
		CollaborationGroup myGroup = new CollaborationGroup();

		myGroup.Name              = groupName;
		myGroup.CollaborationType = 'Public'; //can be 'Public' or 'Private'
		myGroup.NetworkId         = strNetworkId;
		System.assertNotEquals(null, myGroup);

		insert myGroup;
		return myGroup.Id;
	}

	public static void addTestGroupMember(String groupId, String userId)
	{
		CollaborationGroupMember groupMember = new CollaborationGroupMember();

		groupMember.CollaborationGroupId = groupId;
		groupMember.MemberId = userId;
		System.assertNotEquals(null, groupMember);

		insert groupMember;
	}
}