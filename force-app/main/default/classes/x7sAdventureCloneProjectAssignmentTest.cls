/*
 * Copyright (c) 2020. 7Summits Inc.
 */
@IsTest
public with sharing class x7sAdventureCloneProjectAssignmentTest {


    @TestSetup
    public static void TestSetup() {
        //Create test adventure
        Account testAccount = new Account(Name = x7sAdventureCloneTestConstants.ACCOUNT_NAME);
        insert testAccount;


        //Create test adventure
        X7S_Adventure__c testAdventure = new X7S_Adventure__c(Name = x7sAdventureCloneTestConstants.TEST_ADVENTURE_NAME, Title__c = x7sAdventureCloneTestConstants.TEST_ADVENTURE_NAME,
                Account__c = testAccount.Id, Template__c = x7sAdventureCloneTestConstants.TEST_TEMPLATE_NAME, Allow_Cloning__c=true);
        insert testAdventure;

        //Create ContentVersion
        ContentVersion testContentVersion = new ContentVersion(Title = x7sAdventureCloneTestConstants.TEST_CONTENT_VERSION_TITLE, PathOnClient = x7sAdventureCloneTestConstants.TEST_CONTENT_VERSION_PATH_ON_CLIENT, VersionData = x7sAdventureCloneTestConstants.TEST_CONTENT_VERSION_VERSION_DATA, IsMajorVersion = x7sAdventureCloneTestConstants.TEST_CONTENT_VERSION_IS_MAJOR_VERSION);
        insert testContentVersion;

        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentVersion.Id].ContentDocumentId;
        //Create ContentDocumentLink
        ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId = testAdventure.Id, ContentDocumentId = conDocId, ShareType = 'V');
        insert cdl;

        //Create test Adventure Step
        X7S_Adventure_Step__c testAdventureStep = new X7S_Adventure_Step__c(Name = x7sAdventureCloneTestConstants.TEST_ADVENTURE_STEP_NAME,
                Title__c = x7sAdventureCloneTestConstants.TEST_ADVENTURE_STEP_NAME, Adventure__c = testAdventure.Id,
                Subtitle__c = x7sAdventureCloneTestConstants.TEST_ADVENTURE_STEP_SUBTITLE, Description__c = x7sAdventureCloneTestConstants.TEST_ADVENTURE_STEP_DESCRIPTION);
        insert testAdventureStep;

        //Create test Step Module
        X7S_Adventure_Module__c testStepModule = new X7S_Adventure_Module__c(Name = x7sAdventureCloneTestConstants.TEST_STEP_MODULE_NAME,
                Title__c = x7sAdventureCloneTestConstants.TEST_STEP_MODULE_NAME, Adventure_Step__c = testAdventureStep.Id);
        insert testStepModule;

        //Create test Module Task
        X7S_Adventure_Task__c testModuleTaskFirst = new X7S_Adventure_Task__c(Name = x7sAdventureCloneTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureCloneTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureCloneTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureCloneTestConstants.TEST_RESOURCE_TYPE, Adventure_Module__c = testStepModule.Id, Restrict_to_User__c = x7sAdventureCloneTestConstants.TEST_MODULE_TASK_RESTRICT_TO_USER);
        insert testModuleTaskFirst;

        X7S_Adventure_Task__c testModuleTaskSecond = new X7S_Adventure_Task__c(Name = x7sAdventureCloneTestConstants.TEST_MODULE_TASK_NAME,
                Title__c = x7sAdventureCloneTestConstants.TEST_MODULE_TASK_NAME, Content_URL__c = x7sAdventureCloneTestConstants.TEST_URL,
                Resource_Type__c = x7sAdventureCloneTestConstants.TEST_RESOURCE_TYPE, Adventure_Module__c = testStepModule.Id, Restrict_to_User__c = x7sAdventureCloneTestConstants.TEST_MODULE_TASK_RESTRICT_TO_USER);
        insert testModuleTaskSecond;

        //Create and Associate Topics
        List<Topic> topics = x7sAdventureTestUtils.createTopic(3);  
        List<TopicAssignment> topicAssignmentList = new List<TopicAssignment>();    
        for(Topic topic : topics) {
            topicAssignmentList.add(new TopicAssignment(EntityId = testAdventure.Id, TopicId = topic.Id));      
        }
        if(topicAssignmentList.size() > 0) {
            insert topicAssignmentList;
        }

    }

    @IsTest
    public static void test_AdventureCloneProjectAssignment() {

        X7S_Adventure__c testAdventure = [SELECT Id FROM X7S_Adventure__c WHERE Name = :x7sAdventureCloneTestConstants.TEST_ADVENTURE_NAME];

        X7S_Adventure__c testClone = [SELECT Id,Name,Title__c FROM X7S_Adventure__c WHERE Id = :testAdventure.Id];
        List<X7S_Adventure__c> testAdventures = [SELECT Id, Name FROM X7S_Adventure__c WHERE Id = :testAdventure.Id];
        Integer adventureCount = [SELECT COUNT() FROM X7S_Adventure__c];
        Integer stepsCount = [SELECT COUNT() FROM X7S_Adventure_Step__c];
        Integer moduleCount = [SELECT COUNT() FROM X7S_Adventure_Module__c];
        Integer tasksCount = [SELECT COUNT() FROM X7S_Adventure_Task__c];

        Test.startTest();
        x7sAdventureCloneResponse cloneResponse = x7sAdventureCloneProjectAssignment.getConfiguration(testAdventure.Id);
        System.assertEquals(x7sAdventureCloneTestConstants.TEST_ADVENTURE_NAME + ' Copy', cloneResponse.clonedAdventureName);

        x7sAdventureCloneProjectAssignment.cloneAdventure(testAdventure.Id, x7sAdventureCloneTestConstants.TEST_ADVENTURE_NAME, false, '');
        System.assertEquals([SELECT COUNT() FROM X7S_Adventure__c], adventureCount + 1);
        System.assertEquals([SELECT COUNT() FROM X7S_Adventure_Step__c], stepsCount + 1);
        System.assertEquals([SELECT COUNT() FROM X7S_Adventure_Module__c], moduleCount + 1);
        
        Boolean canClone = x7sAdventureCloneProjectAssignment.checkCanClone(testAdventure.Id);
        System.assertEquals(canClone, true);

        Test.stopTest();
    }

    @IsTest
    public static void testCloneUsers() {
//        String userList = '0055x000008b0I5AAI,005f2000006NCN6AAO,0055x00000BV0ibAAD,005f2000009Na3hAAC,0055x00000BebHOAAZ,0055x00000BedYbAAJ,0055x00000BeeG4AAJ,0055x00000BewdHAAR,005f2000006NCN1AAO,005f2000006ND4PAAW,005f2000007DaUFAA0,005f2000007EtcXAAS,0055x000008b7KJAAY,';

        String              userList        = UserInfo.getUserId();

        X7S_Adventure__c    testAdventure   = [SELECT Id FROM X7S_Adventure__c WHERE Name = :x7sAdventureCloneTestConstants.TEST_ADVENTURE_NAME];
        Integer             adventureCount  = [SELECT COUNT() FROM X7S_Adventure__c];

        Test.startTest();
        x7sAdventureCloneProjectAssignment.CloneUsers(testAdventure.id, true, userList);
        Test.stopTest();

        System.assertEquals(adventureCount + 1, [SELECT COUNT() FROM X7S_Adventure__c]);
    }

//    private static List<User> LoadUsers() {
//        StaticResource  userResource    = [ SELECT Body, ContentType FROM StaticResource WHERE Name = 'TestUsers1'];
//        String          userContent     = userResource.Body.toString();
//        String[]        users           = userContent.split('\n');
//        List<String>    userIds         = new List<String>();
//
//        for (String user : users) {
//            String[] subUsers = user.split(',');
//
//            for (String subUser : subUsers) {
//                userIds.add(subUser.trim());
//            }
//        }
//
//        return [SELECT Id, FirstName, LastName FROM User WHERE Id IN :userIds AND IsActive = TRUE];
//    }
}