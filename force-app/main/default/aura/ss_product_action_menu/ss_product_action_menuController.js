/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/17/18.
 */
({
	init: function(component, event, helper) {
		let flowitems = component.get('v.actionItems');
		console.log(JSON.parse(JSON.stringify(flowitems)));
	},

	handleMenuSelect: function(component, event, helper) {
		let actionItems     = component.get('v.actionItems');
		let selectedAction  = event.getParam("value");
		let actionItem      = helper.findAction(actionItems.items, selectedAction);
		let recordId        = component.get('v.recId');
		let product         = component.get('v.product');
		let productId       = product.productId;

		switch(actionItem.actionType) {
			case 'Flow':
				helper.startFlow(component, actionItem.actionValue, product, recordId);
				break;
			case 'URL':
				helper.gotoUrl(component, helper.formatString(actionItem.actionValue, productId, recordId));
				break;
		}
	},

	flowStatusChange: function (component, event, helper) {
		let status  = event.getParam('status');
		let label   = event.getParam('flowTitle');

		let message = 'Flow completed';
		let toastType = status === 'FINISHED_SCREEN' ? 'info' : 'error';

		helper.showToast(component, 'flowToast', label, message, toastType);
	}
});