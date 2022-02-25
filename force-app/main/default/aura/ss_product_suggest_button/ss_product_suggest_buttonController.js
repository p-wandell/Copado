/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/2/17.
 */
({
	// NOTE
	// This code assumes we are on the Contact record and pulls the contact ID from the URL
	// This will fail if not called whilst on the contact page

	suggestToUser: function (component, event, helper) {
		let self = helper;

		let url       = window.location.href;
		let urlParts  = url.split("/");
		let urlLength = urlParts.length;
		let contactId = urlParts[urlLength-2];

		let dataRecord = component.find('contactDataRecord');
		component.set('v.contactId', contactId);

		component.set('v.buttonSuggest', component.get('v.buttonLabelSuggested'));
		component.set('v.buttonVariant', self.custom.BUTTON_INVERSE);

		window.setTimeout(function() {
			component.set('v.buttonSuggest', component.get('v.buttonLabelSuggest'));
			component.set('v.buttonVariant', self.custom.BUTTON_BRAND);
		}, self.custom.BUTTON_DELAY);

		dataRecord.reloadRecord();
	},

	handleUserLoaded: function (component, event, helper) {
		let eventParams = event.getParams();

		if (eventParams.changeType === 'LOADED') {
			let contact = component.get('v.targetContact');
			let message = component.get('v.toastMessage')
							.replace('{0}', contact.Name)
							.replace('{1}', component.get('v.productName'));

			helper.doCallout(component, 'c.sendSuggestedEmail',
				{
					'contactName'  : contact.Name,
					'contactEmail' : contact.Email,
					'productId'    : component.get('v.productId')
				}, false, 'Suggest Product')
				.then($A.getCallback(function () {
					helper.showMessage('success', 'Suggestion', message);
				}));
		}
		else if (eventParams.changeType === 'ERROR') {
			console.log('Error loading contact information for suggesting a product');
			helper.showMessage('error', 'Suggestion', 'Failed to load contact information');
		}
	}
});