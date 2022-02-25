/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 9/29/17.
 */
({
	init: function (component, event, helper) {
		if (component.get('v.skipPayment')) {
			component.set('v.labelCheckout', component.get('v.labelPlaceOrder'));
		}

		helper.doCallout(component, 'c.getOrder', {'setting': component.get('v.setting')})
			.then($A.getCallback(function (model) {

				model.estimatedTotal =  model.subTotal;
				model.discountTotal  = 0.0;

				if (model.enableDiscount) {
					let discount = component.get('v.discount');

					if (discount) {
						let discountValue = Number(discount);
						if (discountValue !== NaN && discountValue > 0) {
							model.discountTotal  = model.subTotal * discountValue;
							model.estimatedTotal = model.subTotal - model.discountTotal;
						}
					}
				}

				component.set('v.model',     model);
				component.set('v.cartItems', model.items);
				component.set('v.usePoints', model.usePoints);
			}));
	},

	gotoCheckout : function (component, event, helper) {
		if (component.get('v.skipPayment')) {
			let model   = component.get('v.model');
			let setting = component.get('v.setting');

			helper.doCallout(component, 'c.placeOrder',
				{
					'setting' : setting,
					'orderId' : model.orderId
				}, true, '')
				.then($A.getCallback(function (result) {
					if (result) {
						let message   = component.get('v.toastPlacedOrder').replace('{0}', model.orderNumber);
						let detailUrl = component.get('v.orderDetailUrl');

						helper.showMessage(helper.action.SUCCESS, component.get('v.labelPlaceOrder'), message);

						if (detailUrl) {
							helper.gotoUrl(component, detailUrl);
						}
						else {
							helper.gotoRecord(component, model.orderId);
						}
					}
			}));
		} else {
			helper.gotoUrl(component, component.get('v.checkoutUrl'));
		}

		$A.get("e.c:ss_cart_button_event").setParams({'buttonMode': 'cart'}).fire();
	}
});