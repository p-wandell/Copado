/* Copyright ©2016-2018 7Summits Inc. All rights reserved. */

@IsTest
public with sharing class SVNSUMMITS_EventVolunteersControllerTest {

    @TestSetup static void methodName(){
        // Test Event
        List<Event__c> testEvents = SVNSUMMITS_EventUtility.createEventsRecords(1);

        // Test volunteer Need
        Volunteer_Need__c testNeed = new Volunteer_Need__c(
                Event__c = testEvents[0].Id,
                Volunteers_Needed__c = 10
        );
        insert testNeed;

        // Test users
        List<User> testUsers =  SVNSUMMITS_EventUtility.createUsers(2, SVNSUMMITS_Event_TestConstants.CUSTOMER_COMMUNITY_USER);

        // Test registrations
        Volunteer_Registration__c testRegistration = new Volunteer_Registration__c(
                Volunteer_Need__c = testNeed.Id,
                User__c = testUsers[1].Id
        );
        insert testRegistration;

    }

    @IsTest
    public static void testGetEventVolunteerNeeds() {
        List<Event__c> testEvents = [SELECT Id FROM Event__c];
        List<User> testUsers =  [SELECT Id FROM User WHERE IsActive=TRUE LIMIT 1];
        

        // Test by specifying user id
        List<SVNSUMMITS_EventVolunteerWrapper> testNeeds = SVNSUMMITS_EventVolunteersController.getEventVolunteerNeeds(testEvents[0].Id,testUsers[0].Id);
        System.assertEquals(testNeeds[0].volunteerNeed.Volunteers_Needed__c, 10);

        // Now test with run as user
//        System.runAs(testUsers[0]){
            testNeeds = SVNSUMMITS_EventVolunteersController.getEventVolunteerNeeds((String)testEvents[0].Id);
            System.assertEquals(testNeeds[0].volunteerNeed.Volunteers_Needed__c, 10);

            // Make sure user is picked up as registered... first create a new registration
            Volunteer_Registration__c testRegistration = new Volunteer_Registration__c(
                    Volunteer_Need__c = testNeeds[0].volunteerNeed.Id,
                    User__c = testUsers[0].Id
            );
            insert testRegistration;

            // Query again... current user should now be registered
            testNeeds = SVNSUMMITS_EventVolunteersController.getEventVolunteerNeeds((String)testEvents[0].Id);
//            System.assertEquals(testNeeds[0].currentUserRegistered, true);
//        }
    }

    @IsTest
    public static void testRegisterAndDelete() {
        List<Volunteer_Need__c> testNeeds = [SELECT Id FROM Volunteer_Need__c];

        // New list of test users
        List<User> testUsers =  [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
        System.assertEquals(true,SVNSUMMITS_EventVolunteersController.registerVolunteer(testNeeds[0].Id,testUsers[0].Id));

        // There was one registration in set up, and we just made another, so there should now be two
        Volunteer_Need__c testNeed = [SELECT Volunteers_Registered__c FROM Volunteer_Need__c WHERE Id = :testNeeds[0].Id];
        System.assertEquals(testNeed.Volunteers_Registered__c,2);

        // Now remove
        System.assertEquals(true,SVNSUMMITS_EventVolunteersController.removeVolunteer(testNeeds[0].Id,testUsers[0].Id));

        // New test in current running user
        System.runAs(testUsers[0]){
            System.assert(true,SVNSUMMITS_EventVolunteersController.registerVolunteerSingle((String)testNeeds[0].Id));
            System.assert(true,SVNSUMMITS_EventVolunteersController.removeVolunteerSingle((String)testNeeds[0].Id));
        }

    }

    @IsTest
    public static void testGetUser() {
        List<User> testUsers =  [SELECT Id FROM User WHERE IsActive=TRUE LIMIT 1];

        System.runAs(testUsers[0]){
            System.assertEquals(testUsers[0].Id,SVNSUMMITS_EventVolunteersController.getCurrentUser().Id);
        }
    }

    @IsTest
    public static void testDuplicationTrigger() {
        List<User> testUsers =  [SELECT Id FROM User WHERE IsActive=TRUE LIMIT 1];
        List<Volunteer_Need__c> testNeeds = [SELECT Id FROM Volunteer_Need__c];

        // Create two duplicates
        Volunteer_Registration__c testRegistration = new Volunteer_Registration__c(
                Volunteer_Need__c = testNeeds[0].Id,
                User__c = testUsers[0].Id
        );

        Volunteer_Registration__c testRegistration2 = new Volunteer_Registration__c(
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
        List<Event__c> testEvents = [SELECT Id FROM Event__c];

        // Create a need
        Volunteer_Need__c testNeed = new Volunteer_Need__c(
                Event__c = testEvents[0].Id,
                Volunteers_Needed__c = 10
        );

        // Add it to list
        List<Volunteer_Need__c> volunteerNeeds = new List<Volunteer_Need__c>();
        volunteerNeeds.add(testNeed);

        List<String> resultStrings = SVNSUMMITS_EventVolunteersController.createVolunteerNeeds(testEvents[0],volunteerNeeds,new List<Volunteer_Need__c>());

        System.assertEquals(0,resultStrings.size());
    }

    @IsTest
    public static void testInitVolunteerNeeds() {
        // Get test event
        List<Event__c> testEvents = [SELECT Id FROM Event__c];

        System.assertEquals(SVNSUMMITS_EventVolunteersController.initVolunteerNeeds((String)testEvents[0].Id).Volunteer_Needs__r.size(),1);
    }
    

    @IsTest
    public static void testSitePrefix()
    {
        String prefix = SVNSUMMITS_EventVolunteersController.getSitePrefix();
        System.assertNotEquals(null, prefix);
    }
}