/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/6/17.
 */

@IsTest
public class ss_testUtil
{
	public static User createTestUser(String testUserName, String accountName)
	{
		Id      profileId = [SELECT Id FROM Profile
						WHERE Name = 'Partner Community User' OR Name = '7S Customer Community Login User'
						LIMIT 1].Id;

		Account acc = (Account) ss_testFactory.createSObject(new Account(Name = accountName), true);
		Contact con = (Contact) ss_testFactory.createSObject(new Contact(LastName = 'testCon', AccountId = acc.Id), true);
		User    usr = (User) ss_testFactory.createSObject(new User(
			Alias               = 'test123',
			Email               = 'test123@noemail.com',
			EmailEncodingKey    = 'UTF-8',
			LastName            = 'Testing',
			LanguageLocaleKey   = 'en_US',
			LocaleSidKey        = 'en_US',
			ProfileId           = profileId,
			Country             = 'United States',
			IsActive            = true,
			ContactId           = con.Id,
			TimeZoneSidKey      = 'America/Chicago',
			Username            = testUserName), true);

		System.assertNotEquals(null, usr);

		return usr;
	}

	public static Id createTestProducts (Integer testSize, Boolean createCustomPricebook)
	{
		// This is tricky - getting hold of the Std pricebook in a Unit test
		// the only way to get price book entries  is to use a Custom Pricebook that is active
		// Also using Test.isRunningTest() in the pc_listController to make this work
		Id pricebookId = Test.getStandardPricebookId();

		Pricebook2 pBook = new Pricebook2(Name = 'testBook_1', IsActive = true);
		insert pBook;
		System.debug('testPriceBook: ' + pBook);

		List<Product2> products = new List<Product2>();
		Integer multiplier = 0;

		for (Integer i = 0; i < testSize; i++)
		{
			products.add(new Product2(
				Name        = 'Product' + i,
				ProductCode = 'PC' + i + '-000' + 1,
				Description = 'Description' + i,
				DisplayUrl  = 'www.salesforce/com',
				IsActive    = true,
				Featured__c = Math.mod(i, 2) == 0,
				Sequence__c = i,
				Points__c   = 100 + (testSize * multiplier),
				Family      = i == 0 ? 'None' : 'Main'));

			multiplier += 1;
		}
		insert products;

		// std price book entries
		List<PricebookEntry> stdEntries = new List<PricebookEntry>();
		multiplier = 0;

		for (Product2 productEntry : products)
		{
			stdEntries.add(new PricebookEntry(
				Pricebook2Id = pricebookId,
				Product2Id   = productEntry.Id,
				IsActive     = true,
				UnitPrice    = 150 + (testSize * multiplier)));

			multiplier += 1;
		}
		insert stdEntries;

		if (createCustomPricebook)
		{
			// custom price book entries
			List<PricebookEntry> cstEntries = new List<PricebookEntry>();
			multiplier = 0;

			for (Product2 productEntry : products)
			{
				cstEntries.add(new PricebookEntry(
					Pricebook2Id = pBook.Id,
					Product2Id = productEntry.Id,
					IsActive = true,
					UnitPrice = 100 + (testSize * multiplier)));

				multiplier += 1;
			}
			insert cstEntries;
		}

		// Content documents - images
		ContentVersion content = new ContentVersion(
			Title          = 'Image',
			PathOnClient   = 'Image.png',
			VersionData    = Blob.valueOf('Test Content'),
			IsMajorVersion = true);
		insert content;

		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

		for (Product2 product : products)
		{
			// skip the first to test the else on linked image
			if (product.Name != 'Product0')
			{
				ContentDocumentLink cdl = new ContentDocumentLink();
				cdl.LinkedEntityId      = product.Id;
				cdl.ContentDocumentId   = documents[0].Id;
				cdl.ShareType           = 'V';

				insert cdl;
			}
		}

		System.assertNotEquals(null, pBook);
		return pBook.Id;
	}
}