/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 8/4/17.
 */

@IsTest
public class sc_listController_test
{
	static final Integer TEST_SIZE = 5;
	private static final String testUserName = 'tester@7s001-pc-noemail.com';

	@TestSetup
	static void setupData()
	{
		ss_testUtil.createTestUser(testUserName, 'testOrderAccount');
		String priceBookId = ss_testUtil.createTestProducts(TEST_SIZE, true);
		System.assertNotEquals(null, priceBookId);
	}

	@IsTest
	static void testListModel()
	{
		Id pricebookId = Test.getStandardPricebookId();

		Id testProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community User' OR Name = '7S Customer Community Login User' LIMIT 1].Id;

		Account testAccount = (Account) ss_testFactory.createSObject(new Account(Name = 'sc1_testOrderAccount'), true);
		System.assertNotEquals(null, testAccount);

		Contact testContact = (Contact) ss_testFactory.createSObject(new Contact(LastName = 'testCon', AccountId = testAccount.Id), true);

		User user = (User) ss_testFactory.createSObject(new User(Alias = 'test123', Email = 'tester123@noemail.com',
			EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US', ProfileId = testProfile, Country = 'United States', IsActive = true,
			ContactId = testContact.Id,
			TimeZoneSidKey = 'America/Los_Angeles', Username = 'tester001@noemail.com'), true);

		System.assertNotEquals(null, user);

		Product2 testProduct = (Product2) ss_testFactory.createSObject(new Product2(Name = 'Test Product', IsActive = true, ProductCode = 'ABC'), true);
		System.assertNotEquals(null, testProduct);

		PricebookEntry testEntry = (PricebookEntry) ss_testFactory.createSObject(new PricebookEntry(Product2Id = testProduct.Id, Pricebook2Id = pricebookId, UnitPrice = 50, IsActive = true), true);
		System.assertNotEquals(null, testEntry);

		Order testOrder = (Order) ss_testFactory.createSObject(new Order(AccountId = testAccount.Id, OwnerId=user.Id, Pricebook2Id = pricebookId, Status = 'draft', EffectiveDate = System.today()), true);
		System.assertNotEquals(null, testOrder);

		OrderItem orderItem = (OrderItem) ss_testFactory.createSObject(new OrderItem(OrderId = testOrder.Id, PricebookEntryId = testEntry.Id, Quantity = 1.0, UnitPrice = 50.0), true);
		System.assertNotEquals(null, orderItem);

		Test.startTest();
		sc_model model = new sc_model(orderItem, 'communityUrl', testProduct.Id);
		System.assertNotEquals(null, model);
		model.dumpModel('unit test');

		model = new sc_model(orderItem, '', null);
		sc_model defaultModel = new sc_model();
		System.assertNotEquals(null, defaultModel);

		Test.stopTest();
	}

	@IsTest
	static void testListController()
	{
		sc_listController controller = new sc_listController();
		System.assertNotEquals(null, controller);
	}

	@IsTest
	static void testGetOrderEmpty()
	{
		Id pricebookId = Test.getStandardPricebookId();
		User testUser = [SELECT Id, AccountId FROM User WHERE Username = :testUserName LIMIT 1];
		ss_settings settings = new ss_settings(testUser.AccountId, false, pricebookId);

		System.runAs(testUser)
		{
			Test.startTest();

			sc_listModel newOrder = sc_listController.getOrder(testUser.Id, settings);
			System.assertNotEquals(null, newOrder);
			System.assertEquals(null, newOrder.orderId);
			System.assertEquals(0, newOrder.subTotal);
			System.assertEquals(0, newOrder.items.size());
			System.assertEquals(0, newOrder.balance);

			newOrder.dumpModel('test get order - empty');

			Test.stopTest();
		}
	}


	@IsTest
	static void testCreateOrder()
	{
		Id pricebookId	    = Test.getStandardPricebookId();
		User testUser		= ss_testUtil.createTestUser('testUser01@nomail.com', 'testAccount01');
		ss_settings settings = new ss_settings(testUser.AccountId, false, pricebookId);

		sc_listModel model  = new sc_listModel();
		model.userId		= testUser.Id;
		model.balance	    = 1000;
		model.usePoints	    = settings.usePoints;
		model.pricebookId   = settings.pricebookId;

		System.runAs(testUser)
		{
			Test.startTest();

			Order newOrder = sc_listController.createOrder(settings, model);
			System.assertNotEquals(null, newOrder);
			model.orderId = newOrder.Id;

			pc_listModel prodModel = pc_listController.getProducts(true, settings, 10.0, 1.0, false,'', '', 'Product Name', 0, 0, null);
			System.assert(prodModel.items.size() > 0);
			System.assert(prodModel.items[0].productId != null);
//			OrderItem newOrderItem = sc_listController.createOrderItem(settings, model, prodModel.items[0].productId, 1);
//			System.assertNotEquals(null, newOrderItem);

			Test.stopTest();
		}
	}

