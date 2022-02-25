/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/13/17.
 */
({
	fireCartEvent: function (component, action) {
		let item = component.get('v.cartItem');

		let productId = item.productId;
		let quantity  = item.quantity;
		let unitPrice = item.unitPrice;
		let name       = item.name;

		$A.get("e.c:ss_cart_event").setParams({
			'action'    : action,
			'itemId'    : productId,
			'name'      : name,
			'unitPrice' : unitPrice,
			'quantity'  : quantity
		}).fire();
	}
});