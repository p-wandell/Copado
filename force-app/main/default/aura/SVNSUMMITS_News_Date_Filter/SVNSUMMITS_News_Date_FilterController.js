// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	dateChange: function (component, event, helper) {
		helper.sendFilterEvent(component);
	},

	clearDates: function (component, event, helper) {
		component.set('v.startDate', '');
		component.set('v.endDate', '');

		helper.sendFilterEvent(component);
	}
})