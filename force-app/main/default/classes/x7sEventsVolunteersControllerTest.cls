/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sEventsVolunteersControllerTest {

    @TestSetup static void methodName(){
        // Test Event
        List<X7S_Event__c> testEvents = x7sEventsUtility.createEventsRecords(1);

        // Test volunteer Need
        X7S_Events_Volunteer_Need__c testNeed = new X7S_Events_Volunteer_Need__c(
                Event__c = testEvents[0].Id,
                Volunteers_Needed__c = 10
        );
        insert testNeed;

        // Test users
        List<User> testUsers =  x7sEventsUtility.createUsers(2, x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER);

        // Test registrations
        X7S_Events_Volunteer_Registration__c testRegistration = new X7S_Events_Volunteer_Registration__c(
                Volunteer_Need__c = testNeed.Id,
                User__c = testUsers[1].Id
        );
        insert testRegistration;

    }

    @IsTest
    public static void testGetEventVolunteerNeeds() {
        List<X7S_Event__c> testEvents = [SELECT Id FROM X7S_Event__c];
        //List<User> testUsers =  [SELECT Id FROM User WHERE UserType = 'Standard' AND IsActive=TRUE LIMIT 1];
        List<User> testUsers =  [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];

        // Test by specifying user id
        List<x7sEventsVolunteerWrapper> testNeeds = x7sEventsVolunteersController.getEventVolunteerNeeds(testEvents[0].Id,testUsers[0].Id);
        System.debug('------- testNeeds: ' + testNeeds);
        System.assertEquals(testNeeds[0].volunteerNeed.Volunteers_Needed__c, 10);

        // Now test with run as user
        System.runAs(testUsers[0]){
            testNeeds = x7sEventsVolunteersController.getEventVolunteerNeeds((String)testEvents[0].Id);
            //System.assertEquals(testNeeds[0].volunteerNeed.Volunteers_Needed__c, 10);

            // Make sure user is picked up as registered... first create a new registration
            X7S_Events_Volunteer_Registration__c testRegistration = new X7S_Events_Volunteer_Registration__c(
                    Volunteer_Need__c = testNeeds[0].volunteerNeed.Id,
                    User__c = testUsers[0].Id
            );
            insert testRegistration;

            // Query again... current user should now be registered
            testNeeds = x7sEventsVolunteersController.getEventVolunteerNeeds((String)testEvents[0].Id);
            //System.assertEquals(testNeeds[0].currentUserRegistered, true);
        }
    }

    @IsTest
    public static void testRegisterAndDelete() {
        List<X7S_Events_Volunteer_Need__c> testNeeds = [SELECT Id FROM X7S_Events_Volunteer_Need__c];

        // New list of test users
        List<User> testUsers =  [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
        System.assertEquals(true,x7sEventsVolunteersController.registerVolunteer(testNeeds[0].Id,testUsers[0].Id));

        // There was one registration in set up, and we just made another, so there should now be two
        X7S_Events_Volunteer_Need__c testNeed = [SELECT Volunteers_Registered__c FROM X7S_Events_Volunteer_Need__c WHERE Id = :testNeeds[0].Id];
        System.assertEquals(testNeed.Volunteers_Registered__c,2);

        // Now remove
        System.assertEquals(true,x7sEventsVolunteersController.removeVolunteer(testNeeds[0].Id,testUsers[0].Id));

        // New test in current running user
        System.runAs(testUsers[0]){
            System.assert(true,x7sEventsVolunteersController.registerVolunteerSingle((String)testNeeds[0].Id));
            System.assert(true,x7sEventsVolunteersController.removeVolunteerSingle((String)testNeeds[0].Id));
        }

    }

    @IsTest
    public static void testGetUser() {
        List<User> testUsers =  [SELECT Id FROM User WHERE IsActive=TRUE LIMIT 1];

        System.runAs(testUsers[0]){
            System.assertEquals(testUsers[0].Id,x7sEventsVolunteersController.getCurrentUser().Id);
        }
    }

    @IsTest
    public static void testDuplicationTrigger() {
        List<User> testUsers =  [SELECT Id FROM User WHERE IsActive=TRUE LIMIT 1];
        List<X7S_Events_Volunteer_Need__c> testNeeds = [SELECT Id FROM X7S_Events_Volunteer_Need__c];

        // Create two duplicates
        X7S_Events_Volunteer_Registration__c testRegistration = new X7S_Events_Volunteer_Registration__c(
                Volunteer_Need__c = testNeeds[0].Id,
                User__c = testUsers[0].Id
        );

        X7S_Events_Volunteer_Registration__c testRegistration2 = new X7S_Events_Volunteer_Registration__c(
                Volunteer_Need__c = testNeeds[0].Id,
                User__c = testUsers[0].Id
        );

        String errorMessage = '';

        // Attempt to create duplicate
        try{
            insert testRegistration;
            insert testRegistration2;
        } catch (Exception e){
            errorMessage = e.getMessage();
        }

        // There was a problem! Make sure errorMessage is not blank
        System.assert(errorMessage != '');
    }

    @IsTest
    public static void testCreateVolunteerNeeds() {
        // Get test event
        List<X7S_Event__c> testEvents = [SELECT Id FROM X7S_Event__c];

        // Create a need
        X7S_Events_Volunteer_Need__c testNeed = new X7S_Events_Volunteer_Need__c(
                Event__c = testEvents[0].Id,
                Volunteers_Needed__c = 10
        );

        // Add it to list
        List<X7S_Events_Volunteer_Need__c> volunteerNeeds = new List<X7S_Events_Volunteer_Need__c>();
        volunteerNeeds.add(testNeed);

        List<String> resultStrings = x7sEventsVolunteersController.createVolunteerNeeds(testEvents[0],volunteerNeeds,new List<X7S_Events_Volunteer_Need__c>());

        System.assertEquals(0,resultStrings.size());
    }

    @IsTest
    public static void testInitVolunteerNeeds() {
        // Get test event
        List<X7S_Event__c> testEvents = [SELECT Id FROM X7S_Event__c];

        System.assertEquals(x7sEventsVolunteersController.initVolunteerNeeds((String)testEvents[0].Id).X7S_Events_Volunteer_Needs__r.size(),1);
    }
    

    @IsTest
    public static void testSitePrefix()
    {
        String prefix = x7sEventsVolunteersController.getSitePrefix();
        System.assertNotEquals(null, prefix);
    }
}