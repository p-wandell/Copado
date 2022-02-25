/*
 * Copyright (c) 2018. 7Summits Inc.
 */
({
	doInit: function (component, event, helper) {
		var useContact = component.get('v.useContact');

		// change to User record if we are NOT using the contact record
		if (!useContact) {
			helper.changeContactToUserFields(component);
		}

		helper.getPicklists(component);
	},

	onFilterMembers: function (component, event, helper) {
		helper.fireSearchEvent(component, false);
	},

	handleEnableLastFirst: function (component, event, helper) {
		if (component.get('v.searchLastName')) {
			$A.util.removeClass(component.find('searchLastFirstButton'), 'slds-hide');
		}
		else {
			$A.util.addClass(component.find('searchLastFirstButton'), 'slds-hide');
		}
	},

	searchLastFirstName: function (component, event, helper) {
		helper.fireSearchEvent(component);
	},

	searchMembers: function (component, event, helper) {
		var threshold       = component.get('v.searchThreshold');
		var searchString    = component.get('v.searchString');
		var searchLastFirst = component.get('v.searchLastName');

		if (!searchLastFirst && (searchString.length === 0 || searchString.length >= threshold)) {
			helper.fireSearchEvent(component, false);
		}
	},

	onContactTypeAhead: function (component, event, helper) {
		var fieldId = event.getSource().getLocalId();
		var lookup  = fieldId.split('Type')[0];

		helper.clearInvalidField(component, fieldId);

		var threshold    = component.get('v.searchThreshold');
		var searchString = component.get('v.' + fieldId);

		if (searchString.length === 0 || searchString.length >= threshold) {
			helper.getMemberPicklistValues(
				component,
				fieldId,
				helper.contact.fields[lookup],
				helper.contact.values[lookup],
				searchString);
		}
	},

	onCustomTypeAhead: function (component, event, helper) {
		var field = event.getSource().getLocalId();
		var pos   = field.slice(-1);

		helper.clearInvalidField(component, field);

		var threshold    = component.get('v.searchThreshold');
		var searchString = component.get('v.typeAheadField' + pos);

		if (searchString.length === 0 || searchString.length >= threshold) {
			var customField = component.get('v.customField' + pos);
			helper.getMemberPicklistValues(
				component,
				field,
				customField,
				'v.customValuesField' + pos,
				searchString);
		}
	},

	onSearchCustomField: function (component, event, helper) {
		var pos = event.target.name.slice(-1);

		var threshold    = component.get('v.searchThreshold');
		var searchString = component.get('v.searchCustomField' + pos);

		if (searchString.length === 0 || searchString.length >= threshold) {
			helper.fireSearchEvent(component, false);
		}
	},

	clearAll: function (component, event, helper) {
		component.set('v.showMyMembers', false);
		component.set('v.searchString', '');
		component.set('v.disableClear', true);

		component.set('v.titleSearch', '');
		component.set('v.countrySearch', '');
		component.set('v.stateSearch', '');
		component.set('v.citySearch', '');
		component.set('v.accountSearch', '');

		component.set('v.topicSearch', '');
		component.set('v.titleTypeAhead', '');
		helper.clearInvalidField(component, 'titleTypeAhead');
		component.set('v.countryTypeAhead', '');
		helper.clearInvalidField(component, 'countryTypeAhead');
		component.set('v.stateTypeAhead', '');
		helper.clearInvalidField(component, 'stateTypeAhead');
		component.set('v.cityTypeAhead', '');
		helper.clearInvalidField(component, 'cityTypeAhead');
		component.set('v.accountTypeAhead', '');

		helper.clearInvalidField(component, 'accountTypeAhead');
		for (var pos = 1; pos <= helper.custom.MAX_FIELDS; pos++) {
			component.set('v.typeAheadField' + pos, '');
			component.set('v.searchCustomField' + pos, '');
			helper.clearInvalidField(component, 'typeAheadCustomField' + pos);

		}

		helper.getPicklists(component);
		helper.fireSearchEvent(component, true);
	},

	// listen for the data loaded event from the list controller and hide the spinner
	dataLoaded : function (component, event, helper) {
		helper.hideSpinner(component);
	}
});