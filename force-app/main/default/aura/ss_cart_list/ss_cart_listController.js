/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francoiskorb on 11/16/17.
 */
({
	onClearCart: function (component, event, helper) {
		$A.get("e.c:ss_cart_event").setParams({
			'action'    : helper.action.CLEAR,
			'name'      : 'All Items',
			'productId' : '',
			'quantity'  : 0
		}).fire();
	}
});