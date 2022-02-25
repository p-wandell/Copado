/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/21/17.
 */
({
	init: function (component, event, helper) {
		$A.get("e.c:ss_cart_button_event").setParams({'buttonMode': 'cart'}).fire();

		helper.doCallout(component, 'c.getProductFamilyList',
			{'setting': component.get('v.setting')}, false, 'Get Product Family List')
			.then($A.getCallback(function (list) {
				component.set('v.familyList', list);
			}));
	}
});