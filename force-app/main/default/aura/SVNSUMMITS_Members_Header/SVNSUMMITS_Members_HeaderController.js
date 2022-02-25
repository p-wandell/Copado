/*
 * Copyright (c) 2018. 7Summits Inc.
 */
({
	setNoOfMembers: function (component, event, helper) {
		var numberOfMembers = event.getParam("totalResults");
		component.set("v.numberOfMembers", numberOfMembers);
	},

	selectSortBy: function (component, event, helper) {
		var appEvent = $A.get("e.c:SVNSUMMITS_Members_SortBy_Event");

		appEvent.setParams({
			"sortBy": component.get('v.sortBy')
		});

		appEvent.fire();
	}
})