	@IsTest
	static void testUpdateOrder()
	{
		Id pricebookId = Test.getStandardPricebookId();

		Id testProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community User' OR Name = '7S Customer Community Login User' LIMIT 1].Id;

		Account testAccount = (Account) ss_testFactory.createSObject(new Account(Name = 'sc2_testOrderAccount'), true);
		System.assertNotEquals(null, testAccount);

		Contact testContact = (Contact) ss_testFactory.createSObject(new Contact(LastName = 'testCon', AccountId = testAccount.Id), true);

		User user = (User) ss_testFactory.createSObject(new User(Alias = 'test123', Email = 'tester123@noemail.com',
			EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
			ProfileId = testProfile, Country = 'United States', IsActive = true, ContactId = testContact.Id,
			TimeZoneSidKey = 'America/Los_Angeles', Username = 'tester001@noemail.com'), true);

		System.assertNotEquals(null, user);

		System.runAs(user)
		{
			Product2 testProduct = (Product2) ss_testFactory.createSObject(new Product2(Name = 'Test Product 1', IsActive = true, ProductCode = 'ABC'), true);
			System.assertNotEquals(null, testProduct);

			Product2 testProduct2 = (Product2) ss_testFactory.createSObject(new Product2(Name = 'Test Product 2', IsActive = true, ProductCode = 'ABC'), true);
			System.assertNotEquals(null, testProduct);

			PricebookEntry testEntry = (PricebookEntry) ss_testFactory.createSObject(new PricebookEntry(Product2Id = testProduct.Id, Pricebook2Id = pricebookId, UnitPrice = 50, IsActive = true), true);
			System.assertNotEquals(null, testEntry);

			PricebookEntry testEntry2 = (PricebookEntry) ss_testFactory.createSObject(new PricebookEntry(Product2Id = testProduct2.Id, Pricebook2Id = pricebookId, UnitPrice = 10, IsActive = true), true);
			System.assertNotEquals(null, testEntry);

			Order testOrder = (Order) ss_testFactory.createSObject(new Order(AccountId = testAccount.Id, OwnerId = user.Id, Pricebook2Id = pricebookId, Status = 'draft', EffectiveDate = System.today()), true);
			System.assertNotEquals(null, testOrder);

			OrderItem orderItem = (OrderItem) ss_testFactory.createSObject(new OrderItem(OrderId = testOrder.Id, PricebookEntryId = testEntry.Id, Quantity = 1.0, UnitPrice = 50.0), true);
			System.assertNotEquals(null, orderItem);

			OrderItem orderItem2 = (OrderItem) ss_testFactory.createSObject(new OrderItem(OrderId = testOrder.Id, PricebookEntryId = testEntry2.Id, Quantity = 1.0, UnitPrice = 10.0), true);
			System.assertNotEquals(null, orderItem2);

			ss_settings settings = new ss_settings(testAccount.Id, false, pricebookId);

			Test.startTest();

			sc_listController.updateOrder(user.Id, settings, testProduct.Id,  2, 'add');
			sc_listController.updateOrder(user.Id, settings, testProduct.Id,  1, 'delete');
			sc_listController.updateOrder(user.Id, settings, testProduct2.Id, 2, 'add');
			sc_listController.updateOrder(user.Id, settings, testProduct2.Id, 1, 'add');
			sc_listController.updateOrder(user.Id, settings, testProduct.Id,  0, 'clear');

			orderItem = (OrderItem) ss_testFactory.createSObject(new OrderItem(OrderId = testOrder.Id, PricebookEntryId = testEntry.Id, Quantity = 1.0, UnitPrice = 50.0), true);
			sc_listModel model = sc_listController.getOrder(user.Id, settings);
			OrderItem foundItem = sc_listController.findOrderItem(model, '123');
			System.assertEquals(null, foundItem);

			model.dumpModel('Test Order');
			Boolean activated = sc_listController.activateOrder(model);
			System.assertEquals(true, activated);

			// should see the order is activated
			activated = sc_listController.activateOrder(model);
			System.assertEquals(false, activated);

			Test.stopTest();
		}
	}
}