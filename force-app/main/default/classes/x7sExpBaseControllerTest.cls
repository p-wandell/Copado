/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sExpBaseControllerTest {

    @TestSetup static void testSetup() {
        Contact testContact = x7sExpTestUtils.createTestContact();
        System.assertNotEquals(null, testContact);
    }

    @IsTest
    public static void testGetSitePrefix() {
        System.assert(x7sExpBaseController.getSitePrefix() != null);
    }

    // Test finding a user
    @IsTest
    public static void testUser() {
        List<Contact> testContacts = [SELECT Id FROM Contact WHERE Email = :x7sExpTestConstants.STANDARD_EMAIL];

        User testUser = x7sExpTestUtils.createStandardUserNoContact();

        try {
            testUser.ContactId = testContacts[0].Id;
            insert testUser;
        } catch (Exception e) {
            testUser.ContactId = null;
            insert testUser;
        }

        Test.startTest();

        System.runAs(testUser) {
            System.assertEquals(false, x7sExpBaseController.isGuestUser());
        }

        Test.stopTest();

    }

    // Test running as a guest
    @IsTest
    public static void testGuest() {
        // Set up and run as guest user 
        User guestUser = x7sExpTestUtils.createGuestUser();

        System.runAs(guestUser) {
            System.assertEquals(true, x7sExpBaseController.isGuestUser());
        }
    }

}