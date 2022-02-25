/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/20/17.
 */

({
	init: function (component, event, helper) {
		helper.doCallout(component, 'c.getPicklistValues',
			{
				objName  : 'Product2',
				fieldName: 'Family'
			}, true, 'Get Family Picklist')
			.then($A.getCallback(function (values) {
				values.unshift($A.get("$Label.c.ss_pc_selectAll"));
				component.set('v.familyValues', values);
			}));
	},

	searchProducts: function (component, event, helper) {
		let searchString    = component.get('v.searchProductCode');
		let searchThreshold = component.get('v.searchThreshold');

		if (searchString.length === 0 || searchString.length >= searchThreshold) {
			helper.fireSearchEvent(component);
		}
	},

	filterProducts: function (component, event, helper) {
		helper.fireSearchEvent(component);
	},

	sortProducts: function (component, event, helper) {
		helper.fireSearchEvent(component);
	},

	updateFilter: function (component, event, helper) {
		let selectedValue = event.getParam('searchProductFamily');
		component.set('v.searchProductFamily', selectedValue);
	}
});