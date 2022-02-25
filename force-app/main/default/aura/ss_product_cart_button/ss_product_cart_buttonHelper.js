/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/1/17.
 */
({
	addToCart: function (component) {
		let self = this;

		let productId   = component.get("v.productId");
		let productName = component.get('v.productName');
		let unitPrice   = component.get('v.unitPrice');
		let quantity    = component.get('v.quantity');

		console.log("Add to cart: " + productId);

		$A.get("e.c:ss_cart_event").setParams({
			'action'    : this.action.ADD,
			'itemId'    : productId,
			'name'      : productName,
			'unitPrice' : unitPrice,
			'quantity'  : quantity
		}).fire();

		component.set('v.quantity', 1);

		// Toggle the button label for a while
		component.set('v.buttonAdd', component.get('v.buttonLabelAdded'));
		component.set('v.buttonVariant', this.custom.BUTTON_SUCCESS);

		window.setTimeout(function() {
			component.set('v.buttonAdd', component.get('v.buttonLabelAdd'));
			component.set('v.buttonVariant', self.custom.BUTTON_BRAND);
		}, this.custom.BUTTON_DELAY);
	}
});