/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 9/29/17.
 */
({
	onRemoveItem : function (component, event, helper) {
		helper.fireCartEvent(component, helper.action.DELETE);
	},

	onQuantityChanged: function(component, event, helper){
		let item = component.get('v.cartItem');
		let quantity  = item.quantity;

		if (quantity > 0) {
			helper.fireCartEvent(component, helper.action.UPDATE);
		}
	},

	gotoProduct : function (component, event, helper) {
		helper.gotoRecord(component, component.get('v.cartItem').productId);
	}
});