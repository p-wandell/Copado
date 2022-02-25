/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
private class x7sFilesItemModelTest {

	@TestSetup
	static void setupData() {
		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('Default');

		List<X7S_File_Folder__c> testFiles = new List<X7S_File_Folder__c>();
		X7S_File_Folder__c testFolder = new X7S_File_Folder__c(Name = 'Folder1', Description__c = 'This is a test folder', Sharing_Setting__c = setting.Id);
		insert testFolder;
	}

	@IsTest
	static void testBehavior() {
        X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('Default');
        x7sFilesIconListModel model = x7sFilesItemModel.getIconListModel(setting);
        System.assertNotEquals(null, model);
		model = x7sFilesItemModel.getIconListModel(null);
		System.assertEquals(null, model);
	}

	@IsTest
	static void test_getIconSettingForFiles() {
		X7S_File_Folder__c folder = [SELECT Id, Name, Sharing_Setting__c FROM X7S_File_Folder__c WHERE Name = 'Folder1' LIMIT 1];
		x7sFilesIconListModel model = x7sFilesItemModel.getIconSettingForFiles(folder.Id);
		System.assertNotEquals(null, model);
	}

	@IsTest
	static void test_x7sFilesItemModel() {
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

		x7sFilesItemModel model = new x7sFilesItemModel(contentLink);
		System.assertNotEquals(null, model);
	}
}