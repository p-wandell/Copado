/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 9/29/17.
 */
({
	init: function (component, event, helper) {
		// default alignment is start but cannot be specified - rip it out
		let align = component.get('v.cartAlign');

		if (align === 'start') {
			$A.util.removeClass(component.find('cartControl'), 'horizontalAlign');
		}

		helper.getOrder(component)
	},

	handleCartMode: function (component, event, helper) {
		component.set('v.buttonMode', event.getParam('buttonMode'));

		helper.getOrder(component);
	},

	handleAddItemToCart: function (component, event, helper) {
		let action      = event.getParam('action');
		let itemId      = event.getParam('itemId');
		let quantity    = event.getParam('quantity');
		let productName = event.getParam('name');
		let setting     = component.get('v.setting');

		let title = component.get('v.toastTitle');

		if (action === helper.action.ADD) {
			helper.doCallout(component, 'c.updateOrder', {
				'setting'  : setting,
				'action'   : helper.action.ADD,
				'productId': itemId,
				'quantity' : quantity}, false, title)
			.then($A.getCallback(function (model) {
				let count = 0;
				for(let cnt=0; cnt < model.items.length; ++cnt) {
					count += model.items[cnt].quantity;
				}

				let total = model.subTotal;

				component.set('v.model',     model);
				component.set("v.itemCount", count);
				component.set('v.itemTotal', total);

				if (component.get('v.singleButton')) {
					let buttonText = component.get('v.singleButtonLabel');

					if (component.get('v.showCount')) {
						buttonText += ' (' + count + ')';
					}
					component.set('v.singleButtonText', buttonText);
				}

				helper.showMessage(
					helper.action.SUCCESS,
					title,
					component.get('v.toastMessage')
							 .replace('{0}', quantity)
							 .replace('{1}', productName));
			}));
		}
		else {
			helper.getOrder(component);
		}
	},

	gotoCart: function (component, event, helper) {
		helper.gotoUrl(component, component.get('v.cartUrl'));
	},

	gotoCatalog: function (component, event, helper) {
		helper.gotoUrl(component, component.get('v.catalogUrl'));
	}
});