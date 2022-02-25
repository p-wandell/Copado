// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function(component, event, helper) {
		if (component.get('v.showPickLists')) {
			helper.getPicklists(component);
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
			helper.getEventPicklistValues(
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

	onFilterEvents : function (component, event, helper) {
		helper.fireSearchEvent(component, false);
	}
})