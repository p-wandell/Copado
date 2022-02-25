/*
 * Copyright (c) 2020. 7Summits Inc.
 */
@IsTest
public with sharing class x7sAdventureUtilsTest {

    @TestSetup
    static void testSetup() {
        x7sAdventureTestUtils.createAndInsertTestContact();
    }

    @IsTest
    static void testIsRegularUser() {
        Test.startTest();
        System.assertEquals(false, x7sAdventureUtils.isGuestUser());
        Test.stopTest();
    }

    // Test running as a guest
    @IsTest
    public static void testIsGuestUser() {
        // Set up and run as guest user
        User guestUser = x7sAdventureTestUtils.createGuestUser();

        System.runAs(guestUser) {
            System.assertEquals(true, x7sAdventureUtils.isGuestUser());
        }
    }

    // Test building a formatted string from a set of strings
    @IsTest
    public static void testBuildStringFromSet() {
        Set<String> sourceSet = new Set<String>();
        sourceSet.add('Hello');
        sourceSet.add('There');
        System.assertEquals('Hello, There', x7sAdventureUtils.buildStringFromSet(sourceSet)); // test that this is building a string from a set properly
    }

    @IsTest
    public static void testGetUser() {
        // Set up and run as a standard user
        List<Contact> testContacts = [SELECT Id FROM Contact WHERE Email = :x7sAdventureTestConstants.STANDARD_EMAIL];

        User testUser = x7sAdventureTestUtils.createCommunityUserNoContact();
        testUser.ContactId = testContacts[0].Id;
        insert testUser;

        System.runAs(testUser) {
            System.assertEquals(testUser.Id, x7sAdventureUtils.getUser().Id);
        }
    }

    @IsTest
    public static void testIsNullOrEmpty() {
        // Assert return true for empty list
        List<String> stringList = new List<String>();
        System.assertEquals(x7sAdventureUtils.isNullOrEmpty(stringList), true);

        // Assert return false for not empty list
        stringList.add(x7sAdventureTestConstants.ACCOUNT_NAME);
        System.assertEquals(x7sAdventureUtils.isNullOrEmpty(stringList), false);
    }

    @IsTest
    public static void testGetSitePrefix() {
        System.assert(x7sAdventureUtils.getSitePrefix() != null);
    }

    @IsTest
    public static void testCreateAttachment() {
        // Set up and run as a standard user
        List<Contact> testContacts = [SELECT Id FROM Contact WHERE Email = :x7sAdventureTestConstants.STANDARD_EMAIL];

        User testUser = x7sAdventureTestUtils.createCommunityUserNoContact();
        testUser.ContactId = testContacts[0].Id;
        insert testUser;

        Attachment testAttachment = x7sAdventureTestUtils.createAttachment(testUser.Id);
        System.assert(testAttachment != null);
    }

    @IsTest
    public static void testGetPicklistValues() {
        List<String> options = x7sAdventureUtils.getPicklistValues('User', 'LanguageLocaleKey');
        System.assert(options.size() > 0);
    }

    @IsTest
    public static void testCreateListFromMultiPicklist() {

        String multiPicklistString = 'string1;string2;string3';

        List<String> multiPicklistList = x7sAdventureUtils.createListFromMultiPicklist(multiPicklistString);

        System.assertEquals(multiPicklistList.get(0), 'string1');
        System.assertEquals(multiPicklistList.get(1), 'string2');
        System.assertEquals(multiPicklistList.get(2), 'string3');

    }

    @IsTest
    public static void testDoesStringContainListItem() {

        List<String> compareList = new List<String>();
        compareList.add('string1');
        compareList.add('string2');

        //Assert list contains target string
        System.assert(x7sAdventureUtils.doesStringContainListItem(compareList, 'string1'));

        //Assert list does not contain target string
        System.assert(!x7sAdventureUtils.doesStringContainListItem(compareList, 'string3'));
    }

    @IsTest
    public static void testGetYear() {
        Integer reqYear = x7sAdventureUtils.getYear();
        System.assert(reqYear != null);
    }

    @IsTest
    public static void testThrowErrorIfInsertPermissionMissing() {
        User testUser = x7sAdventureTestUtils.createCommunityUserNoContact();
        testUser.ContactId = [SELECT Id FROM Contact WHERE Email = :x7sAdventureTestConstants.STANDARD_EMAIL LIMIT 1].Id;
        insert testUser;

        Boolean wasExceptionThrown = false;

        Test.startTest();
        System.runAs(testUser) {
            try {
                x7sAdventureUtils.throwErrorIfInsertPermissionMissing(Schema.SObjectType.ApexClass); // ApexClass is never modifiable
            } catch (Exception ex) {
                wasExceptionThrown = true;
            }
        }
        Test.stopTest();

        System.assertEquals(true, wasExceptionThrown, 'An exception was expected during the test, but no exception was thrown.');
    }

    @IsTest
    public static void testThrowErrorIfUpdatePermissionMissing() {
        User testUser = x7sAdventureTestUtils.createCommunityUserNoContact();
        testUser.ContactId = [SELECT Id FROM Contact WHERE Email = :x7sAdventureTestConstants.STANDARD_EMAIL LIMIT 1].Id;
        insert testUser;

        Boolean wasExceptionThrown = false;

        Test.startTest();
        System.runAs(testUser) {
            try {
                x7sAdventureUtils.throwErrorIfUpdatePermissionMissing(Schema.SObjectType.ApexClass); // ApexClass is never modifiable
            } catch (Exception ex) {
                wasExceptionThrown = true;
            }
        }
        Test.stopTest();

        System.assertEquals(true, wasExceptionThrown, 'An exception was expected during the test, but no exception was thrown.');
    }
}