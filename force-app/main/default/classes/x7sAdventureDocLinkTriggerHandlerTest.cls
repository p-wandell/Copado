/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sAdventureDocLinkTriggerHandlerTest {
    @TestSetup
    static void testSetup() {
        X7S_Adventure__c testAdventure = new X7S_Adventure__c(Name = x7sAdventureTestConstants.TEST_ADVENTURE_NAME, Title__c = x7sAdventureTestConstants.TEST_ADVENTURE_NAME);
        insert testAdventure;

        Account testAccount = new Account();
        testAccount = x7sAdventureTestUtils.createTestAccount();

        String base64Data = EncodingUtil.urlDecode(x7sAdventureTestConstants.BASE_64_FILE, 'UTF-8');

        ContentVersion fileVersion = new ContentVersion();
        fileVersion.VersionData = EncodingUtil.base64Decode(base64Data);
        fileVersion.Title = x7sAdventureTestConstants.FILE_NAME;
        fileVersion.PathOnClient = '/' + x7sAdventureTestConstants.FILE_NAME;
        fileVersion.ContentLocation = 'S';
        fileVersion.IsMajorVersion = false;
        insert fileVersion;
    }
    @IsTest
    static void accountLinkTest() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1][0];
        ContentVersion uploadedFile = [SELECT Id, ContentDocumentId FROM ContentVersion];
        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.ContentDocumentId = uploadedFile.ContentDocumentId;
        fileLink.LinkedEntityId = testAccount.Id;
        fileLink.ShareType = 'I';
        insert fileLink;
        ContentDocumentLink resultLink = [SELECT Id, Visibility FROM ContentDocumentLink WHERE Id = :fileLink.Id];
        System.assertNotEquals('AllUsers', resultLink.Visibility);
    }
    @IsTest
    static void quickLinkTest() {
        X7S_Adventure__c testLink = [SELECT Id FROM X7S_Adventure__c LIMIT 1][0];
        ContentVersion uploadedFile = [SELECT Id, ContentDocumentId FROM ContentVersion];
        ContentDocumentLink fileLink = new ContentDocumentLink();
        fileLink.ContentDocumentId = uploadedFile.ContentDocumentId;
        fileLink.LinkedEntityId = testLink.Id;
        fileLink.ShareType = 'I';
        insert fileLink;
        ContentDocumentLink resultLink = [SELECT Id, Visibility FROM ContentDocumentLink WHERE Id = :fileLink.Id];
        System.assertEquals('AllUsers', resultLink.Visibility);
    }
}