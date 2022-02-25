/*
 * Copyright (c) 2020. 7Summits Inc.
 */
@IsTest
public with sharing class x7sAdventureMyStepModuleWrapperTest {

    @TestSetup
    public static void testSetup() {

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
                Adventure_Module__c = testStepModule.Id);
        insert testModuleTask;
        X7S_Adventure_Task__c testModuleTask_1 = new X7S_Adventure_Task__c(Name = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Completed__c = x7sAdventureTestConstants.TEST_MODULE_TASK_Completed,
                Adventure_Module__c = testStepModule.Id);
        insert testModuleTask_1;
        X7S_Adventure_Task__c testModuleTask_2 = new X7S_Adventure_Task__c(Name = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureTestConstants.TEST_RESOURCE_TYPE, Completed__c = x7sAdventureTestConstants.TEST_MODULE_TASK_Completed,
                Adventure_Module__c = testStepModule.Id);
        insert testModuleTask_2;

    }

    @IsTest
    public static void x7s_AdventureMyStepModuleWrapperHelperTest() {

        X7S_Adventure_Module__c testModule = [SELECT Id,Adventure_Step__c,Title__c,Description_Label__c,Description_URL__c,Tooltip_Description__c,Order__c FROM X7S_Adventure_Module__c LIMIT 1];
        List<X7S_Adventure_Task__c> testModuleTask = [SELECT Id,Completed__c,Task_Due_Date__c FROM X7S_Adventure_Task__c WHERE Adventure_Module__c = :testModule.Id];

        x7sAdventureStepModuleWrapper TestStepModule = x7sAdventureMyStepModuleWrapperHelper.createWrapper(testModule, testModuleTask);
        System.assertEquals(TestStepModule.taskProgress, 100);
        System.assertEquals(TestStepModule.completedFlag, true);

    }
}