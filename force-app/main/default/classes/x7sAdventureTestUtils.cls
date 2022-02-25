/*
 * Copyright (c) 2020. 7Summits Inc.
 */
@IsTest
public class x7sAdventureTestUtils {
    public x7sAdventureTestUtils() {

    }

    public static User createCommunityUserNoContact() {
        List<Profile> communityProfileList = [SELECT Id FROM Profile WHERE Name = :x7sAdventureTestConstants.COMMUNITY_PROFILE];
        User testUser;
        if (!x7sAdventureUtils.isNullOrEmpty(communityProfileList)) {
            testUser = new User(Alias = x7sAdventureTestConstants.STANDARD_ALIAS, Email = x7sAdventureTestConstants.STANDARD_EMAIL, EmailEncodingKey = x7sAdventureTestConstants.ENCODING, FirstName = x7sAdventureTestConstants.FIRST_NAME, LastName = x7sAdventureTestConstants.LAST_NAME, LanguageLocaleKey = x7sAdventureTestConstants.LOCALE, LocaleSidKey = x7sAdventureTestConstants.LOCALE, ProfileId = communityProfileList[0].Id, TimeZoneSidKey = x7sAdventureTestConstants.TIME_ZONE, Username = x7sAdventureTestConstants.STANDARD_USERNAME);
        }

        return testUser;
    }

    // Create a guest user
    public static User createGuestUser() {
        List<Profile> standardProfileList;
        User guestUser;

        try {
            standardProfileList = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        } catch (DmlException e) {
            System.debug(e);
        }

        if (!x7sAdventureUtils.isNullOrEmpty(standardProfileList)) {
            Profile standardProfile = standardProfileList[0];
            guestUser = new User(Alias = x7sAdventureTestConstants.GUEST_ALIAS, Email = x7sAdventureTestConstants.GUEST_EMAIL, EmailEncodingKey = x7sAdventureTestConstants.ENCODING, FirstName = x7sAdventureTestConstants.FIRST_NAME, LastName = x7sAdventureTestConstants.LAST_NAME, LanguageLocaleKey = x7sAdventureTestConstants.LOCALE, LocaleSidKey = x7sAdventureTestConstants.LOCALE, ProfileId = standardProfile.Id, TimeZoneSidKey = x7sAdventureTestConstants.TIME_ZONE, Username = x7sAdventureTestConstants.GUEST_USERNAME);
        }

        return guestUser;
    }

    // Create an account so we can create a Contact
    public static Account createTestAccount() {
        Account account = new Account(Name = x7sAdventureTestConstants.ACCOUNT_NAME);
        insert account;
        return account;
    }

    // Create a contact associated with an account
    public static Contact createAndInsertTestContact() {
        Account account = createTestAccount();
        Contact contact = new Contact(FirstName = x7sAdventureTestConstants.FIRST_NAME, LastName = x7sAdventureTestConstants.LAST_NAME, Email = x7sAdventureTestConstants.STANDARD_EMAIL);
        contact.AccountId = account.Id;
        insert contact;

        return contact;
    }

    // Create an attachment
    public static Attachment createAttachment(Id parentId) {
        Attachment attachment = new Attachment();
        Blob bodyBlob = Blob.valueOf('');
        attachment.ParentId = parentId;
        attachment.Body = bodyBlob;
        attachment.Name = x7sAdventureTestConstants.FIRST_NAME;
        return attachment;
    }

    //Create Topics
    public static List<Topic> createTopic(Integer noOfTopics) {
		List<Topic> topicList = new List<Topic>();

		for (Integer i = 0; i < noOfTopics; i++) {
			Topic topicObj = new Topic(Name = 'Test00' + i, Description = 'Test');
			topicList.add(topicObj);
		}
		insert topicList;

		return topicList;
	}
}