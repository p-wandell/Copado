/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

@IsTest
private class x7sNewsDocumentLinkHelperTest {
	@IsTest
	static void testDocumentLinkHelper() {
		X7S_News__c newsObj = x7sNewsUtilityTest.createNews();

		if (newsObj.Id != null) {
			ContentVersion contentVersionInsert = new ContentVersion(
				Title = 'Test news content trigger',
				PathOnClient = 'Test.jpg',
				VersionData = Blob.valueOf('Test Content Data'),
				//FirstPublishLocationId = newsObj.Id,
				IsMajorVersion = true
			);
			insert contentVersionInsert;

			// Test INSERT
			ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
			System.assertNotEquals(null, contentVersionSelect);

			List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
			System.assertEquals(documents.size(), 1);

			// attempt to fire the trigger
			ContentDocumentLink contentLink = new ContentDocumentLink();
			contentLink.LinkedEntityId = newsObj.Id;
			contentLink.ShareType = 'V';
			contentLink.ContentDocumentId = documents[0].Id;
			insert contentLink;
			System.debug('Content link inserted: ' + contentLink.Id);
		}
	}
}