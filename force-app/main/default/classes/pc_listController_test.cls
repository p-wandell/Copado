/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/18/17.
 */

@IsTest
public with sharing class pc_listController_test
{
	// test constants
	static final Decimal PAGE_SIZE = 10;
	static final Decimal TEST_SIZE = 5;

	@TestSetup
	static void createTestData()
	{
		String priceBookId = ss_testUtil.createTestProducts((Integer)TEST_SIZE, true);
		System.assertNotEquals(null, priceBookId);
	}

	@IsTest
	static void testListModel()
	{
		pc_listModel model = new pc_listModel();

		System.assertEquals(0, model.pageSize);
		System.assertEquals(0, model.pageCurrent);
		System.assertEquals(0, model.total);
		System.assertEquals(0, model.items.size());
	}

	@IsTest
	static void testGetProductFilters()
	{
		Test.startTest();

		String setting      = '';
		String searchFilter = '';
		String familyFilter = '';
		String sortOrder    = '';

		pc_listModel model = pc_listController.getProducts(setting, 0, 0, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(10, model.pageSize);
		System.assertEquals(1, model.pageCurrent);

		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(TEST_SIZE, model.total);
		System.assertNotEquals(null, model.usePoints);
		model.dumpModel('PageSize');

		familyFilter = 'None';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(1, model.total);

		familyFilter = '';
		searchFilter = 'PC1';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(1, model.total);

		familyFilter = 'None';
		searchFilter = 'PC0';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(1, model.total);

		searchFilter = 'XYZ';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(0, model.total);

		Test.stopTest();
	}

	@IsTest
	static void testOrderBy()
	{
		Test.startTest();

		String setting      = '';
		String searchFilter = '';
		String familyFilter = '';
		String sortOrder    = 'Product Name';

		pc_listModel model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(TEST_SIZE, model.total);
		System.assertEquals('Product0', model.items[0].name);

		sortOrder = 'Product Family';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(TEST_SIZE, model.total);

		sortOrder = 'Product Code';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(TEST_SIZE, model.total);

		sortOrder = 'Unit Price';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(TEST_SIZE, model.total);

		sortOrder = 'Sequence__c';
		model = pc_listController.getProducts(setting, PAGE_SIZE, 1, searchFilter, familyFilter, sortOrder, 0, 0);
		System.assertEquals(TEST_SIZE, model.total);

		Test.stopTest();
	}

	@IsTest
	static void testGetProductsById()
	{
		String setting = '';

		Test.startTest();

		pc_listModel model = pc_listController.getProducts(setting, PAGE_SIZE, 1, '', '', '', 0, 0);
		System.assertEquals(TEST_SIZE, model.total);

		pc_model locatedItem = model.getItemByProductId(model.items[0].productId);
		System.assertNotEquals(null, locatedItem);

		List<String> ids = new List<String>();
		ids.add(model.items[0].productId);
		ids.add(model.items[2].productId);

		pc_listModel products = pc_listController.getProductsById(setting, PAGE_SIZE, 1, ids);

		System.assertEquals(2, products.total);
		System.assertEquals(model.items[0].productId, products.items[0].productId);
		System.assertEquals(model.items[2].productId, products.items[1].productId);
		System.assertNotEquals(products.items[0].productId, products.items[1].productId);

		pc_model item = pc_listController.getProductById(setting, ids[0]);
		System.assertNotEquals(null, item);
		System.assertEquals(ids[0], item.productId);
		item.dumpModel('test get products by Id');

		Test.stopTest();
	}

	@IsTest
	static void testGetFeaturedProducts()
	{
		String setting = '';

		Test.startTest();

		Boolean featured = false;
		pc_listModel model = pc_listController.getProducts(setting, PAGE_SIZE, 1, '', '', '', 0, 0);
		System.assertEquals(TEST_SIZE, model.total);
		System.assertEquals(false, model.items[1].featured);

		featured = true;
		model = pc_listController.getProductsFeatured(setting, PAGE_SIZE, 1);
		System.assertEquals(Math.ceil(TEST_SIZE / 2), model.total);
		for (pc_model item : model.items)
		{
			System.assertEquals(true, item.featured);
		}

		Test.stopTest();
	}

	@IsTest
	static void testGetMinMaxPriceProducts()
	{
		Test.startTest();

		String setting      = '';
		String searchFilter = '';
		String familyFilter = '';
		String sortOrder    = '';
		Decimal minPrice    = 100 + TEST_SIZE;
		Decimal maxPrice    = 100 + (TEST_SIZE * 2);

		pc_listModel model = pc_listController.getProducts(setting, 0, 0, searchFilter, familyFilter, sortOrder, minPrice, maxPrice);
		System.assertEquals(2, model.total);

		// disable points
		Id pricebookId = Test.getStandardPricebookId();

		ss_settings settings = new ss_settings('', false, pricebookId);
		model = pc_listController.getProducts(true, settings, 0, 0, false, searchFilter, familyFilter, sortOrder, minPrice, maxPrice, null);
		System.assertEquals(2, model.total);

		Test.stopTest();
	}
}