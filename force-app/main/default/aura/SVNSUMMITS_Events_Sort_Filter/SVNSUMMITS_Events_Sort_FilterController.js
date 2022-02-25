// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	setSortOption: function (component, event, helper) {
		let sortBy = component.get('v.sortBy');

		if (sortBy === 'Upcoming') {
			helper.sortByUpcoming(component);
		} else if (sortBy === 'TopAttendees') {
			helper.sortByTopAttendees(component);
		}
	},

	setDisplayMode : function (component, event, helper) {
		let listViewMode = event.getParam("listViewMode");
		component.set("v.listViewMode", listViewMode);
	}
});