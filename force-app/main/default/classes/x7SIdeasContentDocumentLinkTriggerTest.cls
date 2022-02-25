/*
 * Copyright (c) 2021. 7Summits Inc.
 */

/**
 * Created by francois.korb on 1/6/21.
 */

@IsTest()
public class x7SIdeasContentDocumentLinkTriggerTest {

	@TestSetup static void setupTest() {
		insert new ContentVersion(
			Title = 'Test_Document.txt',
			VersionData = Blob.valueOf('content body.'),
			SharingPrivacy = 'N',
			SharingOption = 'A',
			Origin = 'H',
			PathOnClient = '/Test_Document.txt'
		);

		Account account = new Account(Name = 'Test Account');
		insert account;
		insert new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = account.Id);
	}

	@IsTest
	static void testTrigger() {
		//prepare data
		List<ContentVersion> contentVersions = new List<ContentVersion>([
			SELECT Id, ContentDocumentId
			FROM ContentVersion
		]);

		List<Contact> contacts = [SELECT Id FROM Contact];

		System.debug(contentVersions.size());
		System.assertNotEquals(0, contentVersions.size(), 'ContentVersion records should have been retrieved');

		List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();

		documentLinks.add(
			new ContentDocumentLink(
				ContentDocumentId = contentVersions[0].ContentDocumentId,
				LinkedEntityId = contacts[0].Id,
				ShareType = 'I'
			)
		);

		//test functionality
		Test.startTest();
		insert documentLinks;
		Test.stopTest();
	}
}