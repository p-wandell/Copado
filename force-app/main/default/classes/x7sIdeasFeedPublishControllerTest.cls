/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sIdeasFeedPublishControllerTest {
	@IsTest
	static void test_FeedPublishController() {
		// create an idea
		Community currCommunity = [SELECT Id, Name FROM Community WHERE IsActive = TRUE LIMIT 1];
		Idea currIdea = new Idea(Title = 'test is awesome', CommunityId = currCommunity.Id);

		insert currIdea;

		// add the extension - regardless of the setting
		x7sIdeasFeedPublishController.IdeaExtension ideaExt = x7sIdeasFeedPublishController.getExtensionId(currIdea.Id);
		System.assertNotEquals(null, ideaExt);

		// test the File Details
		List<ContentDocument> files = x7sIdeasFeedPublishController.getAllRelatedFilesDetails(currIdea.Id, false, 'AllUsers', '1');
		System.assertNotEquals(null, files);
	}
}