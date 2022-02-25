// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	// initialize the date section
	doInit: function (component, event, helper) {
	},

	clearDates: function (component, event, helper) {
		component.set('v.fromDt', '');
		component.set('v.toDt', '');

		helper.setDates(component);
	},

	setDisplayMode: function (component, event, helper) {
		let listViewMode = event.getParam("listViewMode");
		component.set("v.listViewMode", listViewMode);
	},

	//Dates Values Section
	setDates: function (component, event, helper) {
		helper.setDates(component);
	}
});