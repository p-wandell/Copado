/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/20/18.
 */

public with sharing class sc_actionMethods
{
	/*
	 * Flow Methods
	 */
	@InvocableMethod
	public static List<String> addToCart(List<ss_actionInput> input)
	{
		List<String> result = new List<String>();

		String recordId, productId, quantity;

		for (ss_actionInput inputItem : input)
		{
			switch on inputItem.name
			{
				when 'recordId'
				{
					recordId = inputItem.value;
				}
				when 'productId'
				{
					productId = inputItem.value;
				}
				when 'quantity'
				{
					quantity = inputItem.value;
				}
			}
		}

		if (String.isNotBlank(recordId) && String.isNotBlank(productId))
		{
			ss_settings settings = new ss_settings();
			Decimal     qty      = Decimal.valueOf(quantity);

			sc_listController.updateOrder(recordId, settings, productId, qty, 'add');
			sc_listModel order = sc_listController.getOrder(recordId, settings);

			result.add(order.orderId);
		}

		return result;
	}
}