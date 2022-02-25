/*
 * Copyright (c) 2020. 7Summits Inc.
 */

// ===================
// x7sExp Test Utils
// ===================
@IsTest
public class x7sExpTestUtils {
    public static User createStandardUserNoContact() {
        List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name = :x7sExpTestConstants.COMMUNITY_PROFILE];
        User testUser;
        if (!x7sExpUtils.isNullOrEmpty(standardProfileList)) {
            Profile standardProfile = standardProfileList[0];
            testUser = new User(Alias = x7sExpTestConstants.STANDARD_ALIAS, Email = x7sExpTestConstants.STANDARD_EMAIL, EmailEncodingKey = x7sExpTestConstants.ENCODING, FirstName = x7sExpTestConstants.FIRSTNAME, LastName = x7sExpTestConstants.LASTNAME, LanguageLocaleKey = x7sExpTestConstants.LOCALE, LocaleSidKey = x7sExpTestConstants.LOCALE, ProfileId = standardProfile.Id, TimeZoneSidKey = x7sExpTestConstants.TIMEZONE, Username = x7sExpTestConstants.STANDARD_USERNAME);
        }

        return testUser;
    }

    // Create a standard user
    public static User createStandardUser() {
        Contact contact = createTestContact();
        User testUser;

        List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name = :x7sExpTestConstants.COMMUNITY_PROFILE];

        if (!x7sExpUtils.isNullOrEmpty(standardProfileList)) {
            Profile standardProfile = standardProfileList[0];
            testUser = new User(Alias = x7sExpTestConstants.STANDARD_ALIAS, Email = x7sExpTestConstants.STANDARD_EMAIL, 
                                EmailEncodingKey = x7sExpTestConstants.ENCODING, FirstName = x7sExpTestConstants.FIRSTNAME, 
                                LastName = x7sExpTestConstants.LASTNAME, LanguageLocaleKey = x7sExpTestConstants.LOCALE, 
                                LocaleSidKey = x7sExpTestConstants.LOCALE, ProfileId = standardProfile.Id, 
                                TimeZoneSidKey = x7sExpTestConstants.TIMEZONE, Username = x7sExpTestConstants.STANDARD_USERNAME);
            testUser.ContactId = contact.Id;
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

        if (!x7sExpUtils.isNullOrEmpty(standardProfileList)) {
            Profile standardProfile = standardProfileList[0];
            guestUser = new User(Alias = x7sExpTestConstants.GUEST_ALIAS, Email = x7sExpTestConstants.GUEST_EMAIL, EmailEncodingKey = x7sExpTestConstants.ENCODING, FirstName = x7sExpTestConstants.FIRSTNAME, LastName = x7sExpTestConstants.LASTNAME, LanguageLocaleKey = x7sExpTestConstants.LOCALE, LocaleSidKey = x7sExpTestConstants.LOCALE, ProfileId = standardProfile.Id, TimeZoneSidKey = x7sExpTestConstants.TIMEZONE, Username = x7sExpTestConstants.GUEST_USERNAME);
        }

        return guestUser;
    }

    // Create an account so we can create a Contact
    public static Account createTestAccount() {
        Account account = new Account(Name = x7sExpTestConstants.ACCOUNT_NAME, Industry_Type__c = 'Retail');
        insert account;
        
        System.debug('------- Account: ' + account);
        
        return account;
    }

    // Create a contact associated with an account
    public static Contact createTestContact() {
        Account account = createTestAccount();
        Contact contact = new Contact(FirstName = x7sExpTestConstants.FIRSTNAME, LastName = x7sExpTestConstants.LASTNAME, Email = x7sExpTestConstants.STANDARD_EMAIL);
        contact.AccountId = account.Id;
        insert contact;
        
        System.debug('------- Contact: ' + contact);

        return contact;
    }

    // Create an attachment
    public static Attachment createAttachment(Id parentId) {
        Attachment attachment = new Attachment();
        Blob bodyBlob = Blob.valueOf('');
        attachment.ParentId = parentId;
        attachment.Body = bodyBlob;
        attachment.Name = x7sExpTestConstants.FIRSTNAME;
        return attachment;
    }

    // Fake ID x7sExpTestUtils.getFakeId(User.SObjectType));
    public static String getFakeId(Schema.SObjectType sot) {
        Integer s_num = 1;
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12 - result.length()) + result;
    }

    // Internal Chatter Group (No Network Id)
    public static CollaborationGroup createChatterGroup(String groupName, String collaborationType) {
        CollaborationGroup testGroup = new CollaborationGroup(
                Name = groupName,
                CollaborationType = collaborationType
        );
        return testGroup;
    }
}