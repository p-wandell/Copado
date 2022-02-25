/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
private class x7sFilesControllerTest {
	private static final String DEFAULT_NAME = 'Default';
	private static final String AND_LOGIC = 'AND';
	private static final String CUSTOM_LOGIC = 'Custom';

    public static String strNetworkId {
		get {
			return [SELECT Id FROM Network LIMIT 1][0].Id;
		}
	}

    static void setupData() {
		List<X7S_File_Folder__c> testFiles = new List<X7S_File_Folder__c>();
		testFiles.add(new X7S_File_Folder__c(Name = 'TestFile0', Description__c = 'This is Test TestFile0'));
		testFiles.add(new X7S_File_Folder__c(Name = 'TestFile1', Description__c = 'This is Test TestFile1'));
		testFiles.add(new X7S_File_Folder__c(Name = 'TestFile2', Description__c = 'This is Test TestFile2'));
        insert testFiles;

		List<X7S_File_Folder__c> testFilesUpdate = new List<X7S_File_Folder__c>();
		testFilesUpdate.add(new X7S_File_Folder__c( Name = 'TestFile1', Description__c = 'This is Test TestFile4', Parent_Folder__c = testFiles[0].Id));
        insert testFilesUpdate; 

        ContentVersion contentVersionInsert = new ContentVersion(
			Title = 'Test',
			Description = 'Test',
			PathOnClient = 'Test.pdf',
			VersionData = Blob.valueOf('Test Content Data'),
			IsMajorVersion = true
		);
		insert contentVersionInsert;

		ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
		List<ContentDocument> documents = [SELECT Id, Title,CreatedDate,LatestPublishedVersionId FROM ContentDocument];
		System.assertNotEquals(0, documents.size());

		List<X7S_File_Folder__c> file1 = [SELECT Id FROM X7S_File_Folder__c WHERE Name = 'TestFile0' LIMIT 1];
		ContentDocumentLink contentlink = new ContentDocumentLink();
		contentlink.LinkedEntityId = file1[0].Id;
		contentlink.ContentDocumentId = documents[0].Id;
		contentlink.Visibility = 'AllUsers';
		insert contentlink;

    }

    @IsTest(SeeAllData=true)
	static void testListController() {
		setupData();
        Test.startTest();

	    X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance('Default');
		System.assertNotEquals(null, setting, 'No Master View Setting found with a name Default.');

		x7sFilesModel listModel = x7sFilesController.getFilesList('',10, 1, '', false, false, false,'','');
		System.assertNotEquals(listModel.files.size(),0, 'List must contains items');

        //x7sFilesCriteriaListModel criteriaList = x7sFilesController.getCriteriaValues(settings[0].Label);
        //System.assertNotEquals(criteriaList,null, 'criteria must contains Values');

        //x7sFilesIconListModel IconList = x7sFilesController.getIconValues(setting.DeveloperName);
        //System.assertNotEquals(null, IconList, 'Icons must contains Values');

        //Apply Filters
		x7sFilesController.FilterHelper filter1 = new x7sFilesController.FilterHelper();
		filter1.selectedFileTypeValue = 'pdf';
		Date d = Date.today();
		filter1.selectedFromDate = String.valueOf(d);
		filter1.selectedToDate = String.valueOf(d.addDays(1));
		filter1.selectedModFromDate = String.valueOf(d);
		filter1.selectedModToDate = String.valueOf(d.addDays(1));
		filter1.selectedFileSizeValue = 'greaterThan100KBTO1MB';
		filter1.selectedOwnerId = '';
		filter1.selectedModifierId = '';
		String filterJson1 = JSON.serialize(filter1);

		x7sFilesModel listModel3 = x7sFilesController.getFilesList('', 10, 1, '', false, false, false,'',filterJson1);
		//System.assertEquals(2, listModel3.files.size(), 'List must contains 2 items');

        //Apply Filters
		x7sFilesController.FilterHelper filter2 = new x7sFilesController.FilterHelper();
		filter2.selectedFileTypeValue = 'pdf';
		filter2.selectedFromDate = String.valueOf(d);
		filter2.selectedToDate = String.valueOf(d.addDays(1));
		filter2.selectedModFromDate = String.valueOf(d);
		filter2.selectedModToDate = String.valueOf(d.addDays(1));
		filter2.selectedFileSizeValue = 'lessThan10KB';
		filter2.selectedOwnerId = UserInfo.getUserId();
        filter2.selectedModifierId = UserInfo.getUserId();
		String filterJson2 = JSON.serialize(filter2);

		x7sFilesModel listModel5 = x7sFilesController.getFilesList('', 10, 1, '', false, false, false,'Z to A Name', filterJson2);
//		System.assertEquals(0, listModel5.files.size(), 'List must contains 0 items');

        Map<String,ContentDocument> FileTypes = x7sFilesFilterData.getFileType();
        System.assertNotEquals(FileTypes,null, 'FileTypes must contains Values');

		String fileSize1 =x7sFilesController.getFileSize('greaterThan10KBTo100KB');
		System.assertNotEquals(fileSize1,null, 'FileSize must contains Values');

		String fileSize2 =x7sFilesController.getFileSize('greaterThan1MBTO10MB');
		System.assertNotEquals(fileSize2,null, 'FileSize must contains Values');

		String fileSize3 =x7sFilesController.getFileSize('greaterThan10MBTO50MB');
		System.assertNotEquals(fileSize3,null, 'FileSize must contains Values');

		String fileSize4 =x7sFilesController.getFileSize('greaterThan50MBTO100MB');
		System.assertNotEquals(fileSize4,null, 'FileSize must contains Values');

		String fileSize5 =x7sFilesController.getFileSize('greaterThan100MB');
		System.assertNotEquals(fileSize5,null, 'FileSize must contains Values');
		        
		Map<String,String> Owners = x7sFilesFilterData.getOwners();
        System.assertNotEquals(Owners,null, 'Owners must contains Values');

        Map<String,String> modifierUsers = x7sFilesFilterData.getModifierUsers();
        System.assertNotEquals(modifierUsers,null, 'modifierUsers must contains Values');

		x7sFilesModel listModel4 = x7sFilesController.getFilesList('', null, null,'',false, false, false,'A to Z Name', '');
		System.assertNotEquals(listModel4.files.size(),0, 'List must contains items');

		x7sFilesModel listModel6 = x7sFilesController.getFilesList('', 10, 1, 'Test',true, false, false,'A to Z Name','');
		System.assertNotEquals(listModel6.files.size(),0, 'List must contains items');

		x7sFilesModel listModel7 = x7sFilesController.getFilesList('', 10, 1, 'Test',true, true, false,'A to Z Name','');
		System.assertNotEquals(listModel7.files.size(),0, 'List must contains items');

		x7sFilesModel listModel8 = x7sFilesController.getFilesList('', 10, 1, 'Test',false, false, true,'A to Z Name','');
		System.assertEquals(0,listModel8.files.size(), 'List must not contains items');

		List<X7S_File_Folder__c> testFiles = [SELECT Id, Name, Parent_Folder__c FROM X7S_File_Folder__c LIMIT 200];
		x7sFilesModel listModel9 = x7sFilesController.getFilesList(testFiles[1].Id, 1, 1, '',true, false, false,'A to Z Name','');
		System.assertNotEquals(listModel7.files.size(),0, 'List must contains items');

        Test.stopTest();
    }

