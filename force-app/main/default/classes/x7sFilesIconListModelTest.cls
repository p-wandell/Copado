/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
private class x7sFilesIconListModelTest {
	@IsTest
	static void testBehavior() {
		x7sFilesIconListModel listModel = new x7sFilesIconListModel();
		System.assertNotEquals(null, listModel);
		System.assertNotEquals(null, listModel.fileIconList);
	}

	@IsTest
	static void test_FilesIconModel() {
		x7sFilesIconModel iconModel = new x7sFilesIconModel();
		System.assertEquals('', iconModel.fileType);
		System.assertEquals('', iconModel.iconName);
		System.assertEquals(false, iconModel.showPreview);
	}
}