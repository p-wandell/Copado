/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sAdventureContentObjectTest {

    @testSetup
    static void testSetup() {
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
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Adventure_Module__c = testStepModule.Id);
        insert testModuleTask;
    }

    @isTest
    public static void test_ContentObject() {

        List<X7S_Adventure__c> testAdventures = [SELECT Id, Name FROM X7S_Adventure__c];
        List<X7S_Adventure_Step__c> testAdventureSteps = [
                SELECT Id, Name, title__c, subtitle__c, description__c, Order__c,
                        Module_Progress__c, Task_Progress__c, (SELECT Id FROM ContentDocumentLinks)
                FROM X7S_Adventure_Step__c
        ];

        List<X7S_Adventure_Module__c> testStepModules = [
                SELECT Id, Name, Adventure_Step__c, title__c,Order__c,
                        Description_Label__c,Description_URL__c,Tooltip_Description__c,Task_Progress__c,Completed__c
                FROM X7S_Adventure_Module__c
        ];

        List<X7S_Adventure_Task__c> testStepModuleTasks = [SELECT Id, Name, Task_Due_Date__c, Owner__c FROM X7S_Adventure_Task__c];

        x7sAdventureStepModuleWrapper testStepWrapper = x7sAdventureStepModuleWrapperHelper.createWrapper(testStepModules[0], testStepModuleTasks);
        List<x7sAdventureStepModuleWrapper> testWrapperList = new List<x7sAdventureStepModuleWrapper>();
        testWrapperList.add(testStepWrapper);

        Id testUserId = UserInfo.getUserId();
        x7sAdventureStepWrapper testWrapper = x7sAdventureStepWrapperHelper.createWrapper(testAdventureSteps[0], testWrapperList, testUserId);
        List<x7sAdventureStepWrapper> stepWrapperList = new List<x7sAdventureStepWrapper>();
        stepWrapperList.add(testWrapper);

        Test.startTest();

        x7sAdventureContentObject contentObject = new x7sAdventureContentObject();
        contentObject.adventure = testAdventures[0];
        contentObject.adventureStepWrapper = stepWrapperList;

        System.debug('ADVENTURE ==' + contentObject.adventureStepWrapper);

        System.assertEquals(contentObject.adventure.Name, x7sAdventureTestConstants.TEST_ADVENTURE_NAME);
        System.assertEquals(contentObject.adventureStepWrapper[0].Id, testAdventureSteps[0].Id);

        Test.stopTest();
    }

}