	@IsTest
	static void test_getFolders() {
		setupData();

		Test.startTest();
		x7sFilesModel folderModel = x7sFilesController.getFolders('');
		System.debug('folders: ' + folderModel);
		System.assertNotEquals(null, folderModel);

		List<X7S_File_Folder__c> testFiles = [SELECT Id, Name, Parent_Folder__c FROM X7S_File_Folder__c LIMIT 200];
		x7sFilesModel folderModel1 = x7sFilesController.getFolders(testFiles[1].Id);
		System.debug('folders: ' + folderModel1);
		System.assertNotEquals(null, folderModel1);

		Test.stopTest();
	}

	@IsTest
	static void test_getFolder() {
		setupData();

		Test.startTest();
		List<X7S_File_Folder__c> testFiles = [SELECT Id, Name FROM X7S_File_Folder__c LIMIT 200];
		x7sFilesFolder folder = x7sFilesController.getFolder(testFiles[1].Id);
		System.assertNotEquals(null, folder);
		Test.stopTest();
	}

	@IsTest
	static void test_getCriteriaValues() {
		Test.startTest();

		x7sFilesCriteriaListModel invalidCriteria = x7sFilesController.getCriteriaValues('');

		System.assertEquals(null, invalidCriteria);

		x7sFilesCriteriaListModel defaultCriteria = x7sFilesController.getCriteriaValues(DEFAULT_NAME);

		System.assertNotEquals(null, defaultCriteria);
		System.assertEquals(CUSTOM_LOGIC, defaultCriteria.defaultLogic);
		System.assertEquals('(1 AND 2)', defaultCriteria.customLogic);

		Test.stopTest();
	}

	@IsTest
	static void test_getBaseUrl() {
		Test.startTest();
		String baseUrl = x7sFilesController.getBaseUrl();

		System.assertNotEquals(0, baseUrl.length());
		Test.stopTest();
	}

	@IsTest
	static void test_getRecordCount() {
		setupData();
		String fromClause = ' FROM X7S_File_Folder__c';
		List<X7S_File_Folder__c> testFiles = [SELECT Id, Name, Parent_Folder__c FROM X7S_File_Folder__c LIMIT 200];
		Decimal recordCount = x7sFilesController.getRecordCount(fromClause, '', testFiles[1].Id);
		System.assertNotEquals(null, recordCount);
	}

	@IsTest
	static void test_getFilesListByRecordId() {
		setupData();
		List<X7S_File_Folder__c> testFiles = [SELECT Id, Name FROM X7S_File_Folder__c LIMIT 200];
		x7sFilesModel listModel9 = x7sFilesController.getFilesListByRecordId('',10,1,'',false,false,false,'A to Z Name','',testFiles[0].Id);
		System.assertNotEquals(listModel9.files.size(),0, 'List must contains items');

	}
}