/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 8/9/17.
 */
({
	init: function (component, event, helper) {
		helper.doCallout(component, 'c.getOrder', {'setting': component.get('v.setting')})
			.then($A.getCallback(function (model) {
				component.set('v.optionsQuantity', model.quantityList);

				component.set('v.model',     model);
				component.set('v.cartItems', model.items);
				component.set('v.usePoints', model.usePoints);
			}));

		$A.get("e.c:ss_cart_button_event").setParams({'buttonMode': 'return'}).fire();
	},

	handleCartUpdate: function (component, event, helper) {
		let action      = event.getParam('action');
		let productId   = event.getParam('itemId');
		let quantity    = event.getParam('quantity');
		let name        = event.getParam('name');
		let setting     = component.get('v.setting');

		helper.doCallout(component, 'c.updateOrder', {
			'setting'   : setting,
			'action'    : action,
			'productId' : productId,
			'quantity'  : quantity})
			.then($A.getCallback(function(model) {
				component.set('v.model',     model);
				component.set('v.cartItems', model.items);

				switch(action) {
					case helper.action.DELETE:
						helper.showMessage(
							helper.action.SUCCESS,
							component.get('v.titleDeleted'),
							component.get('v.labelDeleted').replace('{0}', name));
						break;
					case helper.action.CLEAR:
						helper.showMessage(
							helper.action.SUCCESS,
							component.get('v.titleClear'),
							component.get('v.labelCleared'));
						break;
				}
			}));
	}
});