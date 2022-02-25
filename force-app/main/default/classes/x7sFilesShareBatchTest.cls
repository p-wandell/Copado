/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */
@IsTest
public with sharing class x7sFilesShareBatchTest {
	@TestSetup
	public static void testSetup() {
		// setup test data
		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('Default');

		X7S_File_Folder__c testFolder = new X7S_File_Folder__c(Name = 'Folder1', Description__c = 'This is a test folder', Sharing_Setting__c = setting.Id);
		insert testFolder;
		ContentVersion contentVersionInsert = new ContentVersion(Title = 'Test', PathOnClient = 'Test1.pdf', VersionData = Blob.valueOf('Test Content Data'), IsMajorVersion = true);
		insert contentVersionInsert;

		ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
		List<ContentDocument> documents = [SELECT Id, Title,CreatedDate,LatestPublishedVersionId FROM ContentDocument];
		System.assertNotEquals(0, documents.size());

		List<X7S_File_Folder__c> file1 = [SELECT Id FROM X7S_File_Folder__c WHERE Name = 'Folder1' LIMIT 1];
		ContentDocumentLink contentLink = new ContentDocumentLink();
		contentLink.LinkedEntityId = file1[0].Id;
		contentLink.ContentDocumentId = documents[0].Id;
		contentLink.Visibility = 'AllUsers';
		insert contentLink;
	}

	@IsTest
	static void test_shareBatch() {
		Test.startTest();
		x7sFilesShareBatch activityBatch = new x7sFilesShareBatch();
		Id batchId = Database.executeBatch(activityBatch, 200);
		System.assertNotEquals(null, batchId);
		Test.stopTest();
	}
}