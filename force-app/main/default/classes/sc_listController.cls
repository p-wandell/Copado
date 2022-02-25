/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 8/4/17.
 */

public with sharing class sc_listController {

	private static final String ACTION_ADD    = 'add';
	private static final String ACTION_UPDATE = 'update';
	private static final String ACTION_DELETE = 'delete';
	private static final String ACTION_CLEAR  = 'clear';
	
	/* ------------------------------------------------------------------------
	 *  Public AURA methods
	 */

	@AuraEnabled
	public static sc_listModel getOrder(String setting)
	{
		return getOrder(UserInfo.getUserId(), new ss_settings(setting));
	}

	@AuraEnabled
	public static sc_listModel updateOrder(String setting, String productId, Decimal quantity, String action)
	{
		ss_settings  settings = new ss_settings(setting);
		String       userId   = UserInfo.getUserId();

		updateOrder(userId, settings, productId, quantity, action);

		return getOrder(userId, settings);
	}

	@AuraEnabled
	public static Boolean placeOrder(String setting, String orderId)
	{
		sc_listModel model    = getOrder(UserInfo.getUserId(), new ss_settings(setting));

		return model.orderId == orderId ?  activateOrder(model) : false;
	}


	/* ------------------------------------------------------------------------
	 * Public methods and constants
	 */

	private final static String STATUS_DRAFT  = 'draft';
	private final static String STATUS_ACTIVE = 'activated';

	public static sc_listModel getOrder(String userId, ss_settings settings)
	{
		sc_listModel model = new sc_listModel();

		model.userId         = userId;
		model.usePoints      = settings.usePoints;
		model.quantityList   = settings.quantityList;
		model.enableDiscount = settings.enableDiscount;
		model.pricebookId    = getPriceBookId(settings);

		String query = getOrderFieldsClause();
		query += getOrderFromClause();
		query += getOrderWhereClause(userId);
		query += ' LIMIT 1';

		List<Order> orders = Database.query(query);

		if (orders.size() > 0)
		{
			Order currentOrder  = orders[0];

			model.record        = currentOrder;
			model.orderId       = currentOrder.Id;
			model.orderNumber   = currentOrder.OrderNumber;
			model.subTotal      = currentOrder.TotalAmount;

			// get items
			List<OrderItem> items = getOrderItems(model.orderId);

			if (items.size() > 0)
			{
				String   communityUrl = pc_model.getCommunityUrl();
				List<Id> productIds   = new List<Id>();

				for (OrderItem item : items) {
					productIds.add(item.Product2.Id);
				}

				Decimal totalItems = 0;
				Decimal totalPoints = 0;
				List<ContentDocumentLink> documentLinkList = ss_contentDocument.getContentDocumentLinks(productIds);

				for(OrderItem item : items)
				{
					List<ContentDocumentLink> links = ss_contentDocument.containsEntityId(documentLinkList, item.Product2.Id);

					if (settings.usePoints) { item.UnitPrice = item.Product2.Points__c;}

					model.items.add(new sc_model(item, communityUrl, links == null || links.size() == 0 ? null : links[0].ContentDocument.LatestPublishedVersionId));
					totalItems += item.Quantity;

					if (settings.usePoints) { totalPoints += (item.Product2.Points__c * item.Quantity);}
				}

				model.totalItems = totalItems;

				if (settings.usePoints) { model.subTotal = totalPoints;}
			}
		}

		return model;
	}

	public static void updateOrder(String userId, ss_settings settings, String productId, Decimal quantity, String action)
	{
		System.debug('updateOrder(' + userId + ',' + settings + ',' + productId + ',' + quantity + ',' + action + ')');
		sc_listModel model = getOrder(userId, settings);

		if (model.orderId == null)
		{
			System.debug('Order not found');

			if (action == ACTION_ADD)
			{
				Order newOrder = createOrder(settings, model);
				System.debug('createOrder : ' + newOrder);
				try
				{
					insert newOrder;
				}
				catch (Exception e) {
					throw new AuraHandledException('updateOrder() - Create Order Exception: ' + e.getMessage());
				}

				model = getOrder(userId, settings);
			}
			else
			{
				return;
			}
		}

		if (action == ACTION_CLEAR)
		{
			if (model.items.size() > 0)
			{
				List<OrderItem> items = getOrderItems(model.orderId);
				delete items;

				return;
			}
		}

		OrderItem item = findOrderItem(model, productId);

		if (item == null)
		{
			if (action == ACTION_ADD)
			{
				item = createOrderItem(settings, model, productId, 0);
				System.debug('createOrderItem : ' + item);
			}
			else
			{
				return;
			}
		}

		if (action == ACTION_DELETE)
		{
			delete item;
			return;
		}

		item.Quantity = action == ACTION_ADD ? item.Quantity + quantity : quantity;

		try
		{
			upsert item;
		}
		catch (Exception e) {
			throw new AuraHandledException('updateOrder() - insert item Exception: ' + e.getMessage());
		}
	}

	public static OrderItem findOrderItem(sc_listModel model, String productId)
	{
		if (model.items.size() > 0 )
		{
			for (sc_model item: model.items)
			{
				if (item.productId == productId)
				{
					return (OrderItem)item.record;
				}
			}
		}

		return null;
	}

	public static Order createOrder(ss_settings settings, sc_listModel model)
	{
		// get the contact record for the current user
		User currentUser = [SELECT Id, Name, AccountId FROM User WHERE Id = :model.userId LIMIT 1];
		String accountId = currentUser.AccountId;

		if (String.isBlank(accountId))
		{
			if (String.isNotBlank(settings.accountId) && UserInfo.getUserType() == 'Standard') { accountId = settings.accountId;}
		}

		Order newOrder = new Order(
			AccountId     = accountId,
			EffectiveDate = System.today(),
			OwnerId       = model.userId,
			Status        = STATUS_DRAFT,
			Pricebook2Id  = model.pricebookId);

		return newOrder;
	}

	public static Boolean activateOrder(sc_listModel model)
	{
		Order currentOrder = (Order) model.record;

		if (currentOrder != null && currentOrder.Status == STATUS_DRAFT)
		{
			currentOrder.Status = STATUS_ACTIVE;
			upsert currentOrder;

			System.debug('Changed order status');
			return true;
		}

		System.debug('failed to change order status');
		return false;
	}

	public static List<OrderItem> getOrderItems(String orderId)
	{
		String query = getOrderItemFieldsClause();
		query += getOrderItemFromClause();
		query += getOrderItemWhereClause(orderId);

		List<OrderItem> items = Database.query(query);

		return items;
	}

	public static OrderItem createOrderItem(ss_settings settings, sc_listModel model, String productId, Decimal quantity)
	{
		System.debug('createOrderItem(' + productId + ',' + quantity + ') ');

		pc_model product = pc_listController.getProductById(settings, productId);
		System.debug('    found product ' + product.productId);

		OrderItem newItem = new OrderItem(OrderId = Id.valueOf(model.orderId), Product2Id = Id.valueOf(productId), PricebookEntryId = Id.valueOf(product.id), UnitPrice = product.unitPrice, Quantity = quantity);

		return newItem;
	}

	/*
	 * private methods
	 */

	// PriceBook fallback if not specified in Metadata settings - special mode for testing
	private static String getPriceBookId(ss_settings settings)
	{
		String priceBookId = settings.pricebookId;

		// cannot access the pricebook(s) in test mode
		if (String.isBlank(priceBookId)) {
			if (Test.isRunningTest()) { priceBookId = Test.getStandardPricebookId(); } else { priceBookId = [SELECT Id, Name FROM Pricebook2 WHERE PriceBook2.IsStandard = TRUE LIMIT 1].Id;}
		}
		return priceBookId;
	}

	/*
	 * Database helpers
	 */
	private static String getOrderFieldsClause()
	{
		String fieldsClause = 'SELECT'
			+ ' Id'
			+ ', Status'
			+ ', AccountId'
			+ ', OwnerId'
			+ ', OrderNumber'
			+ ', TotalAmount'
			+ ', Pricebook2Id';

		return fieldsClause;
	}

	private static String getOrderFromClause()
	{
		String fromClause = ' FROM Order';

		return fromClause;
	}

	private static String getOrderWhereClause(String userId)
	{
		String whereClause = ' WHERE status = \'';
		whereClause += STATUS_DRAFT;
		whereClause += '\'';
		whereClause += ' and OwnerId = \'';
		whereClause += userId;
		whereClause += '\'';

//		system.debug('Order where clause: ' + whereClause);

		return whereClause;
	}

	private static String getOrderItemFieldsClause()
	{
		String fieldsClause = 'SELECT'
			+ ' Id'
			+ ', OrderItemNumber'
			+ ', Product2.Id'
			+ ', Product2.Name'
			+ ', Product2.ProductCode'
			+ ', Product2.Points__c'
			+ ', Product2.Family'
			+ ', Product2.External_Image_URL__c'
			+ ', UnitPrice'
			+ ', Quantity'
			+ ', PricebookEntryId';

		return fieldsClause;
	}

	private static String getOrderItemFromClause()
	{
		return ' FROM OrderItem';
	}

	private static String getOrderItemWhereClause(String orderId)
	{
		return ' WHERE OrderId = \'' + orderId + '\'';
	}
}