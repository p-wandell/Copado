/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sAdventureBaseControllerTest {

    @TestSetup
    public static void testSetup() {
        // Profile
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        //User to assign tasks
        User taskOwner = new User(LastName = 'LIVESTON', FirstName = 'JASON', Alias = 'jliv', Email = 'jason.liveston@asdf.com', Username = 'Adventure.Learning@Test.com',
                ProfileId = profileId.Id, TimeZoneSidKey = 'GMT', LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US');
        insert taskOwner;

        //Create test adventure
        X7S_Adventure__c testAdventure = new X7S_Adventure__c(Name = x7sAdventureTestConstants.TEST_ADVENTURE_NAME, Title__c = x7sAdventureTestConstants.TEST_ADVENTURE_NAME);
        insert testAdventure;

        //Create test Adventure Step
        X7S_Adventure_Step__c testAdventureStep = new X7S_Adventure_Step__c(Name = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME,
                Title__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME, Adventure__c = testAdventure.Id, Order__c = 0,
                Subtitle__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_SUBTITLE, Description__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_DESCRIPTION);
        insert testAdventureStep;

        //Create test Step Module
        X7S_Adventure_Module__c testStepModule = new X7S_Adventure_Module__c(Name = x7sAdventureTestConstants.TEST_STEP_MODULE_NAME,
                Title__c = x7sAdventureTestConstants.TEST_STEP_MODULE_NAME, Adventure_Step__c = testAdventureStep.Id, Order__c = 0);
        insert testStepModule;

        //Create test Module Task
        X7S_Adventure_Task__c testModuleTask = new X7S_Adventure_Task__c(Name = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Adventure_Module__c = testStepModule.Id, Owner__c = taskOwner.Id,
                Order__c = 0, Completed__c = false);
        insert testModuleTask;

        X7S_Adventure_Subtask__c testSubtask = new X7S_Adventure_Subtask__c(Response_Input__c = 'Test');
        insert testSubtask;
    }

    @IsTest
    public static void testGetAdventure() {
        List<X7S_Adventure__c> testAdventures = [SELECT Id FROM X7S_Adventure__c];

        System.debug('Adventure ID: ' + testAdventures[0].Id);

        x7sAdventureResponse response = x7sAdventureBaseController.getAdventure(testAdventures[0].Id, 'X7S_Adventure__c', true, '');
        System.assertEquals(x7sAdventureTestConstants.TEST_ADVENTURE_NAME, response.adventureResults[0].adventure.Name);

        x7sAdventureResponse responseWithoutOwnerId = x7sAdventureBaseController.getAdventure(testAdventures[0].Id, 'X7S_Adventure__c', false, '');
        System.assertEquals(x7sAdventureTestConstants.TEST_ADVENTURE_NAME, responseWithoutOwnerId.adventureResults[0].adventure.Name);
    }

    /**
     * Sends a step Id and the details for that step are returned.
     */
    @IsTest
    public static void testGetStep() {
        List<X7S_Adventure_Step__c> testStep = [SELECT Id FROM X7S_Adventure_Step__c];

        x7sAdventureResponse response = x7sAdventureBaseController.getAdventure(testStep[0].Id, 'X7S_Adventure_Step__c', true, '');

        System.assertEquals(1, response.adventureResults[0].adventureStepWrapper.size());
        for (x7sAdventureStepWrapper each : response.adventureResults[0].adventureStepWrapper) {
            System.assertEquals(x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME, each.stepName);
        }
    }

    /**
     * Sends a module Id and the details for that module are returned.
     */
    @IsTest
    public static void testGetModule() {
        List<X7S_Adventure_Module__c> testModule = [SELECT Id FROM X7S_Adventure_Module__c];

        x7sAdventureResponse response = x7sAdventureBaseController.getAdventure(testModule[0].Id, 'X7S_Adventure_Module__c', true, '');

        System.assertEquals(1, response.adventureResults[0].adventureStepWrapper[0].stepModuleWrapperList.size());
        for (x7sAdventureStepModuleWrapper each : response.adventureResults[0].adventureStepWrapper[0].stepModuleWrapperList) {
            System.assertEquals(x7sAdventureTestConstants.TEST_STEP_MODULE_NAME, each.title);
        }
    }

    @IsTest
    public static void testGetNavigation() {
        X7S_Adventure__c adventure = [SELECT Id FROM X7S_Adventure__c LIMIT 1];
        User taskOwner = [SELECT Id FROM User WHERE Username = 'Adventure.Learning@Test.com' LIMIT 1];

        X7S_Adventure_Step__c testAdventureStep2 = new X7S_Adventure_Step__c(Name = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME,
                Title__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME, Adventure__c = adventure.Id, Order__c = 1,
                Subtitle__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_SUBTITLE, Description__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_DESCRIPTION);
        insert testAdventureStep2;

        //Create test Step Module
        X7S_Adventure_Module__c testStepModule2 = new X7S_Adventure_Module__c(Name = x7sAdventureTestConstants.TEST_STEP_MODULE_NAME,
                Title__c = x7sAdventureTestConstants.TEST_STEP_MODULE_NAME, Adventure_Step__c = testAdventureStep2.Id, Order__c = 0);
        insert testStepModule2;

        //Create test Module Task
        X7S_Adventure_Task__c testModuleTask2 = new X7S_Adventure_Task__c(Name = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Adventure_Module__c = testStepModule2.Id, Owner__c = taskOwner.Id,
                Order__c = 0, Completed__c = false);
        insert testModuleTask2;

        X7S_Adventure_Step__c testAdventureStep3 = new X7S_Adventure_Step__c(Name = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME,
                Title__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME, Adventure__c = adventure.Id, Order__c = 2,
                Subtitle__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_SUBTITLE, Description__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_DESCRIPTION);
        insert testAdventureStep3;

        List<X7S_Adventure_Module__c> testModule = [SELECT Id FROM X7S_Adventure_Module__c];
        List<X7S_Adventure_Step__c> testStep = [SELECT Id FROM X7S_Adventure_Step__c];

        x7sAdventureNavigationWrapperItem testNavigationWrapperItem = new x7sAdventureNavigationWrapperItem();
        System.assertNotEquals(null, testNavigationWrapperItem);

        x7sAdventureNavigationWrapper moduleResponse = x7sAdventureBaseController.getAdventureNavigation(testModule[0].Id, 'X7S_Adventure_Module__c');
        System.assertEquals(moduleResponse.adventure.Id, adventure.Id);
        x7sAdventureNavigationWrapper stepResponse = x7sAdventureBaseController.getAdventureNavigation(testStep[0].Id, 'X7S_Adventure_Step__c');
        System.assertEquals(stepResponse.adventure.Id, adventure.Id);

    }

    @IsTest
    public static void testSaveSubTaskResponse() {
        X7S_Adventure_Subtask__c subtask = [SELECT Id, Response_Input__c, Completed__c FROM X7S_Adventure_Subtask__c];
        System.assertEquals(subtask.Response_Input__c, 'Test');

        x7sAdventureResponse response = x7sAdventureBaseController.saveUserResponseSubTask(subtask.Id, 'I have changed');
        System.assertEquals(response.success, true);

        X7S_Adventure_Subtask__c subtaskUpdate = [SELECT Id, Response_Input__c, Completed__c FROM X7S_Adventure_Subtask__c WHERE Id = :subtask.Id];
        System.assertEquals(subtaskUpdate.Response_Input__c, 'I have changed');
    }

    @IsTest
    public static void testSaveSubTaskResponses() {
        X7S_Adventure_Subtask__c subtask = [SELECT Id, Response_Input__c, Completed__c FROM X7S_Adventure_Subtask__c];
        //x7sAdventureBaseController.SubTaskResponse subTaskResp = new x7sAdventureBaseController.SubTaskResponse();
        //subTaskResp.id = subtask.Id;
        //subTaskResp.userResponse = 'I have changed';
        //List<x7sAdventureBaseController.SubTaskResponse> subTaskResponse = new List<x7sAdventureBaseController.SubTaskResponse>();
        //subTaskResponse.add(subTaskResp);

        x7sAdventureResponse response = x7sAdventureBaseController.saveUserResponseSubTask(subtask.Id, 'I have changed');
        System.assertEquals(response.success, true);
    }

    /**
     * Tests the 3 scenarios for the getActiveAdventures method
     * -User is not associated with an account
     * -Account doesn't have an active adventure
     * -User is associated with an account that has an active adventure
     */
    @IsTest
    public static void testGetActiveAdventures() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

//        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User Clone' LIMIT 1];
//
//        User testUser = new User(LastName = 'LIVESTON', FirstName = 'JASON', Alias = 'jliv', Email = 'jason.liveston@asdf.com',
//                Username = 'Adventure.Learning2@Test.com', ProfileId = profileId.Id, TimeZoneSidKey = 'GMT',
//                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US', ContactId = testContact.Id);
//        insert testUser;
//
//        System.runAs(testUser) {
            x7sAdventureResponse responseUserHasNoActiveAdventures = x7sAdventureBaseController.getActiveAdventures();
//            System.assertEquals(responseUserHasNoActiveAdventures.success, false);
//            System.assertEquals(responseUserHasNoActiveAdventures.messages[0], 'No active adventures found for user.');

            X7S_Adventure__c testAdventure = [SELECT Id, Account__c FROM X7S_Adventure__c LIMIT 1];
            testAdventure.Account__c = testAccount.Id;
            testAdventure.Active__c = true;
            update testAdventure;

            x7sAdventureResponse response = x7sAdventureBaseController.getActiveAdventures();
//            System.assertEquals(response.success, true);
//        }

        x7sAdventureResponse responseUserHasNoAdventures = x7sAdventureBaseController.getActiveAdventures();
        System.assertEquals(responseUserHasNoAdventures.success, false);
        System.assertEquals(responseUserHasNoAdventures.messages[0], 'User does not appear to be associated with an account.');
    }

    @IsTest
    public static void test_getConfiguration() {
        X7S_Adventure_Setting__mdt configuration = x7sAdventureBaseController.getConfiguration('Default');
        System.assertNotEquals(null, configuration);
    }

    @IsTest
    public static void test_getLeaderboardData() {

        Test.startTest();

        List<X7S_Adventure__c> testAdventures = [SELECT Id FROM X7S_Adventure__c LIMIT 5];

        x7sAdventureBaseController.LeaderboardData leaderboardData = new x7sAdventureBaseController.LeaderboardData();
        leaderboardData = x7sAdventureBaseController.getLeaderboardData('', '5', true, 'Module Percent Complete Descending');
        System.assertEquals(leaderboardData.adventureWrapper.size() , testAdventures.size());

        testAdventures[0].Active__c = false;
        update testAdventures;

        leaderboardData = x7sAdventureBaseController.getLeaderboardData('', '5', false, 'Task Percent Complete Descending');
        System.assertEquals(leaderboardData.adventureWrapper.size() , 0);

        Test.stopTest();
    }
}