/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 12/28/17.
 */

({

	custom : {
		MAX_FIELDS       : 6,
		SEARCH_SEPARATOR : ';',
		FIELD_SEPARATOR  : ',',
		SEARCH_FIELD     : ':'
	},

	layout : {
		TILE : 'Tile',
		LIST : 'List'
	},

	contact : {
		fields : {
			firstName: 'Contact.FirstName',
			lastName : 'Contact.LastName',
			title    : 'Contact.Title',
			country  : 'Contact.MailingCountry',
			state    : 'Contact.MailingState',
			city     : 'Contact.MailingCity',
			account  : 'Account.Name'
		},
		auraId : {
			title    : 'titleTypeAhead',
			country  : 'countryTypeAhead',
			state    : 'stateTypeAhead',
			city     : 'cityTypeAhead',
			account  : 'accountTypeAhead'
		},
		values : {
			title    : 'v.titleValues',
			country  : 'v.countryValues',
			state    : 'v.stateValues',
			city     : 'v.cityValues',
			account  : 'v.accountValues'
		}
	},

	changeContactToUserFields : function (component) {
		this.contact.fields.firstName = 'FirstName';
		this.contact.fields.lastName  = 'LastName';
		this.contact.fields.title     = 'Title';
		this.contact.fields.country   = 'Country';
		this.contact.fields.state     = 'State';
		this.contact.fields.city      = 'City';
	},

	gotoUrl: function (component, url) {
		$A.get("e.force:navigateToURL")
			.setParams({
				'url'       : url,
				'isredirect': true
			}).fire();
	},

	gotoRecord: function (component, recordId) {
		$A.get("e.force:navigateToSObject")
			.setParams({
				"recordId"    : recordId,
				"slideDevName": "related"
			}).fire();
	},

	showMessage: function (level, title, message) {
		console.log("Message (" + level + "): " + message);

		$A.get("e.force:showToast")
			.setParams({
				"title"  : title,
				"message": message,
				"type"   : level
			}).fire();
	},


	debug: function (component, msg, variable) {
		if (component.get("v.debugMode")) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}
});