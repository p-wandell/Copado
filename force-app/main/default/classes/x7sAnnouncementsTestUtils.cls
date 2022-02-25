/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sAnnouncementsTestUtils
{
	public static User createStandardUserNoContact(){
		List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name = :x7sAnnouncementsTestConstants.COMMUNITY_PROFILE];
		User testUser;
		if (!x7sAnnouncementsUtils.isNullOrEmpty(standardProfileList)) {
			Profile standardProfile = standardProfileList[0];
			testUser = new User(Alias = x7sAnnouncementsTestConstants.STANDARD_ALIAS, Email= x7sAnnouncementsTestConstants.STANDARD_EMAIL, EmailEncodingKey= x7sAnnouncementsTestConstants.ENCODING, FirstName= x7sAnnouncementsTestConstants.FIRSTNAME, LastName= x7sAnnouncementsTestConstants.LASTNAME, LanguageLocaleKey= x7sAnnouncementsTestConstants.LOCALE,LocaleSidKey= x7sAnnouncementsTestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey= x7sAnnouncementsTestConstants.TIMEZONE, UserName= x7sAnnouncementsTestConstants.STANDARD_USERNAME);
		}

		return testUser;
	}

	// Create a standard user
	public static User createStandardUser(){
		Contact contact = createTestContact();
		User testUser;

		List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name = :x7sAnnouncementsTestConstants.COMMUNITY_PROFILE];

		if (!x7sAnnouncementsUtils.isNullOrEmpty(standardProfileList)) {
			Profile standardProfile = standardProfileList[0];
			testUser = new User(Alias = x7sAnnouncementsTestConstants.STANDARD_ALIAS, Email= x7sAnnouncementsTestConstants.STANDARD_EMAIL, EmailEncodingKey= x7sAnnouncementsTestConstants.ENCODING, FirstName= x7sAnnouncementsTestConstants.FIRSTNAME, LastName= x7sAnnouncementsTestConstants.LASTNAME, LanguageLocaleKey= x7sAnnouncementsTestConstants.LOCALE,LocaleSidKey= x7sAnnouncementsTestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey= x7sAnnouncementsTestConstants.TIMEZONE, UserName= x7sAnnouncementsTestConstants.STANDARD_USERNAME);
			testUser.ContactId = contact.id;
		}

		return testUser;
	}

	// Create a guest user
	public static User createGuestUser(){
		List<Profile> standardProfileList;
		User guestUser;

		try {
			standardProfileList = [SELECT Id FROM Profile WHERE Name='Standard User'];
		} catch (DmlException e) {
			System.debug(e);
		}

		if (!x7sAnnouncementsUtils.isNullOrEmpty(standardProfileList)) {
			Profile standardProfile = standardProfileList[0];
			guestUser = new User(Alias = x7sAnnouncementsTestConstants.GUEST_ALIAS, Email= x7sAnnouncementsTestConstants.GUEST_EMAIL, EmailEncodingKey= x7sAnnouncementsTestConstants.ENCODING, FirstName= x7sAnnouncementsTestConstants.FIRSTNAME,LastName= x7sAnnouncementsTestConstants.LASTNAME, LanguageLocaleKey= x7sAnnouncementsTestConstants.LOCALE,LocaleSidKey= x7sAnnouncementsTestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey= x7sAnnouncementsTestConstants.TIMEZONE, UserName= x7sAnnouncementsTestConstants.GUEST_USERNAME);
		}

		return guestUser;
	}

	// Create an account so we can create a Contact
	public static Account createTestAccount(){
		Account account = new Account(name= x7sAnnouncementsTestConstants.ACCOUNT_NAME);
		insert account;
		return account;
	}

	// Create a contact associated with an account
	public static Contact createTestContact(){
		Account account = createTestAccount();
		Contact contact = new Contact(firstName= x7sAnnouncementsTestConstants.FIRSTNAME, lastName= x7sAnnouncementsTestConstants.LASTNAME, email= x7sAnnouncementsTestConstants.STANDARD_EMAIL);
		contact.accountId = account.id;
		insert contact;

		return contact;
	}

	// Create an attachment
	public static Attachment createAttachment(Id parentId){
		Attachment attachment = new Attachment();
		Blob bodyBlob=Blob.valueOf('');
		attachment.ParentId = parentId;
		attachment.body = bodyBlob;
		attachment.Name = x7sAnnouncementsTestConstants.FIRSTNAME;
		return attachment;
	}

	// Fake ID x7sAnnouncementsTestUtils.getFakeId(User.SObjectType));
	public static String getFakeId(Schema.SObjectType sot)
	{
		Integer s_num = 1;
		String result = String.valueOf(s_num++);
		return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
	}

	// Internal Chatter Group (No Network Id)
	public static CollaborationGroup createChatterGroup(String groupName, String collaborationType){
		CollaborationGroup testGroup = new CollaborationGroup(
			Name=groupName,
			CollaborationType=collaborationType
		);
		return testGroup;
	}

	// Community Chatter Group (Has Network Id)
	// Note: Apex does not allow the creation of a Network(Community) within Tests. The Network Id will need to be
	// referenced on the fly within the individual org where a Network(Community) already exists
	public static CollaborationGroup createChatterGroup(String groupName, String collaborationType,String networkId){
		CollaborationGroup testGroup = new CollaborationGroup(
			Name=groupName,
			CollaborationType=collaborationType,
			NetworkId=networkId
		);
		return testGroup;
	}

	// Chatter Group Membership
	// Note: when adding a group member, if the group is not attached to a Network(community), then the user must be a
	// non-community user (Not a partner profile).
	public static CollaborationGroupMember createGroupMembership(String groupId, Id userId){
		CollaborationGroupMember groupMembership = new CollaborationGroupMember();
		groupMembership.CollaborationGroupId = groupId;
		groupMembership.MemberId = userId;
		groupMembership.CollaborationRole = 'Standard';
		return groupMembership;
	}

	public static Opportunity createOpportunity(Id userId,String forecastCategoryName){
		Opportunity newOpportunity = new Opportunity(
			Amount = x7sAnnouncementsTestConstants.AMOUNT,
			OwnerId = userId,
			ForecastCategoryName = forecastCategoryName,
			Name = x7sAnnouncementsTestConstants.OPP_NAME,
			StageName = x7sAnnouncementsTestConstants.STAGE_NAME,
			CloseDate = x7sAnnouncementsTestConstants.TODAY
		);
		return newOpportunity;
	}


	public static List<Topic> createTopics(Integer howMany,Id networkId) {
		List<topic> topicList = new List<topic>();
		for(Integer i=0;i<howMany;i++){
			Topic topicObj = new Topic(Name='Test00' + i, Description='Test',NetworkId = networkId);
			topicList.add(topicObj);
		}
		return topicList;
	}

	public static TopicAssignment createTopicAssignment(Id strTopicId, Id strEntityId,Id networkId) {
		TopicAssignment topicAssigmnt = new TopicAssignment(EntityId = strEntityId, TopicId = strTopicId,NetworkId = networkId);
		return topicAssigmnt;
	}

	public static List<FeedItem> createFeedItems(Integer howMany,Id networkId,Id parentId){
		List<FeedItem> feedItems = new List<FeedItem>();

		for(Integer i=0;i<howMany;i++){
			FeedItem feedItem = new FeedItem();
			feedItem.Title = x7sAnnouncementsTestConstants.TEST_MESSAGE;
			feedItem.Body = x7sAnnouncementsTestConstants.TEST_DESCRIPTION;
			feedItem.ParentId = parentId;
			feedItem.NetworkScope = networkId;
			feedItems.add(feedItem);
		}

		return feedItems;
	}
}