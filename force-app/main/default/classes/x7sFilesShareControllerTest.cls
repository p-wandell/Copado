/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
private class x7sFilesShareControllerTest {
	@IsTest
	static void setupData() {
		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('Default');

		List<X7S_File_Folder__c> testFiles = new List<X7S_File_Folder__c>();
		X7S_File_Folder__c testFolder = new X7S_File_Folder__c(Name = 'Folder1', Description__c = 'This is a test folder', Sharing_Setting__c = setting.Id);
		insert testFolder;

		testFiles.add(new X7S_File_Folder__c(Name = 'TestFile0', Description__c = 'This is Test TestFile0', Parent_Folder__c = testFolder.Id));
		testFiles.add(new X7S_File_Folder__c(Name = 'TestFile1', Description__c = 'This is Test TestFile1', Parent_Folder__c = testFolder.Id));
		testFiles.add(new X7S_File_Folder__c(Name = 'TestFile2', Description__c = 'This is Test TestFile2', Parent_Folder__c = testFolder.Id));
		insert testFiles;

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
	static void test_shareCurrentFolder() {
		setupData();
		X7S_File_Folder__c folder = [SELECT Id, Name FROM X7S_File_Folder__c WHERE Name = 'Folder1' LIMIT 1];
		System.debug('Folder: ' + folder.Name);
		Boolean result = x7sFilesShareController.shareCurrentFolder(folder.Id);
		System.assertNotEquals(null, result);
	}

	@IsTest(SeeAllData=true)
	static void test_shareFolder() {
		setupData();

		Test.startTest();

		X7S_File_Folder__c folder = [SELECT Id, Name, Sharing_Setting__c FROM X7S_File_Folder__c WHERE Name = 'Folder1' LIMIT 1];
		System.debug('Folder: ' + folder.Name);

		// custom logic
		System.assertNotEquals(false, x7sFilesShareController.shareFolder(folder));

		List<X7S_File_Folder__Share> shares = [SELECT Id, ParentId, UserOrGroupId, RowCause, AccessLevel FROM X7S_File_Folder__Share WHERE RowCause = :x7sFilesShareController.X7S_ROW_CAUSE LIMIT 200];

		System.debug('test share dump: ' + shares.size());
		for (X7S_File_Folder__Share share : shares) {
			System.debug(share);
		}
		System.assertNotEquals(null, shares);

		// AND logic
		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('Default2');
		folder.Sharing_Setting__c = setting.Id;
		x7sFilesShareController.shareFolder(folder);
		System.assertNotEquals(false, x7sFilesShareController.shareFolder(folder));

		Test.stopTest();
	}

	@IsTest
	static void test_updateFolderSetting() {
		setupData();
		Test.startTest();
		X7S_File_Folder__c folder = [SELECT Id, Name FROM X7S_File_Folder__c WHERE Name = 'Folder1' LIMIT 1];
		x7sFilesFolder folderItem = x7sFilesController.getFolder(folder.Id);
		folderItem.sharingSetting = '12345';
		Boolean result = x7sFilesShareController.updateFolderSetting(folder.Id, '1234');
		System.assertEquals(true, result);
		Test.stopTest();
	}

	@IsTest
	static void test_getFileSettings() {
		Map<String, String> settings = x7sFilesShareController.getFolderSettings();
		System.assertNotEquals(null, settings);
		System.debug('settings: ' + settings.size());
	}

	@IsTest
	static void test_addUserIds() {
		Set<String> set1 = new Set<String>();
		Set<String> set2 = new Set<String>();

		System.assertEquals(0, x7sFilesShareController.addUserIds(set1, set2, '').size());
		set1.add('0051');
		System.assertEquals(0, x7sFilesShareController.addUserIds(set1, set2, 'and').size());
		set2.add('0052');
		System.assertEquals(0, x7sFilesShareController.addUserIds(set1, set2, 'and').size());
		System.assertEquals(2, x7sFilesShareController.addUserIds(set1, set2, 'or').size());
		set1.add('0052');
		System.assertEquals(1, x7sFilesShareController.addUserIds(set1, set2, 'and').size());
		System.assertEquals(2, x7sFilesShareController.addUserIds(set1, set2, 'or').size());

		set1.clear();
		System.assertEquals(0, x7sFilesShareController.addUserIds(set1, set2, 'and').size());
		System.assertEquals(1, x7sFilesShareController.addUserIds(set1, set2, 'or').size());
	}

	@IsTest
	static void test_getCriteriaFromClause() {
		System.assertEquals(' FROM Contact', x7sFilesShareController.getCriteriaFromClause('Contact'));
	}

	@IsTest
	static void test_getCriteriaWhereClause() {
		System.assertEquals('WHERE field1 = \'abc\''.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'Equals', 'abc').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  != \'abc\''.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'NotEquals', 'abc').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1 > \'abc\''.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'GreaterThan', 'abc').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  >= 10'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'number', 'GreaterEqual', '10').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1 < 10'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'number', 'LessThan', '10').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1 <= 10'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'number', 'LessEqual', '10').replaceAll('(\\s+)', ''));

		System.assertEquals('WHERE field1  >= \'abc\''.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'GreaterEqual', 'abc').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  INCLUDES  ( \'abc\' )'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'multi-picklist', 'Includes', '\'abc\'').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  INCLUDES  ( \'a\',\'b\' )'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'multi-picklist', 'Includes', 'a,b').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  EXCLUDES  ( \'a\',\'b\' )'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'multi-picklist', 'Excludes', 'a,b').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  INCLUDES  ( \'a\',\'b\' )'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'multi-picklist', 'Includes', 'a , b').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  INCLUDES  ( \'a\',\'b\' )'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'multi-picklist', 'Includes', '\'a\',\'b\'').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  INCLUDES  ( \'a;b\' )'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'multi-picklist', 'Includes', 'a;b').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  EXCLUDES  ( \'a;b\' )'.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'multi-picklist', 'Excludes', 'a;b').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  =   \'B\''.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'Equals', 'B').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  LIKE   \'abc%\''.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'Contains', 'abc%').replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE NOT field1 LIKE   \'abc%\''.replaceAll('(\\s+)', ''),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'NotContains', 'abc%').replaceAll('(\\s+)', ''));
	}

	@IsTest
	static void test_EqualsNoEqualsNull() {
		String fieldValue = '';
		System.assertEquals('WHERE field1 = null'.replaceAll('(\\s+)', fieldValue),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'Equals', fieldValue).replaceAll('(\\s+)', ''));
		System.assertEquals('WHERE field1  != null'.replaceAll('(\\s+)', fieldValue),
			x7sFilesShareController.getCriteriaWhereClause('field1', 'text', 'NotEquals', fieldValue).replaceAll('(\\s+)', ''));
	}

	@IsTest
	static void test_setupCustomLogic() {
		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('Default');
		x7sFilesCriteriaListModel criteriaListModel = x7sFilesController.getCriteriaValues(setting.Id);

		x7sFilesShareLogicController.Node root = x7sFilesShareController.setupCustomLogic(criteriaListModel.customLogic);
		System.assertNotEquals(null, root);
	}

	@IsTest
	static void test_defaultLogicNone() {
		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('LogicNone');
		x7sFilesCriteriaListModel criteriaListModel = x7sFilesController.getCriteriaValues(setting.Id);
		System.assertEquals('AND', criteriaListModel.defaultLogic);
	}

	@IsTest
	static void test_containsShare() {
		setupData();
		X7S_File_Folder__c folder = [SELECT Id, Name FROM X7S_File_Folder__c WHERE Name = 'Folder1' LIMIT 1];
		List<X7S_File_Folder__Share> shareList = new List<X7S_File_Folder__Share>();
		X7S_File_Folder__Share shareItem = new X7S_File_Folder__Share(
			ParentId = folder.Id, UserOrGroupId=null, RowCause='Custom__c', AccessLevel='READ'
		);
		shareList.add(shareItem);
		System.assertEquals(true, x7sFilesShareController.containsShare(shareList, shareItem));
		X7S_File_Folder__Share shareItem2 = new X7S_File_Folder__Share(
			ParentId = null, UserOrGroupId=null, RowCause='Custom__c', AccessLevel='READ'
		);
		System.assertEquals(false, x7sFilesShareController.containsShare(shareList, shareItem2));
	}
}