/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francoiskorb on 11/28/17.
 */

@IsTest
public with sharing class pc_suggestController_test
{
	@TestSetup
	static void createTestData()
	{
		String priceBookId = ss_testUtil.createTestProducts(1, true);
		System.assertNotEquals(null, priceBookId);
	}

	@IsTest
	static void testSuggestController()
	{
		System.debug('testSuggestController');
		String setting      = '';
		String searchFilter = '';
		String familyFilter = '';
		String sortOrder    = '';

		Test.startTest();
		pc_listModel model = pc_listController.getProducts(setting, 1, 0, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertNotEquals(null, model);
		System.assert(model.items.size() > 0);
		System.assertNotEquals(null, model.items[0]);
		System.debug('item 0 : ' + model.items[0]);
		pc_model firstItem = pc_listController.getProductById(setting, model.items[0].productId);
		System.assertNotEquals(null, firstItem);

		pc_suggestController.sendSuggestedEmail(setting, 'testUser1', 'testUser1@testmai.url', model.items[0].productId);
		Test.stopTest();
	}
}