/*
 * Copyright (c) 2020. 7Summits Inc.
 */
@IsTest
public with sharing class x7sAdventureModuleTasksTest {
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
                Title__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_NAME, Adventure__c = testAdventure.Id,
                Subtitle__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_SUBTITLE, Description__c = x7sAdventureTestConstants.TEST_ADVENTURE_STEP_DESCRIPTION);
        insert testAdventureStep;

        //Create test Step Module
        X7S_Adventure_Module__c testStepModule = new X7S_Adventure_Module__c(Name = x7sAdventureTestConstants.TEST_STEP_MODULE_NAME,
                Title__c = x7sAdventureTestConstants.TEST_STEP_MODULE_NAME, Adventure_Step__c = testAdventureStep.Id);
        insert testStepModule;

        //Create test Module Task
        X7S_Adventure_Task__c testModuleTask = new X7S_Adventure_Task__c(Name = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Completed__c = x7sAdventureTestConstants.TEST_MODULE_TASK_Completed,
                Adventure_Module__c = testStepModule.Id, Owner__c = taskOwner.Id);
        insert testModuleTask;

        X7S_Adventure_Task__c testModuleTask_1 = new X7S_Adventure_Task__c(Name = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Completed__c = x7sAdventureTestConstants.TEST_MODULE_TASK_Completed,
                Adventure_Module__c = testStepModule.Id, Owner__c = taskOwner.Id);
        insert testModuleTask_1;

        X7S_Adventure_Task__c testModuleTask_2 = new X7S_Adventure_Task__c(Name = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Completed__c = x7sAdventureTestConstants.TEST_MODULE_TASK_Completed,
                Adventure_Module__c = testStepModule.Id, Owner__c = taskOwner.Id);
        insert testModuleTask_2;

    }

    @IsTest
    public static void myModuleTaskWrapperHelperTest() {

        User ownerId = [SELECT Id FROM User WHERE Email = 'jason.liveston@asdf.com' LIMIT 1];
        X7S_Adventure__c myAdventure = [SELECT Id FROM X7S_Adventure__c WHERE Name = :x7sAdventureTestConstants.TEST_ADVENTURE_NAME LIMIT 1];

        List<X7S_Adventure_Task__c> tasksList = [SELECT Id,Completed__c FROM X7S_Adventure_Task__c WHERE Owner__c = :ownerId.Id];

        Boolean TestTaskCompleted = x7sAdventureModuleTasks.taskCompleted(tasksList[0].Id, false);
        System.assertEquals(TestTaskCompleted, false);

        List<X7S_Adventure_Module__c> selectedModule = [SELECT Id,Completed__c FROM X7S_Adventure_Module__c];
        X7S_Adventure_Module__c testModule = x7sAdventureModuleTasks.getModuleTaskProgress(selectedModule[0].Id);
        System.assertEquals(testModule.Completed__c, false);

        x7sAdventureMyModuleTaskWrapper testResult = x7sAdventureModuleTasks.getMyModuleTaskProgress(selectedModule[0].Id, ownerId.Id);
        System.assertEquals(testResult.TaskProgress, 67);
        System.assertEquals(testResult.Completed, false);

        x7sAdventureMyProgress testMyAdventureMyProgress = x7sAdventureModuleTasks.getMyAdventureProgress(myAdventure.Id, ownerId.Id);
        System.assertEquals(testMyAdventureMyProgress.totalCompletedTasks, 2);
        System.assertEquals(testMyAdventureMyProgress.totalTasksAssigned, 3);

        x7sAdventureMyProgress testAdventureMyProgress = x7sAdventureModuleTasks.getAdventureProgress(myAdventure.Id);
        System.assertEquals(testAdventureMyProgress.totalCompletedTasks, 2);
        System.assertEquals(testAdventureMyProgress.totalTasksAssigned, 3);
    }
}